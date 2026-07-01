#!/bin/bash
set -euxo pipefail

# --------------------------------------------------
# Log User Data Output
# --------------------------------------------------
exec > >(tee /var/log/user-data.log)
exec 2>&1

# --------------------------------------------------
# Update System
# --------------------------------------------------
dnf update -y

# --------------------------------------------------
# Install Docker and Git
# --------------------------------------------------
dnf install -y docker git

# --------------------------------------------------
# Start Docker
# --------------------------------------------------
systemctl enable docker
systemctl start docker

# --------------------------------------------------
# Verify Docker
# --------------------------------------------------
docker version

# --------------------------------------------------
# Allow ec2-user to use Docker
# --------------------------------------------------
usermod -aG docker ec2-user

# --------------------------------------------------
# Jenkins Persistent Storage
# --------------------------------------------------
mkdir -p /opt/jenkins_home
chown -R 1000:1000 /opt/jenkins_home

# --------------------------------------------------
# Run Jenkins Container
# --------------------------------------------------
docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /opt/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts-jdk21

# --------------------------------------------------
# Wait Until Jenkins Is Ready
# --------------------------------------------------
until docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword
do
  echo "Waiting for Jenkins startup..."
  sleep 5
done

echo "Jenkins is ready."

# --------------------------------------------------
# Allow Jenkins Container To Use Host Docker Socket
# --------------------------------------------------
HOST_DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

docker exec -u root jenkins bash -c "
groupadd -f -g $HOST_DOCKER_GID dockerhost
usermod -aG dockerhost jenkins
"

# --------------------------------------------------
# Install Tools Inside Jenkins Container
# --------------------------------------------------
docker exec -u root jenkins bash -c '

set -eux

apt-get update

apt-get install -y \
curl \
wget \
unzip \
git \
gnupg \
less \
bash

# --------------------------------------------------
# Docker CLI
# --------------------------------------------------
apt-get install -y docker.io || true

# --------------------------------------------------
# AWS CLI
# --------------------------------------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

rm -rf aws awscliv2.zip

# --------------------------------------------------
# Terraform
# --------------------------------------------------
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" \
> /etc/apt/sources.list.d/hashicorp.list

apt-get update

apt-get install -y terraform

# --------------------------------------------------
# kubectl
# --------------------------------------------------
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl

# --------------------------------------------------
# Verification
# --------------------------------------------------
terraform version
aws --version
kubectl version --client
docker --version
'

echo "Bootstrap completed successfully."
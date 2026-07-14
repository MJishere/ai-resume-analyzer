from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health_check():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy"
    }


def test_server():
    response = client.get("/server")

    assert response.status_code == 200
    assert "server" in response.json()

def test_analyze_requires_role_or_job_description():
    response = client.post(
        "/analyze",
        files={
            "resume": ("resume.pdf", b"dummy pdf", "application/pdf")
        },
    )

    assert response.status_code == 400
    assert response.json() == {
        "detail": "Either role_name or job_description must be provided"
    }

from unittest.mock import patch


@patch("main.ai_analyze_resume")
@patch("main.extract_text_from_pdf")
def test_analyze_success(mock_extract_text, mock_ai_analyze):
    mock_extract_text.return_value = "This is a sample resume."

    mock_ai_analyze.return_value = """
    {
        "ats_score": 90,
        "role_match_score": 85,
        "summary": "Strong candidate",
        "strengths": ["Python", "AWS"],
        "missing_skills": ["Kubernetes"]
    }
    """

    response = client.post(
        "/analyze",
        files={
            "resume": ("resume.pdf", b"dummy pdf", "application/pdf")
        },
        data={
            "role_name": "DevOps Engineer"
        }
    )

    assert response.status_code == 200

    body = response.json()

    assert body["ats_score"] == 90
    assert body["role_match_score"] == 85
    assert body["summary"] == "Strong candidate"
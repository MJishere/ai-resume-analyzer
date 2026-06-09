import streamlit as st
import requests
import os
import plotly.graph_objects as go

with open("style.css") as f:
    st.markdown(
        f"<style>{f.read()}</style>",
        unsafe_allow_html=True
    )

# Gauge for ATS and Match Score
def create_gauge(title, score):
    fig = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=score,
            number={"suffix": "%", "font": {"size": 48}},
            title={
                "text": f"<b>{title}</b>",
                "font": {"size": 28}
            },
            gauge={
                "axis": {"range": [0, 100], "visible": False},
                "bar": {"color": "#6CCF63", "thickness": 0.35},
                "bgcolor": "#2d2d2d",
                "borderwidth": 0,
                "steps": [
                    {"range": [0, 100], "color": "#2d2d2d"}
                ],
            },
        )
    )
    fig.update_layout(
        height=280,
        margin=dict(l=20, r=20, t=50, b=20),
        paper_bgcolor="rgba(0,0,0,0)",
        font={"color": "white"},
    )

    return fig

############################################# Declare Vars and page format ####################################
st.markdown(
    """
    <h1 style='text-align: center;'>
        AI Resume Analyzer
    </h1>
    """,
    unsafe_allow_html=True
)

# Container
results_container = st.container()

API_URL = os.getenv(
    "API_URL",
    "http://127.0.0.1:8000"
)

uploaded_file = st.file_uploader(
    "Upload Resume (PDF)",
    type = ["pdf"]
)

role_name = st.text_input("Role Name")
job_description = st.text_area("Job Description")

############################################# Main Logic ##############################################

if uploaded_file:
    st.success(f"Uploaded: {uploaded_file.name}")

if st.button("Analyze Resume"):
    if not uploaded_file:
        st.error("Please Upload a Resume")
        st.stop()

    if not role_name and not job_description:
        st.error("Please Provide Role Name or Job Description")
        st.stop()

    files = {
        "resume": uploaded_file
    }

    data = {
        "role_name": role_name,
        "job_description": job_description
    }

    with st.spinner("Analyzing Resume..."):
        response = requests.post(
            f"{API_URL}/analyze",
            files=files,
            data=data
        )

    if response.status_code == 200:
        result = response.json()

        with results_container:
            st.success("Analysis Complete")
            
            col1, col2 = st.columns(2)

            ##############################################################################
            # Guage for ATS Score and Role Match Score
            ##############################################################################
            with col1:
                st.plotly_chart(
                    create_gauge("ATS Score", result["ats_score"]),
                    use_container_width=True
                )

            with col2:
                st.plotly_chart(
                    create_gauge("Role Match Score", result["role_match_score"]),
                    use_container_width=True
                )        

            ##############################################################################
            # Summary
            ##############################################################################
            st.markdown(
                """
                <h2>
                    <img src="https://img.icons8.com/?size=100&id=1GEnKV6fhh62&format=png&color=000000" width="32">
                    Summary
                </h2>
                """,
                unsafe_allow_html=True
            )

            st.markdown(
                f"""
                <div style="
                    background-color:#1e1e1e;
                    padding:20px;
                    border-radius:12px;
                    border-left:4px solid #4F8CFF;
                    margin-bottom:20px;
                    line-height:1.6;
                    font-size:16px;
                ">
                    {result["summary"]}
                </div>
                """,
                unsafe_allow_html=True
            )


            ##############################################################################
            # Strengths and Weakness
            ##############################################################################
            col1, col2 = st.columns(2)

            with col1:
                st.markdown("""
                <h2>
                    <img src="https://img.icons8.com/?size=100&id=104335&format=png&color=000000" width="32">
                    Strengths
                </h2>
                """, unsafe_allow_html=True)

                strengths_html = "".join(
                    [f"<li>{item}</li>" for item in result["strengths"]]
                )

                st.markdown(
                    f"""
                    <div style="
                        background-color:#1e1e1e;
                        padding:20px;
                        border-radius:12px;
                        border-left:4px solid #00C853;
                        min-height:250px;
                    ">
                        <ul>
                            {strengths_html}
                        </ul>
                    </div>
                    """,
                    unsafe_allow_html=True
                )

            with col2:
                st.markdown("""
                <h2>
                    <img src="https://img.icons8.com/?size=100&id=k5CI39nVUUwM&format=png&color=000000" width="32">
                    Missing Skills
                </h2>
                """, unsafe_allow_html=True)

                missing_html = "".join(
                    [f"<li>{item}</li>" for item in result["missing_skills"]]
                )

                st.markdown(
                    f"""
                    <div style="
                        background-color:#1e1e1e;
                        padding:20px;
                        border-radius:12px;
                        border-left:4px solid #FF9800;
                        min-height:250px;
                    ">
                        <ul>
                            {missing_html}
                        </ul>
                    </div>
                    """,
                    unsafe_allow_html=True
                )


            ##############################################################################
            # Suggestions
            ##############################################################################
            st.markdown(
                """
                <h2>
                    <img src="https://img.icons8.com/?size=100&id=819PPT5cUjiq&format=png&color=000000" width="32">
                    Suggestions
                </h2>
                """,
                unsafe_allow_html=True
            )

            suggestions_html = "".join(
                [f"<li>{item}</li>" for item in result["suggestions"]]
            )

            st.markdown(
                f"""
                <div style="
                    background-color:#1e1e1e;
                    padding:20px;
                    border-radius:12px;
                    border-left:4px solid #4F8CFF;
                    margin-bottom:20px;
                ">
                    <ul>
                        {suggestions_html}
                    </ul>
                </div>
                """,
                unsafe_allow_html=True
            )

    else:
        st.error(response.text)       
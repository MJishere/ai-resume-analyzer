import os

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

api_key = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL = os.getenv("OPENAI_MODEL")

client = OpenAI(api_key = api_key)

def analyze_resume(resume_text: str, role_name: str |  None, job_description: str | None):
    analysis_target = (
        job_description
        if job_description
        else f"Role: {role_name}"
    )
    
    prompt = f"""
You are an ATS and resume reviewer.

Analyze the resume against the provided role or job description.

Return ONLY valid JSON.

Do not use markdown.
Do not use ```json.
Do not add explanations before or after the JSON.

ROLE/JD:
{analysis_target}

RESUME:
{resume_text}

JSON FORMAT:

{{
    "ats_score": 0,
    "role_match_score": 0,
    "summary": "",
    "strengths": [],
    "missing_skills": [],
    "suggestions": []
}}
"""
    response = client.responses.create(
        model = OPENAI_MODEL,
        input = prompt
    )
    return response.output_text


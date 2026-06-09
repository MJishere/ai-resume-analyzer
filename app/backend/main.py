import json
import socket
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from io import BytesIO
from ai_service import analyze_resume as ai_analyze_resume
from pdf_service import extract_text_from_pdf

app = FastAPI(title="AI Resume Analyzer API")

@app.get("/health")
def health_check():
    return { "status": "healthy"}

@app.get("/server")
def server():
    return {
        "server": socket.gethostname()
    }

@app.post("/analyze")
async def analyze_resume(
    resume: UploadFile = File(...),
    role_name: str | None = Form(None),
    job_description: str | None = Form(None)
):
    
    if not role_name and not job_description:
        raise HTTPException(
            status_code = 400,
            detail = "Either role_name or job_description must be provided"
        )
    pdf_text = extract_text_from_pdf(resume.file)
    
    result = ai_analyze_resume(
        resume_text = pdf_text,
        role_name = role_name,
        job_description = job_description
    )

    try:
        return json.loads(result)    
    except Exception:
        raise HTTPException(
            status_code=500,
            detail= "Invalid AI Response! Don't worry Devs are already working on it, comeback later"
        )
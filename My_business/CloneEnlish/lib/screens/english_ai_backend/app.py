from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class ChatRequest(BaseModel):
    message: str


@app.get("/")
def home():
    return {
        "message": "English AI Backend Running"
    }


@app.post("/chat")
def chat(request: ChatRequest):

    text = request.message.lower()

    if "hello" in text or "hi" in text:
        reply = "Hello! Nice to meet you. How are you today?"

    elif "my name" in text:
        reply = "Nice introduction! Can you tell me where you live?"

    elif "i am" in text:
        reply = "Great! Can you tell me about your hobbies?"

    elif "thank" in text:
        reply = "You're welcome! Keep practicing your English every day."

    else:
        reply = "Good job! Please tell me more."

    return {
        "reply": reply
    }
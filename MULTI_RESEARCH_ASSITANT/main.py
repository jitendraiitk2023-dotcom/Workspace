import os
from typing import TypedDict

from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langgraph.graph import StateGraph, START, END


load_dotenv()


class ResearchState(TypedDict):

    question: str

    web_research: str

    academic_research: str

    news_research: str

    technology_research: str

    final_report: str


llm = ChatGoogleGenerativeAI(
    model="gemini-3.6-flash",
    temperature=0
)


def research_node(state: ResearchState):

    question = state["question"]

    prompt = f"""
You are a research assistant.

Research the following question using your knowledge:

Question:
{question}

Provide:
1. Key facts
2. Important concepts
3. Relevant examples
4. Potential limitations

Keep the research structured.
"""

    response = llm.invoke(prompt)

    return {
        "research": response.content
    }


def answer_node(state: ResearchState):

    research = state["research"]

    prompt = f"""
You are a professional research report writer.

Using the research below, create a clear final answer.

Research:
{research}

Requirements:
- Explain clearly
- Use headings
- Use bullet points where useful
- Avoid unsupported claims
"""

    response = llm.invoke(prompt)

    return {
        "answer": response.content
    }


graph = StateGraph(ResearchState)

graph.add_node("research", research_node)
graph.add_node("answer", answer_node)

graph.add_edge(START, "research")
graph.add_edge("research", "answer")
graph.add_edge("answer", END)

app = graph.compile()


result = app.invoke(
    {
        "question": "How will Agentic AI change software development?"
    }
)


print("\n========== RESEARCH ==========\n")
print(result["research"])

print("\n========== FINAL ANSWER ==========\n")
print(result["answer"])
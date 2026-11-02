def supervisor_node(state):

    question = state["question"]

    prompt = f"""
You are the supervisor of a research team.

User question:
{question}

Decide which researchers are needed.

Available researchers:

1. web
2. academic
3. news
4. technology

Return a structured research plan.
"""

    response = llm.invoke(prompt)

    return {
        "research_plan": response.content
    }
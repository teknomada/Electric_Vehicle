# Streamlit app for EV Demo
import streamlit as st
from snowflake.snowpark.context import get_active_session
import _snowflake
import json

SEMANTIC_VIEW = "EV_RESEARCH.PUBLIC.EV_ADOPTION_BY_REGION_OR_MANUFACTURER"

st.set_page_config(page_title="EV Demo Streamlit App", layout="wide")
st.title("EV Demo Streamlit App")
st.write("I am your virtual EV market analyst. You can ask me Sales / Marketing questions")

session = get_active_session()

if "history" not in st.session_state:
    st.session_state.history = []
if "messages" not in st.session_state:
    st.session_state.messages = []


def send_message(prompt):
    st.session_state.messages.append(
        {"role": "user", "content": [{"type": "text", "text": prompt}]}
    )
    request_body = {
        "messages": st.session_state.messages,
        "semantic_view": SEMANTIC_VIEW,
    }
    resp = _snowflake.send_snow_api_request(
        "POST",
        "/api/v2/cortex/analyst/message",
        {},
        {},
        request_body,
        {},
        60000,
    )
    status_code = resp.get("status", 0) if isinstance(resp, dict) else 0
    if status_code != 200:
        st.session_state.messages.pop()
        raise Exception("API returned status " + str(status_code))
    content = resp.get("content", "")
    if isinstance(content, str):
        parsed = json.loads(content)
    else:
        parsed = content
    return parsed


def display_response(content):
    for item in content:
        if item["type"] == "text":
            st.markdown(item["text"])
        elif item["type"] == "suggestions":
            st.markdown("**Suggestions:**")
            for s in item["suggestions"]:
                st.markdown(f"- {s}")
        elif item["type"] == "sql":
            with st.expander("SQL Query", expanded=False):
                st.code(item["statement"], language="sql")
            with st.expander("Results", expanded=True):
                with st.spinner("Running SQL..."):
                    df = session.sql(item["statement"]).to_pandas()
                    if len(df) > 1:
                        data_tab, line_tab, bar_tab = st.tabs(
                            ["Data", "Line Chart", "Bar Chart"]
                        )
                        data_tab.dataframe(df, use_container_width=True)
                        plot_df = df.copy()
                        if len(plot_df.columns) > 1:
                            plot_df = plot_df.set_index(plot_df.columns[0])
                        with line_tab:
                            st.line_chart(plot_df)
                        with bar_tab:
                            st.bar_chart(plot_df)
                    else:
                        st.dataframe(df, use_container_width=True)


with st.sidebar:
    st.header("About")
    st.markdown(
        "This app uses **Cortex Analyst** with the semantic view to answer your EV market questions in natural language."
    )
    if st.button("Reset Conversation"):
        st.session_state.history = []
        st.session_state.messages = []
        st.experimental_rerun()

for entry in st.session_state.history:
    if entry["role"] == "user":
        st.markdown(f"**You:** {entry['text']}")
    else:
        st.markdown("**Analyst:**")
        display_response(entry["content"])
    st.divider()

with st.form("question_form", clear_on_submit=True):
    user_question = st.text_input(
        "Your question:",
        placeholder="Ask a Sales / Marketing question about EVs (natural language only, no SQL)",
    )
    submitted = st.form_submit_button("Ask")

if submitted and user_question:
    st.session_state.history.append({"role": "user", "text": user_question})
    st.markdown(f"**You:** {user_question}")
    st.divider()
    st.markdown("**Analyst:**")
    with st.spinner("Analyzing your question..."):
        try:
            response = send_message(user_question)
            content = response["message"]["content"]
            has_meaningful = any(
                c["type"] in ("text", "sql", "suggestions") for c in content
            )
            if not has_meaningful:
                st.info(
                    "I could not find a clear answer. Could you rephrase your question or provide more details?"
                )
                st.session_state.messages.pop()
            else:
                st.session_state.messages.append(
                    {"role": "analyst", "content": content}
                )
                st.session_state.history.append(
                    {"role": "analyst", "content": content}
                )
                display_response(content)
        except Exception as e:
            st.error(
                "I could not interpret your question. Could you please rephrase it or provide more specific details?"
            )
            if st.session_state.messages and st.session_state.messages[-1]["role"] == "user":
                st.session_state.messages.pop()


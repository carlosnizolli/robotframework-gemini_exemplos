*** Settings ***
Documentation    Keywords didáticas do exemplo google-genai (GoogleGenaiLibrary.py).
...    Gera perguntas e valida coerência pergunta/resposta com Sim ou Não.
...    Docs do SDK: https://ai.google.dev/gemini-api/docs/generate-content/get-started?hl=pt-br

Library    String
Library    ../Resources/GoogleGenaiLibrary.py
Resource    ../../Resources/DemoData.resource
Resource    ../../Resources/SiteComIa.resource


*** Variables ***
${GOOGLE_GENAI_VERDICT_OUTPUT}    Responda com exatamente uma palavra na primeira linha: Sim ou Não.
...    Sim quando a resposta atender à intenção da pergunta.
...    Não somente em caso de contradição clara ou troca de tema.

${GOOGLE_GENAI_QUESTION_OUTPUT}    Uma pergunta direta em inglês simples, uma linha, sem ? no final.
...    Sem markdown nem quebra de linha.

${GOOGLE_GENAI_TOPICO_GEOGRAFIA}    a Brazilian state and its capital city


*** Keywords ***
Valida Coerência Da Resposta Com Google Genai
    [Documentation]    Envia pergunta e resposta ao Gemini e exige veredito Sim na primeira linha.
    [Arguments]    ${PERGUNTA}    ${CRITERIO}
    ${CTX}=    Catenate    SEPARATOR=\n
    ...    ## PERGUNTA
    ...    ${PERGUNTA}
    ...
    ...    ## RESPOSTA DO SITE COM IA
    ...    ${SITE_IA_RESPONSE}
    ${RAW}=    Google Genai Evaluate Text Verdict    ${CTX}    ${CRITERIO}    ${GOOGLE_GENAI_VERDICT_OUTPUT}
    Google Genai Assert Verdict Is Sim    ${RAW}

Gera Pergunta Com Google Genai
    [Documentation]    Gera pergunta curta via SDK google-genai para consultar o site com IA.
    [Arguments]    ${TOPICO}
    ${PROMPT}=    Set Variable    Gere uma pergunta simples sobre ${TOPICO} para o Wolfram Alpha.
    ${QUESTION}=    Google Genai Generate Question    ${PROMPT}    ${GOOGLE_GENAI_QUESTION_OUTPUT}
    VAR    ${GOOGLE_GENAI_QUESTION}    ${QUESTION}    scope=test
    RETURN    ${GOOGLE_GENAI_QUESTION}

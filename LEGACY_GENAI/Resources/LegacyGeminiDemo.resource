*** Settings ***
Documentation    Keywords didáticas do exemplo google.generativeai (LegacyGeminiLibrary.py).
...    Gera perguntas e valida coerência pergunta/resposta com Sim ou Não.

Library    String
Library    ../Resources/LegacyGeminiLibrary.py
Resource    ../../Resources/DemoData.resource
Resource    ../../Resources/SiteComIa.resource


*** Variables ***
${LEGACY_VERDICT_OUTPUT}    Responda com exatamente uma palavra na primeira linha: Sim ou Não.
...    Sim quando a resposta atender à intenção da pergunta.
...    Não somente em caso de contradição clara ou troca de tema.

${LEGACY_QUESTION_OUTPUT}    Uma pergunta direta em inglês simples, uma linha, sem ? no final.
...    Sem markdown nem quebra de linha.

${LEGACY_TOPICO_GEOGRAFIA}    a Brazilian state and its capital city


*** Keywords ***
Valida Coerência Da Resposta Com Gemini Legado
    [Documentation]    Envia pergunta e resposta ao Gemini e exige veredito Sim na primeira linha.
    [Arguments]    ${PERGUNTA}    ${CRITERIO}
    ${CTX}=    Catenate    SEPARATOR=\n
    ...    ## PERGUNTA
    ...    ${PERGUNTA}
    ...
    ...    ## RESPOSTA DO SITE COM IA
    ...    ${SITE_IA_RESPONSE}
    ${RAW}=    Legacy Gemini Evaluate Text Verdict    ${CTX}    ${CRITERIO}    ${LEGACY_VERDICT_OUTPUT}
    Legacy Gemini Assert Verdict Is Sim    ${RAW}

Gera Pergunta Com Gemini Legado
    [Documentation]    Gera pergunta curta via SDK legado para consultar o site com IA.
    [Arguments]    ${TOPICO}
    ${PROMPT}=    Set Variable    Gere uma pergunta simples sobre ${TOPICO} para o Wolfram Alpha.
    ${QUESTION}=    Legacy Gemini Generate Question    ${PROMPT}    ${LEGACY_QUESTION_OUTPUT}
    VAR    ${LEGACY_GEMINI_QUESTION}    ${QUESTION}    scope=test
    RETURN    ${LEGACY_GEMINI_QUESTION}

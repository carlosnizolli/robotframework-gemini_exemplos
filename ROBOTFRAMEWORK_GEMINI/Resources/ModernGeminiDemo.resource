*** Settings ***
Documentation    Keywords didáticas do exemplo robotframework-gemini (GeminiLibrary).
...    Gera perguntas e valida coerência pergunta/resposta com Sim ou Não.

Library    ../../Resources/DotenvBootstrap.py
Library    String
Library    GeminiLibrary
Resource    ../../Resources/DemoData.resource
Resource    ../../Resources/SiteComIa.resource


*** Variables ***
${MODERN_VERDICT_OUTPUT}    Responda com exatamente uma palavra na primeira linha: Sim ou Não.
...    Sim quando a resposta atender à intenção da pergunta.
...    Não somente em caso de contradição clara ou troca de tema.
...    Não penalize resposta longa, formatação ou detalhes extras.

${MODERN_QUESTION_CONTEXT}    Você gera perguntas curtas para consultar o Wolfram Alpha.
${MODERN_QUESTION_OUTPUT}    Uma pergunta direta em inglês simples, uma linha, sem ? no final.
...    Exemplos: capital of Brazil, population of São Paulo, 7 times 8.
...    Sem markdown nem quebra de linha.

${MODERN_TOPICO_GEOGRAFIA}    a Brazilian state and its capital city


*** Keywords ***
Extrai Primeira Linha Do Veredito
    [Documentation]    Primeira linha do veredito, normalizada (Sim/Não sem pontuação).
    [Arguments]    ${RAW}
    ${LINE}=    Get Line    ${RAW}    0
    ${NORM}=    Evaluate    __import__('re').sub(r'[^a-zA-Zà-üÀ-Ü]', '', '''${LINE.strip()}''').lower()
    RETURN    ${NORM}

Valida Coerência Da Resposta Com Robotframework Gemini
    [Documentation]    Envia pergunta e resposta ao Gemini e exige veredito Sim na primeira linha.
    [Arguments]    ${PERGUNTA}    ${CRITERIO}
    ${CTX}=    Catenate    SEPARATOR=\n
    ...    ## PERGUNTA
    ...    ${PERGUNTA}
    ...
    ...    ## RESPOSTA DO SITE COM IA
    ...    ${SITE_IA_RESPONSE}
    ${EVAL}=    Catenate    SEPARATOR=\n
    ...    Avalie APENAS coerência entre pergunta e resposta (não valide veracidade externa).
    ...    A resposta deve tratar o tema pedido na pergunta.
    ${RAW}=    Gemini Evaluate Text Verdict    ${CTX}    ${EVAL}    output_instructions=${MODERN_VERDICT_OUTPUT}
    ${VERDICT}=    Extrai Primeira Linha Do Veredito    ${RAW}
    Should Be Equal    ${VERDICT}    sim
    ...    msg=Validação Gemini retornou '${VERDICT}' em vez de sim (raw: ${RAW})

Gera Pergunta Com Robotframework Gemini
    [Documentation]    Gera pergunta via Gemini Evaluate Text para consultar o site com IA.
    [Arguments]    ${TOPICO}
    ${PROMPT}=    Set Variable    Gere uma pergunta simples sobre ${TOPICO} para o Wolfram Alpha.
    ${QUESTION}=    Gemini Evaluate Text
    ...    ${MODERN_QUESTION_CONTEXT}
    ...    ${PROMPT}
    ...    extra_instructions=${MODERN_QUESTION_OUTPUT}
    VAR    ${MODERN_GEMINI_QUESTION}    ${QUESTION.strip()}    scope=test
    RETURN    ${MODERN_GEMINI_QUESTION}

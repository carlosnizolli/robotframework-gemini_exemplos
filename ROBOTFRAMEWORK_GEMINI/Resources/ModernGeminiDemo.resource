*** Settings ***
Documentation    Exemplo didático — validação via robotframework-gemini (GeminiLibrary).

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
    [Documentation]    Juiz Sim/Não via Gemini Evaluate Text Verdict (padrão LIA/PRO).
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

Executa Fluxo De Pergunta Factual Sobre Capital Do Brasil
    [Documentation]    Site com IA responde → Gemini valida coerência (padrão LIA).
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

Executa Fluxo De Pergunta Aritmetica Simples
    [Documentation]    Site com IA responde cálculo → Gemini valida coerência.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

Executa Fluxo De Pergunta Gerada Pelo Robotframework Gemini
    [Documentation]    Gemini gera pergunta → site responde → Gemini valida coerência.
    Gera Pergunta Com Robotframework Gemini    ${MODERN_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${MODERN_GEMINI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${MODERN_GEMINI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

Executa Smoke Test Do Site Com Ia
    [Documentation]    Consulta simples para validar que o site com IA responde.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

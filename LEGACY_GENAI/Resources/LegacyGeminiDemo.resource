*** Settings ***
Documentation    Exemplo didático — validação com google.generativeai (SDK legado no .py).

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
    [Documentation]    Juiz Sim/Não via SDK google.generativeai (padrão LIA/PRO).
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

Executa Fluxo De Pergunta Factual Sobre Capital Do Brasil
    [Documentation]    Site com IA responde → Gemini legado valida coerência.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

Executa Fluxo De Pergunta Aritmetica Simples
    [Documentation]    Site com IA responde cálculo → Gemini legado valida coerência.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

Executa Fluxo De Pergunta Gerada Pelo Gemini Legado
    [Documentation]    Gemini legado gera pergunta → site responde → Gemini valida.
    Gera Pergunta Com Gemini Legado    ${LEGACY_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${LEGACY_GEMINI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${LEGACY_GEMINI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

Executa Smoke Test Do Site Com Ia
    [Documentation]    Consulta simples para validar que o site com IA responde.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

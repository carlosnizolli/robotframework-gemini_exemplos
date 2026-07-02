*** Settings ***
Documentation    Exemplo didático — validação com SDK atual google-genai (GoogleGenaiLibrary.py).
...    Docs: https://ai.google.dev/gemini-api/docs/generate-content/get-started?hl=pt-br

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
    [Documentation]    Juiz Sim/Não via SDK google-genai (padrão LIA/PRO).
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

Executa Fluxo De Pergunta Factual Sobre Capital Do Brasil
    [Documentation]    Site com IA responde → google-genai valida coerência.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Google Genai
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

Executa Fluxo De Pergunta Aritmetica Simples
    [Documentation]    Site com IA responde cálculo → google-genai valida coerência.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Google Genai
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

Executa Fluxo De Pergunta Gerada Pelo Google Genai
    [Documentation]    google-genai gera pergunta → site responde → Gemini valida.
    Gera Pergunta Com Google Genai    ${GOOGLE_GENAI_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${GOOGLE_GENAI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Google Genai
    ...    ${GOOGLE_GENAI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

Executa Smoke Test Do Site Com Ia
    [Documentation]    Consulta simples para validar que o site com IA responde.
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

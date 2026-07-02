*** Settings ***
Documentation    Automação de browser compartilhada pelos exemplos didáticos deste repositório.
...    Abre o Wolfram Alpha, consulta perguntas em linguagem natural, captura a resposta
...    exibida na página e salva screenshot. Usado antes da validação com Gemini nas suites.
...    Wolfram Alpha não exige login nem captcha. Browser roda com headless=false para
...    facilitar acompanhar visualmente durante o estudo dos exemplos.

Library    Browser
Library    String
Library    UrlUtils.py
Library    WolframExtract.py


*** Variables ***
${SITE_IA_BASE_URL}             https://www.wolframalpha.com/input?i=
${SITE_IA_TIMEOUT}              2m
${SITE_IA_SLOW}                 00:00:00.300
${SITE_IA_RESULT_SECTION}       xpath=//section[.//h2[normalize-space()='Result' or normalize-space()='Resultado']]
${SITE_IA_RESULT_IMAGE}         xpath=//section[.//h2[normalize-space()='Result' or normalize-space()='Resultado']]//img


*** Keywords ***
Abre Site Com Ia
    [Documentation]    Abre browser para consultas no site com IA (Wolfram Alpha).
    VAR    @{BROWSER_ARGS}    --no-sandbox    --disable-dev-shm-usage
    New Browser    browser=chromium    headless=false    slowMo=${SITE_IA_SLOW}    args=@{BROWSER_ARGS}
    New Context    viewport={'width': 1400, 'height': 900}    locale=pt-BR    timezoneId=America/Sao_Paulo
    Set Browser Timeout    ${SITE_IA_TIMEOUT}
    Register Keyword To Run On Failure    Take Screenshot    fullPage=True

Fecha Site Com Ia
    [Documentation]    Encerra o browser do exemplo.
    Close Browser

Monta Url De Consulta No Site Com Ia
    [Documentation]    Monta URL de consulta com pergunta codificada.
    [Arguments]    ${PERGUNTA}
    ${ENC}=    Codifica Texto Para Url    ${PERGUNTA}
    ${URL}=    Set Variable    ${SITE_IA_BASE_URL}${ENC}
    RETURN    ${URL}

Consulta Pergunta No Site Com Ia
    [Documentation]    Abre consulta no site e aguarda o pod de resultado.
    [Arguments]    ${PERGUNTA}
    VAR    ${SITE_IA_QUESTION}    ${PERGUNTA}    scope=test
    ${URL}=    Monta Url De Consulta No Site Com Ia    ${PERGUNTA}
    New Page    ${URL}    load
    Sleep    12s
    Aguarda Resultado Do Site Com Ia

Aguarda Resultado Do Site Com Ia
    [Documentation]    Aguarda seção Result/Resultado ou imagem com resposta.
    Wait Until Keyword Succeeds    45s    2s    Resultado Do Site Com Ia Deve Estar Pronto

Resultado Do Site Com Ia Deve Estar Pronto
    [Documentation]    Falha enquanto nenhum resultado legível estiver disponível.
    ${TEXT}=    Extrai Texto Do Resultado Do Site Com Ia
    Should Not Be Empty    ${TEXT}    msg=Resultado do site com IA ainda não disponível

Extrai Texto Do Resultado Do Site Com Ia
    [Documentation]    Lê texto principal do pod Result no Wolfram Alpha.
    ${SCRIPT}=    Script Extrai Resultado Wolfram
    ${TEXT}=    Evaluate JavaScript    ${None}    ${SCRIPT}
    RETURN    ${TEXT}

Obtem Resposta Do Site Com Ia
    [Documentation]    Captura resposta do site em ${SITE_IA_RESPONSE}.
    ${TEXT}=    Extrai Texto Do Resultado Do Site Com Ia
    ${TEXT}=    Strip String    ${TEXT}
    Should Not Be Empty    ${TEXT}    msg=Não foi possível ler resposta do site com IA
    VAR    ${SITE_IA_RESPONSE}    ${TEXT}    scope=test
    Log    Resposta do site com IA: ${SITE_IA_RESPONSE}
    RETURN    ${SITE_IA_RESPONSE}

Valida Que Site Com Ia Respondeu
    [Documentation]    Confirma URL do Wolfram Alpha e presença de resultado.
    ${URL}=    Get Url
    Should Contain    ${URL}    wolframalpha.com
    ...    msg=URL inesperada do site com IA: ${URL}
    Resultado Do Site Com Ia Deve Estar Pronto

Valida Tema Na Resposta Do Site
    [Documentation]    Verifica se texto esperado aparece na resposta (case insensitive).
    [Arguments]    ${TEMA_ESPERADO}
    Should Contain    ${SITE_IA_RESPONSE}    ${TEMA_ESPERADO}    ignore_case=True
    ...    msg=Tema '${TEMA_ESPERADO}' não encontrado em: ${SITE_IA_RESPONSE}

Captura Screenshot Da Resposta Do Site Com Ia
    [Documentation]    Salva screenshot da página com resultado.
    ${PATH}=    Set Variable    ${OUTPUT_DIR}/site_ia_resposta.png
    Take Screenshot    ${PATH}    fullPage=True
    Log    Screenshot salvo em: ${PATH}

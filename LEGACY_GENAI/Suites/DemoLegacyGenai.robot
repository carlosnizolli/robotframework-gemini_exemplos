*** Settings ***
Documentation    Exemplo didático — forma ANTIGA (google.generativeai direto em LegacyGeminiLibrary.py).
...
...    Fluxo (padrão LIA/PRO): pergunta no site com IA → captura resposta → Gemini valida.
...
...    Site: Wolfram Alpha.
...
...    Pré-requisitos:
...    - pip install -r ../requirements-legacy.txt
...    - rfbrowser init
...    - export GEMINI_API_KEY=... (ou .env na raiz do repositório)
...
...    Execução:
...    robot -d Results Suites/DemoLegacyGenai.robot

Resource            ../Resources/LegacyGeminiDemo.resource

Suite Setup         Abre Site Com Ia
Suite Teardown      Fecha Site Com Ia
Test Teardown       Run Keyword If Test Failed    Take Screenshot    fullPage=True

Test Timeout        5 minutes


*** Test Cases ***
CT01 - Site com IA responde consulta simples
    [Documentation]    Smoke test browser: Wolfram Alpha retorna resultado.
    [Tags]    didactic    exemplo_gemini    legacy_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

CT02 - Pergunta factual sobre capital do Brasil
    [Documentation]    Site responde → Gemini legado valida coerência.
    [Tags]    didactic    exemplo_gemini    legacy_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

CT03 - Pergunta aritmética simples
    [Documentation]    Site responde 7x8 → Gemini legado valida coerência.
    [Tags]    didactic    exemplo_gemini    legacy_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

CT04 - Pergunta gerada pelo Gemini legado
    [Documentation]    SDK legado gera pergunta, site responde e Gemini valida.
    [Tags]    didactic    exemplo_gemini    legacy_genai    browser    ia
    Gera Pergunta Com Gemini Legado    ${LEGACY_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${LEGACY_GEMINI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Gemini Legado
    ...    ${LEGACY_GEMINI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

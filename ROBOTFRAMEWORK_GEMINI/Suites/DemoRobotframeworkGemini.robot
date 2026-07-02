*** Settings ***
Documentation    Exemplo didático — forma NOVA (robotframework-gemini / GeminiLibrary).
...
...    Fluxo (padrão LIA/PRO): Gemini gera/consulta pergunta → site com IA responde
...    no browser → Gemini valida coerência da resposta.
...
...    Site: Wolfram Alpha (linguagem natural, sem login/captcha).
...
...    Pré-requisitos:
...    - pip install -r ../requirements-modern.txt
...    - rfbrowser init
...    - export GEMINI_API_KEY=... (ou .env na raiz do repositório)
...
...    Execução:
...    robot -d Results Suites/DemoRobotframeworkGemini.robot
...
...    Compare com:
...    - ../LEGACY_GENAI/Suites/DemoLegacyGenai.robot (google.generativeai — legado)
...    - ../GOOGLE_GENAI/Suites/DemoGoogleGenai.robot (google-genai — SDK atual)

Resource            ../Resources/ModernGeminiDemo.resource

Suite Setup         Abre Site Com Ia
Suite Teardown      Fecha Site Com Ia
Test Teardown       Run Keyword If Test Failed    Take Screenshot    fullPage=True

Test Timeout        5 minutes


*** Test Cases ***
CT01 - Site com IA responde consulta simples
    [Documentation]    Smoke test browser: Wolfram Alpha retorna resultado para consulta factual.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

CT02 - Pergunta factual sobre capital do Brasil
    [Documentation]    Site responde → robotframework-gemini valida coerência.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

CT03 - Pergunta aritmética simples
    [Documentation]    Site responde 7x8 → robotframework-gemini valida coerência.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

CT04 - Pergunta gerada pelo Robotframework Gemini
    [Documentation]    GeminiLibrary gera pergunta, site responde e Gemini valida.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Gera Pergunta Com Robotframework Gemini    ${MODERN_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${MODERN_GEMINI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Robotframework Gemini
    ...    ${MODERN_GEMINI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

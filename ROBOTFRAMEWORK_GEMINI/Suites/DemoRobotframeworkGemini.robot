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

Resource            ../Resources/Resource.resource

Suite Setup         Abre Site Com Ia
Suite Teardown      Fecha Site Com Ia
Test Teardown       Run Keyword If Test Failed    Take Screenshot    fullPage=True

Test Timeout        5 minutes


*** Test Cases ***
CT01 - Site com IA responde consulta simples
    [Documentation]    Smoke test browser: Wolfram Alpha retorna resultado para consulta factual.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Executa Smoke Test Do Site Com Ia

CT02 - Pergunta factual sobre capital do Brasil
    [Documentation]    Site responde → robotframework-gemini valida coerência.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Executa Fluxo De Pergunta Factual Sobre Capital Do Brasil

CT03 - Pergunta aritmética simples
    [Documentation]    Site responde 7x8 → robotframework-gemini valida coerência.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Executa Fluxo De Pergunta Aritmetica Simples

CT04 - Pergunta gerada pelo Robotframework Gemini
    [Documentation]    GeminiLibrary gera pergunta, site responde e Gemini valida.
    [Tags]    didactic    exemplo_gemini    robotframework_gemini    browser    ia
    Executa Fluxo De Pergunta Gerada Pelo Robotframework Gemini

*** Settings ***
Documentation    Exemplo didático — SDK atual Google GenAI (pacote google-genai).
...
...    Fluxo (padrão LIA/PRO): pergunta no site com IA → captura resposta → Gemini valida.
...
...    Site: Wolfram Alpha.
...
...    Pré-requisitos:
...    - pip install -r ../requirements-google-genai.txt
...    - rfbrowser init
...    - export GEMINI_API_KEY=... (ou .env na raiz do repositório)

Resource            ../Resources/Resource.resource

Suite Setup         Abre Site Com Ia
Suite Teardown      Fecha Site Com Ia
Test Teardown       Run Keyword If Test Failed    Take Screenshot    fullPage=True

Test Timeout        5 minutes


*** Test Cases ***
CT01 - Site com IA responde consulta simples
    [Documentation]    Smoke test browser: Wolfram Alpha retorna resultado.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Executa Smoke Test Do Site Com Ia

CT02 - Pergunta factual sobre capital do Brasil
    [Documentation]    Site responde → google-genai valida coerência.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Executa Fluxo De Pergunta Factual Sobre Capital Do Brasil

CT03 - Pergunta aritmética simples
    [Documentation]    Site responde 7x8 → google-genai valida coerência.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Executa Fluxo De Pergunta Aritmetica Simples

CT04 - Pergunta gerada pelo Google Genai
    [Documentation]    google-genai gera pergunta, site responde e Gemini valida.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Executa Fluxo De Pergunta Gerada Pelo Google Genai

*** Settings ***
Documentation    Exemplo didático — integração via SDK atual Google GenAI (pacote google-genai).
...
...    Este repositório reúne exemplos didáticos para aprender a combinar Robot Framework,
...    automação de browser e validação com Gemini. Os testes não simulam um sistema real:
...    servem para estudar o fluxo e comparar três formas de chamar a API do Gemini.
...
...    O que este exemplo ensina: chamar o SDK oficial atual (from google import genai)
...    em uma biblioteca Python customizada (GoogleGenaiLibrary.py).
...
...    Fluxo comum aos casos de teste:
...    1. Consulta uma pergunta no Wolfram Alpha (site com IA no browser)
...    2. Captura a resposta exibida na página
...    3. Usa o Gemini como juiz: responde Sim ou Não se a resposta é coerente com a pergunta
...
...    Site: Wolfram Alpha (linguagem natural, sem login/captcha).
...
...    Pré-requisitos:
...    - pip install -r ../requirements-google-genai.txt
...    - rfbrowser init
...    - export GEMINI_API_KEY=... (ou .env na raiz do repositório)
...
...    Execução:
...    robot -d Results Suites/DemoGoogleGenai.robot
...
...    Compare com:
...    - ../LEGACY_GENAI/Suites/DemoLegacyGenai.robot (google.generativeai — SDK legado)
...    - ../ROBOTFRAMEWORK_GEMINI/Suites/DemoRobotframeworkGemini.robot (robotframework-gemini)

Resource            ../Resources/GoogleGenaiDemo.resource

Suite Setup         Abre Site Com Ia
Suite Teardown      Fecha Site Com Ia
Test Teardown       Run Keyword If Test Failed    Take Screenshot    fullPage=True

Test Timeout        5 minutes


*** Test Cases ***
CT01 - Site com IA responde consulta simples
    [Documentation]    Smoke test de browser: abre o Wolfram Alpha, confirma que há
    ...    resultado na página e salva screenshot. Não usa Gemini.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Valida Que Site Com Ia Respondeu
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia

CT02 - Pergunta factual sobre capital do Brasil
    [Documentation]    Pergunta fixa sobre geografia. Confere se a resposta contém o
    ...    tema esperado e pede ao Gemini que julgue a coerência pergunta/resposta.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_CAPITAL}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_CAPITAL}
    Valida Coerência Da Resposta Com Google Genai
    ...    ${DEMO_PERGUNTA_CAPITAL}
    ...    A resposta informa corretamente a capital do Brasil?

CT03 - Pergunta aritmética simples
    [Documentation]    Pergunta fixa de multiplicação (7 vezes 8). Valida o resultado
    ...    na página e usa o Gemini para confirmar se a resposta atende à pergunta.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Consulta Pergunta No Site Com Ia    ${DEMO_PERGUNTA_MULTIPLICACAO}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Tema Na Resposta Do Site    ${DEMO_TEMA_MULTIPLICACAO}
    Valida Coerência Da Resposta Com Google Genai
    ...    ${DEMO_PERGUNTA_MULTIPLICACAO}
    ...    A resposta indica que 7 vezes 8 é 56?

CT04 - Pergunta gerada pelo Google Genai
    [Documentation]    O Gemini gera a pergunta sobre um estado brasileiro e sua capital;
    ...    o site responde e o Gemini valida se a resposta trata do tema perguntado.
    [Tags]    didactic    exemplo_gemini    google_genai    browser    ia
    Gera Pergunta Com Google Genai    ${GOOGLE_GENAI_TOPICO_GEOGRAFIA}
    Consulta Pergunta No Site Com Ia    ${GOOGLE_GENAI_QUESTION}
    Obtem Resposta Do Site Com Ia
    Captura Screenshot Da Resposta Do Site Com Ia
    Valida Coerência Da Resposta Com Google Genai
    ...    ${GOOGLE_GENAI_QUESTION}
    ...    A resposta trata do estado ou capital perguntados?

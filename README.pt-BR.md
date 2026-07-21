# robotframework-gemini — Exemplos

[English (README.md)](README.md) · **Português (Brasil)**

Repositório didático que mostra como combinar **Robot Framework**, **automação de browser** e **Google Gemini** como juiz textual — comparando três formas de chamar a API do Gemini.

---

## Projetos relacionados

Este repositório demonstra a biblioteca [**robotframework-gemini**](https://pypi.org/project/robotframework-gemini/):

```bash
pip install robotframework-gemini
```

| Projeto | Descrição |
|---------|-----------|
| [robotframework-gemini](https://github.com/carlosnizolli/robotframework-gemini) | Biblioteca (PyPI) |
| [docs (pt-BR)](https://github.com/carlosnizolli/robotframework-gemini/blob/main/docs/KEYWORDS.pt-BR.md) | Referência de keywords |
| [RobotToPGListener](https://github.com/carlosnizolli/RobotToPGListener) | Persistência de resultados RF no PostgreSQL |
| [docker-robotframework](https://github.com/carlosnizolli/docker-robotframework) | Imagem Docker para RF + Browser |
| [RoboCop](https://github.com/carlosnizolli/RoboCop) | GitHub Action do Robocop |

---

## O que este repositório é (e o que não é)

As suites são **exemplos didáticos**. Não automatizam um sistema real sob teste. Elas ensinam um padrão reutilizável:

1. Fazer uma pergunta em um site amigável a IA (Wolfram Alpha) pelo browser
2. Capturar a resposta exibida na página
3. Enviar pergunta + resposta ao Gemini e obter um veredito **Sim / Não** sobre coerência

Você pode reutilizar a mesma ideia com seu app, UI ou respostas de API.

## Os três exemplos (lado a lado)

| Pasta | Estilo de integração | Dependência Gemini | Quando escolher |
|-------|----------------------|--------------------|-----------------|
| [`ROBOTFRAMEWORK_GEMINI/`](ROBOTFRAMEWORK_GEMINI/) | Biblioteca Robot publicada [`robotframework-gemini`](https://pypi.org/project/robotframework-gemini/) (`GeminiLibrary`) | `robotframework-gemini` | Keywords prontas (`Gemini Evaluate Text`, `Gemini Evaluate Text Verdict`, …) |
| [`GOOGLE_GENAI/`](GOOGLE_GENAI/) | SDK oficial atual em biblioteca Python própria (`from google import genai`) | `google-genai` | Aprender o SDK Google GenAI moderno dentro do Robot |
| [`LEGACY_GENAI/`](LEGACY_GENAI/) | SDK legado em biblioteca Python própria (`google.generativeai`) | `google-generativeai` | Comparar com tutoriais antigos / migrar do pacote legado |

Helpers de browser compartilhados: [`Resources/`](Resources/) (automação Wolfram Alpha, perguntas demo, carga do `.env`).

## Pré-requisitos

- **Python 3.10+** recomendado (3.9+ em geral funciona)
- **pip** e ambiente virtual
- **Chave da API Gemini** em [Google AI Studio](https://aistudio.google.com/apikey)
- Acesso à rede (Wolfram Alpha + API Gemini)

Opcional: definir `GEMINI_MODEL` se não quiser o padrão de cada exemplo.

## Início rápido (caminho recomendado)

Comece por **`ROBOTFRAMEWORK_GEMINI`** — menos Python para ler e a mesma história de teste das outras pastas.

```bash
# 1) Clone e entre no repositório
git clone https://github.com/carlosnizolli/robotframework-gemini_exemplos.git
cd robotframework-gemini_exemplos

# 2) Crie e ative um virtualenv
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# 3) Instale as dependências do exemplo com a biblioteca Robot
pip install -r requirements-modern.txt

# 4) Instale os browsers do Playwright usados pelo robotframework-browser
rfbrowser init

# 5) Configure a chave (escolha uma forma)
export GEMINI_API_KEY="sua-chave-aqui"
# ou crie um arquivo .env na raiz do repositório:
# GEMINI_API_KEY=sua-chave-aqui
# GEMINI_MODEL=gemini-flash-latest   # opcional

# 6) Execute a suite
cd ROBOTFRAMEWORK_GEMINI
robot -d Results Suites/DemoRobotframeworkGemini.robot
```

Abra `ROBOTFRAMEWORK_GEMINI/Results/report.html` depois da execução.

> O browser abre com `headless=false` para você acompanhar o Wolfram Alpha durante o estudo.

## Instalação de cada exemplo

Use **virtualenvs separados** se quiser evitar misturar os dois SDKs Google (`google-genai` vs `google.generativeai`).

### A) `ROBOTFRAMEWORK_GEMINI` (biblioteca no PyPI)

```bash
pip install -r requirements-modern.txt
rfbrowser init
```

### B) `GOOGLE_GENAI` (SDK atual)

```bash
pip install -r requirements-google-genai.txt
rfbrowser init
```

### C) `LEGACY_GENAI` (SDK legado)

```bash
pip install -r requirements-legacy.txt
rfbrowser init
```

## Chave de API e variáveis de ambiente

| Variável | Obrigatória | Descrição |
|----------|-------------|-----------|
| `GEMINI_API_KEY` | Sim (nos testes que chamam Gemini) | Chave do Google AI Studio |
| `GEMINI_MODEL` | Não | Id do modelo. Os padrões diferem por exemplo (veja abaixo) |

Como a chave é carregada:

- Export no shell: `export GEMINI_API_KEY=...`
- Ou arquivo **`.env`** na **raiz do repositório** (`python-dotenv` carrega)

`.env` sugerido:

```env
GEMINI_API_KEY=sua-chave-aqui
# GEMINI_MODEL=gemini-flash-latest
```

**Não** faça commit de `.env` nem de chaves reais.

Modelos padrão neste repo (quando `GEMINI_MODEL` não está definido):

- `GOOGLE_GENAI` / `LEGACY_GENAI` → `gemini-flash-latest`
- `ROBOTFRAMEWORK_GEMINI` → padrão da biblioteca, ou defina `GEMINI_MODEL` (o CI usa `gemini-flash-latest`)

## Como executar (todas as suites)

Execute a partir da pasta de cada exemplo para os resources relativos funcionarem.

```bash
# Biblioteca publicada
cd ROBOTFRAMEWORK_GEMINI
robot -d Results Suites/DemoRobotframeworkGemini.robot

# SDK Google GenAI atual
cd ../GOOGLE_GENAI
robot -d Results Suites/DemoGoogleGenai.robot

# SDK legado
cd ../LEGACY_GENAI
robot -d Results Suites/DemoLegacyGenai.robot
```

Variantes úteis:

```bash
# Só o smoke (sem chamada ao Gemini)
robot -d Results -t "CT01*" Suites/DemoRobotframeworkGemini.robot

# Uma validação factual com Gemini
robot -d Results -t "CT02*" Suites/DemoRobotframeworkGemini.robot

# Por tag
robot -d Results -i robotframework_gemini Suites/DemoRobotframeworkGemini.robot
```

Artefatos: `Results/log.html`, `Results/report.html`, screenshots (também em falha).

## O que cada caso de teste ensina

As três suites compartilham as mesmas quatro histórias:

| Caso | O que faz | Usa Gemini? |
|------|-----------|-------------|
| **CT01** | Smoke: abre Wolfram Alpha, confirma resultado, screenshot | Não |
| **CT02** | Pergunta fixa de geografia (*capital of Brazil*), tema + veredito de coerência | Sim |
| **CT03** | Pergunta fixa de aritmética (*7 times 8*), tema + veredito | Sim |
| **CT04** | Gemini **gera** a pergunta (estado brasileiro + capital), o site responde, Gemini julga | Sim |

Dados fixos compartilhados: [`Resources/DemoData.resource`](Resources/DemoData.resource).

## Mapa de pastas (ordem de estudo)

```text
robotframework-gemini_exemplos/
├── README.md                        # documentação em inglês
├── README.pt-BR.md                  # documentação em português
├── requirements-modern.txt          # ROBOTFRAMEWORK_GEMINI
├── requirements-google-genai.txt    # GOOGLE_GENAI
├── requirements-legacy.txt          # LEGACY_GENAI
├── Resources/                       # compartilhado pelas suites
│   ├── SiteComIa.resource           # keywords Wolfram Alpha + Browser
│   ├── DemoData.resource            # perguntas/temas de exemplo
│   ├── DotenvBootstrap.py           # carrega .env para GeminiLibrary
│   ├── UrlUtils.py
│   └── WolframExtract.py
├── ROBOTFRAMEWORK_GEMINI/           # ← comece aqui
│   ├── Suites/DemoRobotframeworkGemini.robot
│   └── Resources/ModernGeminiDemo.resource
├── GOOGLE_GENAI/
│   ├── Suites/DemoGoogleGenai.robot
│   └── Resources/
│       ├── GoogleGenaiDemo.resource
│       └── GoogleGenaiLibrary.py    # wrapper fino do google-genai
└── LEGACY_GENAI/
    ├── Suites/DemoLegacyGenai.robot
    └── Resources/
        ├── LegacyGeminiDemo.resource
        └── LegacyGeminiLibrary.py   # wrapper fino do google.generativeai
```

Caminho de estudo sugerido:

1. Ler e executar **`ROBOTFRAMEWORK_GEMINI`**
2. Abrir **`GOOGLE_GENAI/.../GoogleGenaiLibrary.py`** e ver as mesmas ideias com `from google import genai`
3. Abrir **`LEGACY_GENAI/.../LegacyGeminiLibrary.py`** para entender a migração a partir de `google.generativeai`

## Fluxo conceitual

```text
┌─────────────────┐     pergunta      ┌──────────────────┐
│  Suite Robot    │ ───────────────►  │  Wolfram Alpha   │
│  (Browser)      │ ◄───────────────  │  (resposta page) │
└────────┬────────┘     texto capturado └──────────────────┘
         │
         │  pergunta + resposta + critério
         ▼
┌─────────────────┐     Sim / Não     ┌──────────────────┐
│  Juiz Gemini    │ ───────────────►  │  assert "Sim"    │
│  (3 integrações)│                   │  na suite        │
└─────────────────┘                   └──────────────────┘
```

## Solução de problemas

| Sintoma | O que verificar |
|---------|-----------------|
| `GEMINI_API_KEY não configurada` / chave ausente | Exporte a variável ou crie `.env` na **raiz do repo** e rode de novo na pasta do exemplo |
| Erros de Browser / Playwright | Rode `rfbrowser init` de novo no venv ativo |
| Resultado Wolfram vazio / timeout | O site pode demorar; as suites já esperam e retentam. Rode de novo ou ajuste waits em `SiteComIa.resource` |
| Veredito `Não` inesperado | Leia o texto bruto do Gemini no log; a resposta da página pode estar fora do tema |
| Conflito de pacotes / import | Evite misturar `google-genai` e `google-generativeai` no mesmo venv |

## Observação

Exemplos educacionais. Wolfram Alpha e Gemini são serviços de terceiros — respeite os termos de uso e as cotas da API.

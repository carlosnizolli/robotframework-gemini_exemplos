# robotframework-gemini — Examples

**English** · [Português (Brasil)](README.pt-BR.md)

Didactic repository that shows how to combine **Robot Framework**, **browser automation**, and **Google Gemini** as a text judge — comparing three ways to call the Gemini API.

---

## Related projects / Projetos relacionados

This repository demonstrates [**robotframework-gemini**](https://pypi.org/project/robotframework-gemini/):

```bash
pip install robotframework-gemini
```

| Project | Description |
|---------|-------------|
| [robotframework-gemini](https://github.com/carlosnizolli/robotframework-gemini) | Library (PyPI) |
| [docs (en)](https://github.com/carlosnizolli/robotframework-gemini/blob/main/docs/KEYWORDS.en.md) | Keyword reference |
| [RobotToPGListener](https://github.com/carlosnizolli/RobotToPGListener) | Persist RF results to PostgreSQL |
| [docker-robotframework](https://github.com/carlosnizolli/docker-robotframework) | Docker image for RF + Browser |
| [robotframework-docker-actions](https://github.com/carlosnizolli/robotframework-docker-actions) | GitHub Action to run tests with the Docker image in CI |
| [RoboCop](https://github.com/carlosnizolli/RoboCop) | Robocop GitHub Action |

---

## What this repository is (and is not)

These suites are **learning examples**. They do not automate a real product under test. They teach a reusable pattern:

1. Ask a question on an AI-friendly website (Wolfram Alpha) via the browser
2. Capture the answer shown on the page
3. Send question + answer to Gemini and get a **Sim / Não** (Yes / No) verdict on coherence

You can reuse the same idea with your own app, UI, or API responses.

## The three examples (side by side)

| Folder | Integration style | Gemini dependency | Best when you want to… |
|--------|-------------------|-------------------|------------------------|
| [`ROBOTFRAMEWORK_GEMINI/`](ROBOTFRAMEWORK_GEMINI/) | Published Robot library [`robotframework-gemini`](https://pypi.org/project/robotframework-gemini/) (`GeminiLibrary`) | `robotframework-gemini` | Use ready-made keywords (`Gemini Evaluate Text`, `Gemini Evaluate Text Verdict`, …) |
| [`GOOGLE_GENAI/`](GOOGLE_GENAI/) | Current official SDK in a custom Python library (`from google import genai`) | `google-genai` | Learn the modern Google GenAI SDK inside Robot |
| [`LEGACY_GENAI/`](LEGACY_GENAI/) | Legacy SDK in a custom Python library (`google.generativeai`) | `google-generativeai` | Compare with older tutorials / migrate from the legacy package |

Shared browser helpers live in [`Resources/`](Resources/) (Wolfram Alpha automation, demo questions, `.env` bootstrap).

## Prerequisites

- **Python 3.10+** recommended (3.9+ usually works)
- **pip** and a virtual environment
- A **Gemini API key** from [Google AI Studio](https://aistudio.google.com/apikey)
- Network access (Wolfram Alpha + Gemini API)

Optional: set `GEMINI_MODEL` if you do not want the default per example.

## Quick start (recommended path)

Start with **`ROBOTFRAMEWORK_GEMINI`** — fewer Python files to read and the same test story as the other folders.

```bash
# 1) Clone and enter the repo
git clone https://github.com/carlosnizolli/robotframework-gemini_exemplos.git
cd robotframework-gemini_exemplos

# 2) Create and activate a virtualenv
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# 3) Install dependencies for the modern Robot library example
pip install -r requirements-modern.txt

# 4) Install Playwright browsers used by robotframework-browser
rfbrowser init

# 5) Configure your API key (pick one)
export GEMINI_API_KEY="your-key-here"
# or create a .env file in the repo root:
# GEMINI_API_KEY=your-key-here
# GEMINI_MODEL=gemini-flash-latest   # optional

# 6) Run the suite
cd ROBOTFRAMEWORK_GEMINI
robot -d Results Suites/DemoRobotframeworkGemini.robot
```

Open `ROBOTFRAMEWORK_GEMINI/Results/report.html` after the run.

> The browser opens with `headless=false` so you can watch Wolfram Alpha during the lesson.

## Install each example separately

Use **separate virtualenvs** if you want to avoid mixing the two Google SDKs (`google-genai` vs `google-generativeai`).

### A) `ROBOTFRAMEWORK_GEMINI` (library from PyPI)

```bash
pip install -r requirements-modern.txt
rfbrowser init
```

### B) `GOOGLE_GENAI` (current SDK)

```bash
pip install -r requirements-google-genai.txt
rfbrowser init
```

### C) `LEGACY_GENAI` (legacy SDK)

```bash
pip install -r requirements-legacy.txt
rfbrowser init
```

## API key and environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GEMINI_API_KEY` | Yes (for tests that call Gemini) | Key from Google AI Studio |
| `GEMINI_MODEL` | No | Model id. Defaults differ by example (see below) |

How the key is loaded:

- Export in the shell: `export GEMINI_API_KEY=...`
- Or put it in a **`.env`** file at the **repository root** (`python-dotenv` loads it)

Suggested `.env`:

```env
GEMINI_API_KEY=your-key-here
# GEMINI_MODEL=gemini-flash-latest
```

Do **not** commit `.env` or real keys.

Default models in this repo (when `GEMINI_MODEL` is unset):

- `GOOGLE_GENAI` / `LEGACY_GENAI` → `gemini-flash-latest`
- `ROBOTFRAMEWORK_GEMINI` → library default, or set `GEMINI_MODEL` (CI uses `gemini-flash-latest`)

## How to run (all suites)

Run commands from each example folder so relative resources resolve correctly.

```bash
# Published library
cd ROBOTFRAMEWORK_GEMINI
robot -d Results Suites/DemoRobotframeworkGemini.robot

# Current Google GenAI SDK
cd ../GOOGLE_GENAI
robot -d Results Suites/DemoGoogleGenai.robot

# Legacy SDK
cd ../LEGACY_GENAI
robot -d Results Suites/DemoLegacyGenai.robot
```

Useful variants:

```bash
# Only the smoke test (no Gemini call)
robot -d Results -t "CT01*" Suites/DemoRobotframeworkGemini.robot

# One factual validation with Gemini
robot -d Results -t "CT02*" Suites/DemoRobotframeworkGemini.robot

# By tag
robot -d Results -i robotframework_gemini Suites/DemoRobotframeworkGemini.robot
```

Artifacts: `Results/log.html`, `Results/report.html`, screenshots (including on failure).

## What each test case teaches

All three suites share the same four stories:

| Case | What it does | Uses Gemini? |
|------|--------------|--------------|
| **CT01** | Smoke: open Wolfram Alpha, assert a result exists, screenshot | No |
| **CT02** | Fixed geography question (*capital of Brazil*), theme check + Gemini coherence verdict | Yes |
| **CT03** | Fixed arithmetic (*7 times 8*), theme check + Gemini verdict | Yes |
| **CT04** | Gemini **generates** a question (Brazilian state + capital), site answers, Gemini judges | Yes |

Shared fixed data: [`Resources/DemoData.resource`](Resources/DemoData.resource).

## Folder map (study order)

```text
robotframework-gemini_exemplos/
├── README.md                        # English docs
├── README.pt-BR.md                  # Portuguese docs
├── requirements-modern.txt          # ROBOTFRAMEWORK_GEMINI
├── requirements-google-genai.txt    # GOOGLE_GENAI
├── requirements-legacy.txt          # LEGACY_GENAI
├── Resources/                       # shared by all suites
│   ├── SiteComIa.resource           # Wolfram Alpha + Browser keywords
│   ├── DemoData.resource            # sample questions/themes
│   ├── DotenvBootstrap.py           # load .env for GeminiLibrary
│   ├── UrlUtils.py
│   └── WolframExtract.py
├── ROBOTFRAMEWORK_GEMINI/           # ← start here
│   ├── Suites/DemoRobotframeworkGemini.robot
│   └── Resources/ModernGeminiDemo.resource
├── GOOGLE_GENAI/
│   ├── Suites/DemoGoogleGenai.robot
│   └── Resources/
│       ├── GoogleGenaiDemo.resource
│       └── GoogleGenaiLibrary.py    # thin google-genai wrapper
└── LEGACY_GENAI/
    ├── Suites/DemoLegacyGenai.robot
    └── Resources/
        ├── LegacyGeminiDemo.resource
        └── LegacyGeminiLibrary.py   # thin google.generativeai wrapper
```

Suggested study path:

1. Read and run **`ROBOTFRAMEWORK_GEMINI`**
2. Open **`GOOGLE_GENAI/.../GoogleGenaiLibrary.py`** and see the same ideas with `from google import genai`
3. Open **`LEGACY_GENAI/.../LegacyGeminiLibrary.py`** to understand migration from `google.generativeai`

## Conceptual flow

```text
┌─────────────────┐     question      ┌──────────────────┐
│  Robot Suite    │ ───────────────►  │  Wolfram Alpha   │
│  (Browser lib)  │ ◄───────────────  │  (page answer)   │
└────────┬────────┘     captured text └──────────────────┘
         │
         │  question + answer + criterion
         ▼
┌─────────────────┐     Sim / Não     ┌──────────────────┐
│  Gemini judge   │ ───────────────►  │  assert "Sim"    │
│  (3 integrations)│                  │  in the suite    │
└─────────────────┘                   └──────────────────┘
```

## Troubleshooting

| Symptom | What to check |
|---------|----------------|
| `GEMINI_API_KEY não configurada` / missing key | Export the variable or add `.env` at the **repo root**, then rerun from the example folder |
| Browser / Playwright errors | Run `rfbrowser init` again inside the active venv |
| Empty Wolfram result / timeouts | Site may be slow; suites wait and retry. Retry the run or increase waits in `SiteComIa.resource` |
| Verdict is `Não` unexpectedly | Read the raw Gemini text in the log; the page answer may be off-topic or incomplete |
| Package / import conflicts | Do not mix `google-genai` and `google-generativeai` in the same venv unless you know what you are doing |

## License / courtesy note

Examples are educational. Wolfram Alpha and Gemini are third-party services — respect their terms and your API quotas.

"""
Exemplo didático — SDK atual Google GenAI (pacote ``google-genai``)
em biblioteca Python customizada.

Este repositório contém exemplos para aprender integração de Gemini
com Robot Framework.
Documentação do SDK:
https://ai.google.dev/gemini-api/docs/generate-content/get-started?hl=pt-br

    from google import genai
    client = genai.Client()
    response = client.models.generate_content(
        model="...", contents="..."
    )

Compare com:
- LEGACY_GENAI/ → ``google.generativeai`` (SDK legado)
- ROBOTFRAMEWORK_GEMINI/ → ``robotframework-gemini``
  (biblioteca Robot publicada)

Requer: GEMINI_API_KEY (e opcionalmente GEMINI_MODEL,
padrão gemini-2.5-flash).
"""

from __future__ import annotations

import os
import re

from dotenv import load_dotenv
from google import genai
from robot.api.deco import keyword

load_dotenv()


class GoogleGenaiLibrary:
    """Wrapper mínimo do SDK google-genai para Robot Framework."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_VERSION = "1.0.0"

    def __init__(self, api_key: str | None = None, model: str | None = None):
        self.api_key = (api_key or os.getenv("GEMINI_API_KEY") or "").strip()
        self.model_name = (
            model or os.getenv("GEMINI_MODEL") or "gemini-2.5-flash"
        ).strip()
        self._client = None

    def _get_client(self):
        if self._client is None:
            if not self.api_key:
                raise ValueError("GEMINI_API_KEY não configurada")
            self._client = genai.Client(api_key=self.api_key)
        return self._client

    def _generate(self, prompt: str) -> str:
        response = self._get_client().models.generate_content(
            model=self.model_name,
            contents=prompt,
        )
        text = getattr(response, "text", None) or ""
        return text.strip()

    @keyword("Google Genai Evaluate Text")
    def google_genai_evaluate_text(
        self,
        context: str,
        evaluation: str,
        extra_instructions: str | None = None,
    ) -> str:
        """Avaliação texto-only (contexto + critério). Retorna texto bruto."""
        parts = [context, "", "## CRITÉRIO", evaluation]
        if extra_instructions:
            parts.extend(
                ["", "## INSTRUÇÕES DE SAÍDA", extra_instructions]
            )
        return self._generate("\n".join(parts))

    @keyword("Google Genai Evaluate Text Verdict")
    def google_genai_evaluate_text_verdict(
        self,
        context: str,
        evaluation: str,
        output_instructions: str,
    ) -> str:
        """Juiz textual; retorna texto bruto (ex.: Sim/Não)."""
        return self.google_genai_evaluate_text(
            context, evaluation, output_instructions
        )

    @keyword("Google Genai Parse First Line")
    def google_genai_parse_first_line(self, raw: str) -> str:
        """Extrai e normaliza a primeira linha de uma resposta do modelo."""
        line = (raw or "").splitlines()[0] if raw else ""
        return line.strip()

    @keyword("Google Genai Generate Question")
    def google_genai_generate_question(
        self,
        prompt_context: str,
        output_instructions: str,
    ) -> str:
        """Gera uma pergunta curta sobre um tema."""
        prompt = "\n".join([prompt_context, "", output_instructions])
        return self._generate(prompt)

    @keyword("Google Genai Assert Verdict Is Sim")
    def google_genai_assert_verdict_is_sim(self, raw_verdict: str) -> None:
        """Falha o teste se a primeira linha do veredito não for Sim."""
        first = self.google_genai_parse_first_line(raw_verdict)
        normalized = re.sub(r"[^a-zA-Zà-üÀ-Ü]", "", first).lower()
        if normalized != "sim":
            raise AssertionError(
                f"Veredito esperado 'Sim', obtido: '{first}' "
                f"(raw: {raw_verdict})"
            )

"""
Exemplo didático — SDK legado google.generativeai em biblioteca Python customizada.

Este repositório contém exemplos para aprender integração de Gemini com Robot Framework.
Compare com:
- GOOGLE_GENAI/  → ``google-genai`` (SDK atual)
- ROBOTFRAMEWORK_GEMINI/  → ``robotframework-gemini`` (biblioteca Robot publicada)

Requer: GEMINI_API_KEY (e opcionalmente GEMINI_MODEL, padrão gemini-flash-latest).
"""

from __future__ import annotations

import os
import re

import google.generativeai as genai
from dotenv import load_dotenv
from robot.api.deco import keyword

load_dotenv()


class LegacyGeminiLibrary:
    """Wrapper mínimo do SDK legado google.generativeai para Robot Framework."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_VERSION = "1.0.0"

    def __init__(self, api_key: str | None = None, model: str | None = None):
        self.api_key = (api_key or os.getenv("GEMINI_API_KEY") or "").strip()
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY não configurada")
        self.model_name = (
            model or os.getenv("GEMINI_MODEL") or "gemini-flash-latest"
        ).strip()
        genai.configure(api_key=self.api_key)
        self._model = genai.GenerativeModel(self.model_name)

    def _generate(self, prompt: str) -> str:
        response = self._model.generate_content(prompt)
        text = getattr(response, "text", None) or ""
        return text.strip()

    @keyword("Legacy Gemini Evaluate Text")
    def legacy_gemini_evaluate_text(
        self,
        context: str,
        evaluation: str,
        extra_instructions: str | None = None,
    ) -> str:
        """Avaliação texto-only (contexto + critério). Retorna texto bruto do modelo."""
        parts = [context, "", "## CRITÉRIO", evaluation]
        if extra_instructions:
            parts.extend(["", "## INSTRUÇÕES DE SAÍDA", extra_instructions])
        return self._generate("\n".join(parts))

    @keyword("Legacy Gemini Evaluate Text Verdict")
    def legacy_gemini_evaluate_text_verdict(
        self,
        context: str,
        evaluation: str,
        output_instructions: str,
    ) -> str:
        """Juiz textual; retorna texto bruto (ex.: Sim/Não na primeira linha)."""
        return self.legacy_gemini_evaluate_text(context, evaluation, output_instructions)

    @keyword("Legacy Gemini Parse First Line")
    def legacy_gemini_parse_first_line(self, raw: str) -> str:
        """Extrai e normaliza a primeira linha de uma resposta do modelo."""
        line = (raw or "").splitlines()[0] if raw else ""
        return line.strip()

    @keyword("Legacy Gemini Generate Question")
    def legacy_gemini_generate_question(
        self,
        prompt_context: str,
        output_instructions: str,
    ) -> str:
        """Gera uma pergunta curta sobre um tema."""
        prompt = "\n".join(
            [
                prompt_context,
                "",
                output_instructions,
            ]
        )
        return self._generate(prompt)

    @keyword("Legacy Gemini Response Contains Theme")
    def legacy_gemini_response_contains_theme(
        self,
        response: str,
        expected_theme: str,
    ) -> bool:
        """Verificação simples (sem IA): tema esperado aparece na resposta (case insensitive)."""
        if expected_theme.lower() not in (response or "").lower():
            raise AssertionError(
                f"Tema '{expected_theme}' não encontrado na resposta: {response}"
            )
        return True

    @keyword("Legacy Gemini Assert Verdict Is Sim")
    def legacy_gemini_assert_verdict_is_sim(self, raw_verdict: str) -> None:
        """Falha o teste se a primeira linha do veredito não for Sim."""
        first = self.legacy_gemini_parse_first_line(raw_verdict)
        normalized = re.sub(r"[^a-zA-Zà-üÀ-Ü]", "", first).lower()
        if normalized != "sim":
            raise AssertionError(f"Veredito esperado 'Sim', obtido: '{first}' (raw: {raw_verdict})")

from robot.api.deco import keyword, library


SCRIPT_EXTRAI_RESULTADO = r"""
() => {
  const isNoise = (value) => /marketing|wolfram|logo|step by step|input interpretation|capital city\s*\|/i.test(value || '');
  const body = document.body.innerText || '';
  const chunks = body.split(/\nResult\s*\n/i);
  for (let i = 1; i < chunks.length; i++) {
    const lines = chunks[i].split('\n').map((line) => line.trim()).filter(Boolean);
    for (const line of lines) {
      if (!isNoise(line)) return line;
    }
  }
  const alts = [...document.querySelectorAll('img[alt]')]
    .map((img) => (img.alt || '').trim())
    .filter((alt) => alt && !isNoise(alt));
  const rich = alts.find((alt) => alt.includes(','));
  if (rich) return rich;
  const numeric = alts.find((alt) => /^\d+([.,]\d+)?$/.test(alt));
  return numeric || alts[0] || '';
}
""".strip()


@library(scope="GLOBAL", auto_keywords=True)
class WolframExtract:
    """Extração de resultado do Wolfram Alpha para os exemplos didáticos com Browser Library."""

    @keyword("Script Extrai Resultado Wolfram")
    def script_extrai_resultado_wolfram(self) -> str:
        """Retorna script JS para ler o pod Result do Wolfram Alpha."""
        return SCRIPT_EXTRAI_RESULTADO

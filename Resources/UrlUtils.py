from urllib.parse import quote_plus

from robot.api.deco import keyword, library


@library(scope="GLOBAL", auto_keywords=True)
class UrlUtils:
    """Utilitários de URL para os exemplos didáticos."""

    @keyword("Codifica Texto Para Url")
    def codifica_texto_para_url(self, text: str) -> str:
        """Codifica texto para uso em query string (ex.: Wolfram Alpha)."""
        return quote_plus((text or "").strip())

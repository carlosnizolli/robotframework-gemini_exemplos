"""Carrega variáveis do arquivo .env antes de inicializar bibliotecas que leem GEMINI_API_KEY."""


from dotenv import load_dotenv

load_dotenv()

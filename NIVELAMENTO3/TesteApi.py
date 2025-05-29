from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from pydantic import BaseModel

app = FastAPI()

vendas = {
    1: {"item": "lata", "preco_unitario": 4, "quantidade": 5},
    2: {"item": "garrafa 2L", "preco_unitario": 15, "quantidade": 5},
    3: {"item": "garrafa 750ml", "preco_unitario": 10, "quantidade": 5},
    4: {"item": "lata mini", "preco_unitario": 2, "quantidade": 5},
}

class Venda(BaseModel):
    item: str
    preco_unitario: float
    quantidade: int

@app.get("/", response_class=HTMLResponse)
def home():
    html_content = """
    <html>
        <head>
            <title>API de Vendas</title>
        </head>
        <body>
            <h1>Bem-vindo à API de Vendas!</h1>
            <ul>
                <li><a href="/vendas">📦 Ver todas as vendas</a></li>
                <li><a href="/vendas/1">🔍 Ver venda com ID 1</a></li>
                <li><a href="/docs">🛠️ Documentação interativa (Swagger)</a></li>
            </ul>
        </body>
    </html>
    """
    return html_content

@app.get("/vendas")
def listar_vendas():
    return vendas

@app.get("/vendas/{id_venda}")
def pegar_venda(id_venda: int):
    if id_venda in vendas:
        return vendas[id_venda]
    else:
        return {"Erro": "ID Venda inexistente"}

@app.post("/vendas")
def adicionar_venda(venda: Venda):
    novo_id = max(vendas.keys()) + 1 if vendas else 1
    vendas[novo_id] = venda.dict()
    return {"mensagem": "Venda adicionada com sucesso", "id": novo_id}

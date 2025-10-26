# ApolicesApi
Projeto desenvolvido para simular o gerenciamento de apólices de seguro e seus endossos.

## Como rodar o projeto

## 1 - Clonar o repositório

```bash
git clone https://github.com/UlyssesFerreira/apolices_api.git
```
```bash
cd apolices_api
```

## 2 - Criar e subir os containers
```bash
docker compose up --build
```
### Isso vai subir os containers com:
- Aplicação Rails na porta 3000
- Banco de dados PostgreSQL na porta 5432

## Endpoints

### Apólices
### Criar uma apólice
```http
POST /api/policies
```
### Body:
```json
{
    "policy": {
        "numero": "123",
        "data_emissao": "2025-10-21",
        "inicio_vigencia": "2025-10-21",
        "fim_vigencia": "2025-12-01",
        "importancia_segurada": 5000,
        "lmg": 5000
    }
}
```

### Buscar apólice pelo ID
```http
GET /api/policies/:policy_id
```

### Listar todas apólices
```http
GET /api/policies
```

### Endosso
### Criar um endosso em uma apólice
```http
POST /api/:policy_id/endorsements
```
### Body:
```json
{
    "endorsement": {
        "importancia_segurada": 7000,
        "fim_vigencia": "2026-01-01"
    }
}
```
### Buscar endosso de uma apólice pelo ID
```http
GET /api/:policy_id/endorsements/:endorsement_id
```

### Listar todos endossos de uma apólices
```http
GET /api/:policy_id/endorsements
```

### Cancelar o último endosso válido de uma apólice
```http
POST /api/:policy_id/endorsements/cancel
```

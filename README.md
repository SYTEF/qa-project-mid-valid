# QA Project MID Valid  
> Framework de Garantia de Qualidade focado em **integridade de pagamentos**, **validação de regras de negócio** e **testes de escalabilidade** em APIs financeiras (POS → Backend).

![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Robot Framework](https://img.shields.io/badge/Robot_Framework-Testing-green)
![Locust](https://img.shields.io/badge/Load_Test-Locust-black)
![Status](https://img.shields.io/badge/Status-Em_Desenvolvimento-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)


## **Objetivo** 
Este projeto tem como meta garantir a **confiabilidade e integridade** das comunicações entre terminais POS e serviços backend.  
A automação cobre:
- **Integridade de MID** (Merchant ID) — validações de identidade e respostas HTTP.  
- **Regras de Negócio** — testes de consistência baseados em dados (`data-driven`).  
- **Escalabilidade e Performance** — simulações de carga com usuários simultâneos.

**Arquitetura da Solução**

| Pilar | Descrição | Ferramenta |
|:--|:--|:--|
| **Integridade (MID)** | Testes de autenticação e resposta do backend em transações POS | Robot Framework |
| **Regras de Negócio** | Validação automatizada de retornos 400 com base em parâmetros críticos | Robot Framework + CSV |
| **Escalabilidade** | Medição de performance sob carga, p95, TPS e latência | Locust 

<img width="1187" height="247" alt="MIDX-MIDY drawio" src="https://github.com/user-attachments/assets/3e70e8b5-a904-4d1f-a1cc-4fb2cf45fdd4" />

<img width="610" height="1072" alt="PANDASCSV" src="https://github.com/user-attachments/assets/8a1b8293-0490-44ca-8e87-d26232bfb811" />

<img width="1328" height="239" alt="LOCUST" src="https://github.com/user-attachments/assets/46cca2eb-2174-4b22-86ea-55ef69fdb864" />

**Stack Utilizada**
| Categoria | Tecnologia | Função |
|:--|:--|:--|
| Automação de Testes | **Robot Framework** | Execução de testes funcionais e de API |
| Manipulação de Dados | **Pandas** | Leitura e tratamento de cenários data-driven |
| Teste de Carga | **Locust** | Simulação de múltiplos usuários |
| Linguagem | **Python 3.10+** | Base principal do projeto |
| Relatórios | **Robot Report + HTML** | Saída visual e análise de resultados |



---
## **Como Executar o Projeto**

### 1. Clonar o repositório
git clone https://github.com/SYTEF/qa-project-mid-valid.git
cd qa-project-mid-valid

### 2. Criar e ativar o ambiente virtual
Windows (Git Bash):

python -m venv env
source env/Scripts/activate

### 3. Instalar dependências
pip install -r requirements.txt

### 4. Executar os testes funcionais
robot Tests/MID_Integrity.robot
robot Tests/Data_Driven_Rules.robot

### 5. Executar o teste de carga
locust -f locustfile.py

## (MID Integrity)

O teste verifica a regra de **segurança crítica**: impedir que um MID tente capturar a transação de outro MID.

**Comando Executado:** `robot Tests/MID_Integrity.robot`

**Evidência:** O *framework* confirma o sucesso da execução funcional.

<img width="606" height="268" alt="{360FB7CD-7C96-4B59-AB8D-80BB721C67B7}" src="https://github.com/user-attachments/assets/94092609-fc2a-4d5a-bcc6-177142e45c10" />


### 2. Validação da Regra de Negócio

O teste não apenas falha, mas verifica o código de erro exato.

**Análise do Log:** O log detalhado prova que o sistema retornou o status **`403 Forbidden`** e a mensagem de negócio **`MID_MISMATCH`**.

<img width="1889" height="935" alt="{8F43F837-B9A1-4836-B8B5-9D2072BEC746}" src="https://github.com/user-attachments/assets/29cb4753-ae21-424d-ab0a-b5aea243c8c6" />


> **Conclusão:** "O `MID_Integrity.robot` estabeleceu o **Primeiro Quality Gate**, provando que o *backend* atua como um portão de segurança eficaz."

---

## Módulo 2: Cobertura e Escalabilidade de Regras (Pandas DDT)

### 1. Execução do Data-Driven Testing

Para validar a cobertura de Regras de Negócio (`400 Bad Request`), o *framework* usa **Pandas** para ler os dados e repete a *Keyword* principal. A estrutura foi ajustada para reportar a contagem correta dos testes.

**Comando Executado:** `robot Tests/Data_Driven_Rules.robot`

**Evidência:** O terminal confirma que todos os cenários do CSV foram processados.

<img width="910" height="398" alt="{7CD32B03-7F13-4DCC-85A8-3BF5AD1A1555}" src="https://github.com/user-attachments/assets/29f3e42e-4d1a-4d83-a27a-8bbcaeba9235" />


### 2. Validação Lógica dos Limites

O log confirma a asserção correta para as regras de validação.

**Análise do Log:** O log detalhado prova que o *framework* validou tanto o sucesso (`200`) quanto as falhas de validação (`400`). Exemplo: A validação `Status 400 validado` para o cenário de valor zero.

<img width="1908" height="507" alt="{C817DF14-F17F-4F6C-9F8C-EC5C8C8F5940}" src="https://github.com/user-attachments/assets/24653c83-638e-4b0c-b64d-ef8c5ef38725" />
<img width="1802" height="226" alt="{0DB13140-667F-43FA-80E8-2DCA373C77AF}" src="https://github.com/user-attachments/assets/2d50bce9-f89f-4093-a7f0-a1cf87d88820" />
<img width="1871" height="233" alt="{059EA84F-8E76-4F5C-A44E-4067E46711BE}" src="https://github.com/user-attachments/assets/7391227a-4df1-4c31-b503-8a11f312aee4" />
<img width="1797" height="226" alt="{C02BBB2C-929D-49E3-A159-F2B149C6642C}" src="https://github.com/user-attachments/assets/2be26db1-a027-458b-ae14-0f0db4657c86" />
<img width="1806" height="233" alt="{7BEFD184-5809-4B28-8D72-15FC7385E23A}" src="https://github.com/user-attachments/assets/107a61a5-b652-41d1-9659-e41efb25bcce" />


> **Conclusão:** "O **Data-Driven Testing** garante que a falha de **Segurança (`403`)** é tratada separadamente da falha de **Validação de Regra de Negócio (`400`)**, garantindo a cobertura completa."

---

## Módulo 3: Performance e Visão Estratégica

### 1. Teste de Carga (Locust)

O teste de carga simula o volume de operação para medir se o sistema é **Resistente** sob stress.

**Comando Executado:** `locust`
<img width="1488" height="900" alt="total_requests_per_second_1762486642 607 (1)" src="https://github.com/user-attachments/assets/6c5f9a93-abcc-452f-9b73-e658276b2cc1" />
<img width="1230" height="461" alt="{648175FC-8FD5-4F19-A5D9-71F230406527}" src="https://github.com/user-attachments/assets/4788ee3a-07a9-4108-9ec5-917069a3a434" />



# Framework de Integridade de Pagamentos (POS-Backend)

Meu objetivo não foi apenas criar uma automação, mas sim conectar meu conhecimento de **Hardware (POS)** com os riscos reais do *backend*. O *framework* ataca a regra de negócio mais crítica para a integridade dos pagamentos: a **Consistência do Merchant ID (MID)** entre a Autorização e a Captura.

## 1. O Problema e Minha Abordagem (A Arquitetura)

O maior risco em um sistema de pagamentos distribuído é a inconsistência de dados. Se uma Maquininha (POS) autoriza uma transação (`MID X`) e outra (`MID Y`) tenta capturá-la, isso pode gerar fraude ou falhas de conciliação.

Para visualizar e validar isso, desenhei o fluxo de arquitetura e o **Quality Gate** que meu teste verifica:

<img width="755" height="670" alt="Fluxo_Integridade_Robot_Final" src="https://github.com/user-attachments/assets/4db65f64-d2cd-4540-82fd-1600ef39025f" />

### A Lógica do Teste:
1.  **Setup (Autorização):** O teste primeiro simula uma Autorização bem-sucedida com o `MID_A`. O servidor salva esse `auth_code` e o `mid_idempotencia` (para evitar duplicidade).
2.  **O Ataque (Captura):** Em seguida, o teste simula uma tentativa de Captura usando o `auth_code` correto, mas com o `MID_B` (o MID errado).
3.  **O Quality Gate (A Prova):** O teste **PASSA** se, e somente se, o **Serviço de Captura** rejeitar o pedido com o erro exato que configuramos: `403 Forbidden: MID_MISMATCH`.

## 2. A Tecnologia (Por que Robot Framework?)

Eu escolhi o **Robot Framework** porque ele era um **diferencial da vaga** e se alinha perfeitamente com a cultura de **Team Play**:

* **Declarativo:** O teste (`Tests/MID_Integrity.robot`) é escrito em formato legível. Isso significa que um QA Manual, um PO ou um Desenvolvedor pode ler e entender a regra de negócio que está sendo testada sem precisar ser um expert em Python.
* **Keywords Reutilizáveis:** A lógica complexa da API (`Fazer Autorizacao`, `Tentar Captura...`) fica encapsulada nas *Keywords*. Isso torna a manutenção e a criação de novos testes de regras (Schemes) muito mais rápida.

## 3. Como Executar o Projeto

Para rodar este projeto, segui estes passos:

### Pré-requisitos
* Python 3.8+ (eu usei o 3.14)
* Mockoon Desktop (para simular o *backend*)
* Git

### 1. Setup do Ambiente
No terminal (usei o MINGW64), clone o projeto e prepare o ambiente:
```bash
# Clone este repositório
git clone [SEU_LINK_DO_GITHUB_AQUI]
cd stone-qa-robot-project

# Crie e ative o ambiente virtual
python -m venv venv
source venv/Scripts/activate

# Instale as dependências (Robot e a biblioteca de API)
pip install robotframework robotframework-requests pandas
```

### 2. Configurar o Servidor Simulado (Mockoon)
Para o teste funcionar, o Mockoon precisa estar rodando na porta `3001` e configurado para simular nosso Quality Gate:

1.  **Rota 1 (Setup):** `POST /api/authorize`
    * **Resposta (200 OK):** Deve retornar o JSON de sucesso com o `auth_code`.
        ```json
        { "status": "APPROVED", "auth_code": "XYZ123", "transaction_id": "{{faker 'string.uuid'}}" }
        ```
        *(Nota: Tive que corrigir a sintaxe do Faker para `string.uuid`)*

2.  **Rota 2 (Quality Gate):** `POST /api/capture`
    * **Resposta 1 (A Falha):** Status `403 Forbidden`.
        * **Regra de Ativação:** `Body` -> `merchant_id` -> `equals` -> `MID_B`.
        * **Body de Erro:**
            ```json
            { "error_code": "MID_MISMATCH", "message": "Capture failed..." }
            ```
    * **Resposta 2 (O Padrão):** Status `200 OK`.
        * **Regra de Ativação:** Nenhuma (é o *fallback*).
        * **Body de Sucesso:**
            ```json
            { "status": "CAPTURED", "capture_id": "CAP123" }
            ```

### 3. Executar o Teste
Com o `(venv)` ativo e o Mockoon rodando, execute o Robot:
```bash
robot Tests/MID_Integrity.robot
```

### 4. Verificar o Resultado
O teste foi um sucesso (`1 test, 1 passed, 0 failed`). A prova completa da execução, incluindo a captura do erro `403`, está no arquivo `log.html` gerado na raiz do projeto.

## 4. Próximos Passos (Minha Visão de Engineer III)

Este *framework* é a base. Meu plano de 6 meses seria:
1.  **CI/CD:** Integrar este teste ao *pipeline* de CI/CD para que ele se torne um **Portão de Qualidade** (Quality Gate) real, barrando *deploys* que quebrem a integridade do MID.
2.  **PactFlow:** Evoluir este teste de API para um teste de **Contrato (PactFlow)**, garantindo que o "contrato" entre o Serviço de Captura e o Banco de Dados nunca seja quebrado.
3.  **Escalar (Data-Driven):** Usar o `pandas` (que já instalei) para expandir este *framework* com um `CSV`, testando dezenas de outras regras de *Schemes* (Bandeiras) sem precisar escrever novo código.
4.  **Kotlin:** Assim que eu estiver confortável com a *stack* da Stone, o plano é migrar as *Keywords* mais críticas do Robot para bibliotecas nativas em **Kotlin** (outro diferencial da vaga), aumentando a performance e a integração com os desenvolvedores.

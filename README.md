Esta é uma apresentação do *framework* de automação que desenvolvi, focado em **garantir a Integridade Transacional e a Escalabilidade** de APIs de Alto Risco. O projeto demonstra a evolução de um teste de segurança para um **Gateway de Qualidade** completo.

## Propósito da Automação

Minha automação foi desenvolvida para abordar três pilares essenciais que definem a qualidade em sistemas de pagamento:

1.  **Integridade (403):** Garantir que o sistema bloqueie tentativas de Captura com Merchant ID (MID) inconsistente.
2.  **Regras de Negócio (400):** Provar que o sistema rejeita valores e parcelamentos inválidos, usando Data-Driven Testing (DDT).
3.  **Escalabilidade (Locust):** Medir se as APIs suportam o volume de transações de varios terminais POS.

## Tecnológica

| Categoria | Ferramenta | Benefício Estratégico |
| :--- | :--- | :--- |
| **Orquestração** | **Robot Framework** | Facilidade de escrita e **legibilidade** do teste. |
| **Escalabilidade** | **Python (Pandas)** | **Data-Driven Testing (DDT)**, permitindo cobrir 4 cenários de Regra de Negócio com *uma* única execução, garantindo a escalabilidade da cobertura. |
| **Performance** | **Locust (Python)** | Medição de **Latência P95** e (RPS) sob carga. |

---

## (MID Integrity)

### 1. Execução e Evidência de Sucesso

O teste verifica a regra de **segurança crítica**: impedir que um MID tente capturar a transação de outro MID.

**Comando Executado:** `robot Tests/MID_Integrity.robot`

**Evidência:** O *framework* confirma o sucesso da execução funcional.

**[c:\Users\enzob\AppData\Local\Packages\MicrosoftWindows.Client.Core_cw5n1h2txyewy\TempState\ScreenClip\{9393E1F9-C362-4010-8180-554826DCE92B}.png]**

### 2. Validação da Regra de Negócio

O teste não apenas falha, mas verifica o código de erro exato.

**Análise do Log:** O log detalhado prova que o sistema retornou o status **`403 Forbidden`** e a mensagem de negócio **`MID_MISMATCH`**.

**[c:\Users\enzob\AppData\Local\Packages\MicrosoftWindows.Client.Core_cw5n1h2txyewy\TempState\ScreenClip\{FB6A7CDC-CE01-486A-A36A-46C5B03CDB00}.png]**

> **Conclusão:** "O `MID_Integrity.robot` estabeleceu o **Primeiro Quality Gate**, provando que o *backend* atua como um portão de segurança eficaz."

---

## Módulo 2: Cobertura e Escalabilidade de Regras (Pandas DDT)

### 1. Execução do Data-Driven Testing

Para validar a cobertura de Regras de Negócio (`400 Bad Request`), o *framework* usa **Pandas** para ler os dados e repete a *Keyword* principal. A estrutura foi ajustada para reportar a contagem correta dos testes.

**Comando Executado:** `robot Tests/Data_Driven_Rules.robot`

**Evidência:** O terminal confirma que todos os cenários do CSV foram processados.

**[c:\Users\enzob\AppData\Local\Packages\MicrosoftWindows.Client.Core_cw5n1h2txyewy\TempState\ScreenClip\{6733CB21-5F11-472A-B673-C7E4E314311D}.png]**

### 2. Validação Lógica dos Limites

O log confirma a asserção correta para as regras de validação.

**Análise do Log:** O log detalhado prova que o *framework* validou tanto o sucesso (`200`) quanto as falhas de validação (`400`). Exemplo: A validação `Status 400 validado` para o cenário de valor zero.

**[c:\Users\enzob\AppData\Local\Packages\MicrosoftWindows.Client.Core_cw5n1h2txyewy\TempState\ScreenClip\{A545BA65-A1C5-499B-A56E-C239A91E4F34}.png]**

> **Conclusão:** "O **Data-Driven Testing** garante que a falha de **Segurança (`403`)** é tratada separadamente da falha de **Validação de Regra de Negócio (`400`)**, garantindo a cobertura completa."

---

## Módulo 3: Performance e Visão Estratégica

### 1. Teste de Carga (Locust)

O teste de carga simula o volume de operação para medir se o sistema é **Resistente** sob stress.

**Comando Executado:** `locust`

c:\Users\enzob\AppData\Local\Packages\MicrosoftWindows.Client.Core_cw5n1h2txyewy\TempState\ScreenClip\{67763E4B-496E-4D40-994B-255DEC2CB191}.png
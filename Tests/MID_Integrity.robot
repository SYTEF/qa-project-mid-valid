*** Settings ***
# declaração de bibliotecas
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3001
${MID_CORRETO}    MID_A
${MID_ERRADO}     MID_B
${VALOR_TRANSACAO}    100.00

*** Test Cases ***
Cenario_MID_Inconsistente_Deve_Ser_Rejeitado_Na_Captura
    [Documentation]    Testa o Quality Gate da Regra: A Captura deve falhar (403) se o MID for diferente da Autorizacao.
    
    # --- SETUP: INICIA A CONEXÃO COM O SERVIÇO ---
    Create Session    payments_api    ${BASE_URL}
    
    # --- PASSO 1: AUTORIZAR (O SETUP DE SUCESSO) ---
    Log To Console    -- PASSO 1: Autorizando com ${MID_CORRETO} --
    ${AUTH_RESPONSE}=    Fazer Autorizacao    ${MID_CORRETO}    ${VALOR_TRANSACAO}
    
    # auth_code
    ${AUTH_CODE}=        Get From Dictionary    ${AUTH_RESPONSE.json()}    auth_code
    
    Should Not Be Empty    ${AUTH_CODE}
    
    # PASSO 2: O ATAQUE ('MID Y')
    Log To Console    -- PASSO 2: Atacando com MID Invalido (${MID_ERRADO}) --
    ${CAPTURE_RESPONSE}=    Tentar Captura com MID Invalido    ${AUTH_CODE}    ${MID_ERRADO}    ${VALOR_TRANSACAO}
    
    # PASSO 3: VERIFICAR O QUALITY GATE
    
    # Verifica se o Status Code é '403 Forbidden'..."
    Should Be Equal As Strings    ${CAPTURE_RESPONSE.status_code}    403
    
    # Verifica se o erro foi pelo motivo certo
    ${ERROR_CODE}=    Get From Dictionary    ${CAPTURE_RESPONSE.json()}    error_code
    Should Be Equal As Strings    ${ERROR_CODE}    MID_MISMATCH
    
    Log To Console    SUCESSO: O sistema protegeu a integridade (MID Mismatch).

    
*** Keywords ***
Fazer Autorizacao
    [Arguments]    ${mid}    ${valor}
    # Roteiro: "Esta Keyword cria o JSON (Payload)..."
    &{body}=    Create Dictionary    merchant_id=${mid}    amount=${valor}    
    ${response}=    POST On Session    payments_api    /api/authorize    json=${body}
    Status Should Be    200    ${response}
    
    RETURN    ${response}
    
Tentar Captura com MID Invalido
    [Arguments]    ${auth_code}    ${mid}    ${valor}
    # Roteiro: "Esta Keyword cria o JSON de Captura..."
    &{body}=    Create Dictionary    auth_code=${auth_code}    merchant_id=${mid}    amount=${valor}
    
    # Roteiro: "Faz o POST para /api/capture."
    # Isso diz ao Robot: Não falhe se o status não for 200. Vou verificar o status
    ${response}=    POST On Session    payments_api    /api/capture    json=${body}    expected_status=any
    
    RETURN    ${response}

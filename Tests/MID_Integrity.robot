*** Settings ***
# Roteiro (Settings):
# "Aqui declaramos as bibliotecas..."
Library    RequestsLibrary
Library    Collections

*** Variables ***
# Roteiro (Variables):
# "Aqui centralizamos os dados de teste..."
${BASE_URL}    http://localhost:3001
${MID_CORRETO}    MID_A
${MID_ERRADO}     MID_B
${VALOR_TRANSACAO}    100.00

*** Test Cases ***
# Roteiro (Test Cases):
# "Este é o coração do projeto..."
Cenario_MID_Inconsistente_Deve_Ser_Rejeitado_Na_Captura
    [Documentation]    Testa o Quality Gate da Regra 1: A Captura deve falhar (403) se o MID for diferente da Autorizacao.
    
    # --- SETUP: INICIA A CONEXÃO COM O SERVIÇO ---
    Create Session    payments_api    ${BASE_URL}
    
    # --- PASSO 1: AUTORIZAR (O SETUP DE SUCESSO) ---
    Log To Console    -- PASSO 1: Autorizando com ${MID_CORRETO} --
    ${AUTH_RESPONSE}=    Fazer Autorizacao    ${MID_CORRETO}    ${VALOR_TRANSACAO}
    
    # Roteiro: "Aqui, capturamos o 'auth_code'..."
    # CORREÇÃO: Usando 'Get From Dictionary' (o nome correto da Keyword da Library Collections)
    ${AUTH_CODE}=        Get From Dictionary    ${AUTH_RESPONSE.json()}    auth_code
    
    Should Not Be Empty    ${AUTH_CODE}
    
    # --- PASSO 2: O ATAQUE (O 'MID Y' DO DIAGRAMA) ---
    Log To Console    -- PASSO 2: Atacando com MID Invalido (${MID_ERRADO}) --
    ${CAPTURE_RESPONSE}=    Tentar Captura com MID Invalido    ${AUTH_CODE}    ${MID_ERRADO}    ${VALOR_TRANSACAO}
    
    # --- PASSO 3: VERIFICAR O QUALITY GATE (OS ASSERTS) ---
    
    # Roteiro: "ASSERT 1: Verificamos se o Status Code é '403 Forbidden'..."
    Should Be Equal As Strings    ${CAPTURE_RESPONSE.status_code}    403
    
    # Roteiro: "ASSERT 2: Verificamos se o erro foi 'pelo motivo certo'..."
    # CORREÇÃO: Usando 'Get From Dictionary' (o nome correto da Keyword da Library Collections)
    ${ERROR_CODE}=    Get From Dictionary    ${CAPTURE_RESPONSE.json()}    error_code
    Should Be Equal As Strings    ${ERROR_CODE}    MID_MISMATCH
    
    Log To Console    SUCESSO: O sistema protegeu a integridade (MID Mismatch).

    
*** Keywords ***
# Roteiro (Keywords):
# "As Keywords são o 'Como' o teste é feito..."

Fazer Autorizacao
    [Arguments]    ${mid}    ${valor}
    # Roteiro: "Esta Keyword cria o JSON (Payload)..."
    &{body}=    Create Dictionary    merchant_id=${mid}    amount=${valor}    
    ${response}=    POST On Session    payments_api    /api/authorize    json=${body}
    Status Should Be    200    ${response}
    
    # CORREÇÃO: Voltando para a sintaxe antiga [Return] (que funciona, mas dá aviso)
    RETURN    ${response}
    
Tentar Captura com MID Invalido
    [Arguments]    ${auth_code}    ${mid}    ${valor}
    # Roteiro: "Esta Keyword cria o JSON de Captura..."
    &{body}=    Create Dictionary    auth_code=${auth_code}    merchant_id=${mid}    amount=${valor}
    
    # Roteiro: "Faz o POST para /api/capture."
    # CORREÇÃO: Adicionamos 'expected_status=any'
    # Isso diz ao Robot: "Não falhe se o status não for 200. Eu mesmo vou verificar o status logo em seguida."
    ${response}=    POST On Session    payments_api    /api/capture    json=${body}    expected_status=any
    
    RETURN    ${response}

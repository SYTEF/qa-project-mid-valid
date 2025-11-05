*** Settings ***
Library    ../data_library.py  # Mantemos a importação por organização
Library    RequestsLibrary
Library    Collections

# Define a Keyword que será executada para CADA LINHA do Test Cases abaixo.
Test Template    Cenario Generico de Autorizacao

Test Setup    Setup Data Driven Test

*** Test Cases ***
# CADA LINHA ABAIXO É CONTADA COMO UM TESTE SEPARADO. (4 TESTES NO TOTAL)
# A coluna do nome do teste é automática. Os argumentos são passados para a Keyword.

Cenario Limite Valor Minimo
    0.01    1    MID_A    200

Cenario Valor Zero Falha Negocio
    0.00    1    MID_A    400

Cenario Valor Maximo Permitido
    9999.99    1    MID_A    200

Cenario Parcelado Nao Permitido
    100.00    4    MID_A    400

*** Keywords ***
Setup Data Driven Test
    Create Session    payments_api    http://localhost:3001

# A Keyword agora recebe os 4 argumentos de dados diretamente da seção Test Cases.
Cenario Generico de Autorizacao
    [Arguments]    ${amount}    ${installments}    ${mid_id}    ${expected_status}
    
    # ${TEST NAME} é uma variável do Robot que pega o nome do Test Case atual.
    Log To Console    -- Executando Cenário: ${TEST NAME} --

    &{body}=    Create Dictionary    amount=${amount}    installments=${installments}    merchant_id=${mid_id}
    
    ${response}=    POST On Session    payments_api    /api/authorize    json=${body}    expected_status=any
    
    # Validação (o coração do teste)
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

    Log To Console    Resultado: Status ${response.status_code} validado.
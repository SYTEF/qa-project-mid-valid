# Importamos as classes essenciais do Locust.
# HttpUser simula o usuário (o POS). task define a ação, between simula o delay real.
from locust import HttpUser, task, between
import random

# Esta classe representa cada Terminal POS que estará ATIVO
# e atacando a API simultaneamente no nosso teste de carga.
class PosTerminalUser(HttpUser):
    
    # Definimos um tempo de espera entre 1 e 3 segundos.
    # Simula o tempo que um cliente real gasta digitando a senha,
    # tornando o teste muito mais realista e preciso.
    wait_time = between(1, 3) 
    
    # Aponta para o nosso ambiente Mockoon. 
    # Usamos http://localhost:3001, conforme definido no nosso README do projeto base.
    host = "http://localhost:3001" 
    
    # Usamos o MID_CORRETO (MID_A) neste teste de carga.
    # O foco aqui é medir a performance do fluxo de SUCESSO, e não testar a falha.
    MID_CORRETO = "MID_A"
    
    # Função para gerar dados únicos.
    # Em performance, precisamos de dados variáveis para simular diferentes transações
    # e prevenir problemas de Idempotência no backend.
    def generate_auth_code(self):
        return f"LOADTEST_{random.randint(10000, 99999)}"

    # @task(1) define a ação principal do nosso POS simulado.
    # Esta é a ação que será executada de forma concorrente.
    @task(1) 
    def capture_transaction(self):
        """
        Simula a Captura de Transação (POST /api/capture) sob carga.
        crítico para a escalabilidade de um POS.
        """
        
        # 1. Monta o Payload (JSON) da Captura
        payload = {
            "auth_code": self.generate_auth_code(), 
            "merchant_id": self.MID_CORRETO,
            "amount": 100.00 
        }
        
        # 2. Faz a requisição POST
        self.client.post(
            "/api/capture", 
            json=payload, 
            # Garante que as estatísticas do Locust agrupem apenas estas chamadas.
            name="Captura de Transacao" 
        )
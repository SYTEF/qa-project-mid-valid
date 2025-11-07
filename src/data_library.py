import pandas as pd
from robot.api.deco import library, keyword
from robot.libraries.BuiltIn import BuiltIn

@library(scope='GLOBAL')
class DataLibrary(object):
    
    def __init__(self):
        # necessário para usar Keywords do Robot dentro do Python
        self.builtin = BuiltIn() 
    
    @keyword
    def get_test_data(self, file_path):
        """
        [SOLUÇÃO]: Lê os dados do CSV usando o comportamento PADRÃO do Pandas.
        Ele usará a linha 1 como cabeçalho e retornará APENAS as linhas de dados.
        """
        try:
            # pd.read_csv usa a linha 1 como header por padrão
            df = pd.read_csv(file_path)
            
            # df.values.tolist() retornará as 5 linhas de dados, ignorando o header
            return df.values.tolist()
            
        except FileNotFoundError:
            self.builtin.fail(f"Erro: Arquivo de dados CSV não encontrado em {file_path}")
        except Exception as e:
            self.builtin.fail(f"Erro ao carregar dados com Pandas: {e}")

    @keyword
    def setup_data_driven_test(self):
        # Keyword de setup (só precisa existir)
        pass

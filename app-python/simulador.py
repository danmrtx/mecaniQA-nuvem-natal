import time
import random
from prometheus_client import start_http_server, Counter, Gauge

# Métricas do Prometheus
IOT_MESSAGES_RECEIVED = Counter('iot_messages_received_total', 'Total de mensagens IoT recebidas', ['tipo_sensor'])
SENSOR_TEMPERATURE = Gauge('iot_sensor_temperature_celsius', 'Temperatura atual do motor lida pelo sensor')

def simulate_iot_traffic():
    print("Iniciando simulação de tráfego IoT das oficinas...")
    while True:
        # Simulando recebimento de dados dos sensores IoT
        sensor_type = random.choice(['temperatura_motor', 'falha_eletrica'])
        
        # Incrementa o contador de mensagens recebidas
        IOT_MESSAGES_RECEIVED.labels(tipo_sensor=sensor_type).inc()
        
        if sensor_type == 'temperatura_motor':
            # Atualiza a métrica de temperatura (Gauge)
            temp = random.uniform(70.0, 110.0)
            SENSOR_TEMPERATURE.set(temp)
            print(f"Processando leitura de {sensor_type}: {temp:.2f}°C")
        else:
            print(f"Processando leitura de {sensor_type}")
            
        # Simula carga/tempo de processamento
        time.sleep(random.uniform(0.1, 1.0))

if __name__ == '__main__':
    # Expondo as métricas na porta 8000 (padrão /metrics)
    start_http_server(8000)
    print("Servidor de métricas Prometheus rodando na porta 8000...")
    
    # Inicia a simulação
    simulate_iot_traffic()

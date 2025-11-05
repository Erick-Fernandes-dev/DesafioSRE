#!/bin/bash
#
# Este script atualiza dinamicamente o inventário do Ansible com
# os IPs do Terraform antes de executar o playbook.
#
# REQUISITO: Este script precisa do 'jq' instalado.
# (sudo apt install jq)

set -e # Sai imediatamente se qualquer comando falhar

# --- Definições ---
# Caminho para o seu inventário estático (onde os IPs serão inseridos)
INVENTORY_FILE="ansible/inventory/static.ini"

# Seção do inventário para atualizar
GROUP_HEADER="[wordpress_servers]"

# Marcador final, onde o script deve parar de pular linhas (o início da próxima seção)
END_MARKER="[wordpress_servers:vars]"

# Caminho para o playbook que queremos executar
PLAYBOOK="ansible/playbooks/configurar_wordpress.yml"

# --- 1. Verificar o JQ ---
if ! command -v jq &> /dev/null
then
    echo "Erro: 'jq' não encontrado. Por favor, instale com:"
    echo "sudo apt install jq"
    exit 1
fi

# --- 2. Atualizar o Estado e Obter IPs ---
echo "1. Atualizando o estado do Terraform (terraform refresh)..."
# CORREÇÃO: Removido '2>&1' para permitir que erros (stderr) apareçam.
terraform refresh -var-file="terraform.tfvars" > /dev/null

echo "2. Buscando IPs atuais do Auto Scaling Group..."
# Obtém a lista de IPs, um por linha
# CORREÇÃO: Removido -var-file="terraform.tfvars", pois o 'output' não aceita este flag.
IP_LIST=$(terraform output -json wordpress_instance_ips | jq -r '.[]')

if [ -z "$IP_LIST" ]; then
    echo "Erro: Não foi possível obter a lista de IPs. 'terraform output' está vazio."
    exit 1
fi

echo "   IPs encontrados:"
echo "$IP_LIST"

# --- 3. Atualizar o Arquivo de Inventário ---
echo "3. Inserindo IPs em $INVENTORY_FILE..."

# Usamos 'awk' para recriar o arquivo de inventário:
# 1. Imprime linhas normalmente (printing=1)
# 2. Ao encontrar [wordpress_servers], imprime o header e os novos IPs.
# 3. Para de imprimir (printing=0) para pular IPs antigos.
# 4. Ao encontrar [wordpress_servers:vars], volta a imprimir (printing=1).
awk -v group_header="$GROUP_HEADER" \
    -v ip_list="$IP_LIST" \
    -v end_marker="$END_MARKER" \
'
BEGIN { printing=1 }

$0 ~ group_header {
    print $0;        # Imprime o header ex: [wordpress_servers]
    print ip_list;   # Imprime a lista de IPs
    printing=0;      # Para de imprimir para pular IPs antigos
    next;
}

$0 ~ end_marker {
    printing=1;      # Encontrou a próxima seção, volta a imprimir
}

{ if (printing) print }
' $INVENTORY_FILE > $INVENTORY_FILE.tmp

# Substitui o arquivo antigo pelo novo, atualizado
mv $INVENTORY_FILE.tmp $INVENTORY_FILE

echo "   Inventário atualizado com sucesso."

# --- 4. Executar o Playbook ---
echo "4. Executando o playbook Ansible..."
# Aponta o inventário para o DIRETÓRIO
ansible-playbook -i ansible/inventory/ $PLAYBOOK

echo "Script concluído."


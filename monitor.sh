#!/bin/bash
cat monitorimg.txt
# Function for IP scanner
# Função para o scanner de IPs
scan_ips() {
    # Specifies the range of IPs you want to ping
    # Especifica o intervalo de IPs que você deseja pingar
    inicio=1
    fim=254

    # File name to save IPs with "ONLINE" status
    # Nome do arquivo onde você deseja salvar os IPs com status "ONLINE"
    arquivo_lista="online_ips.txt"

    # Loop to ping a range of IP addresses
    # Loop para executar o ping em um intervalo de IPs
    for i in $(seq $inicio $fim); do
        # Execute the ping and check the result
        # Executa o ping e verifica o resultado
        if ping -c 1 -W 1 "$ip_alvo.$i" | grep "ttl" > /dev/null; then
            resultado="ONLINE"
            # Display the result on the screen with "STATUS: ONLINE"
            # Exibe o resultado na tela com "STATUS: ONLINE"
            echo "IP $ip_alvo.$i - STATUS: ONLINE"
            # Save the IP in the list file
            # Salva o IP no arquivo de lista
            echo "$ip_alvo.$i" >> "$arquivo_lista"
        else
            # Display the message "STATUS: OFFLINE" if the ping fails
            # Exibe a mensagem "STATUS: OFFLINE" se o ping falhar
            echo "IP $ip_alvo.$i - STATUS: OFFLINE"
        fi
    done
}

# Function for monitoring using tcpdump
# Função para o monitoramento usando tcpdump
monitorar_tcpdump() {
    # Check if the script is being executed as root
    # Verifica se o script está sendo executado como root
    if [ "$EUID" -ne 0 ]; then
        echo "This script needs to be executed as root (sudo)." >&2
        exit 1
    fi

    # Execute tcpdump to capture all packets destined for the target IP on the local network
    # Executa o tcpdump para capturar todos os pacotes destinados ao IP alvo na rede local
    tcpdump host "$ip_alvo"
}

# Present options to the user
# Apresenta opções ao usuário
echo "Choose an option:"
echo "1. IP Scanner"
echo "2. Monitoring using tcpdump"
read -p "Enter the desired option number: " opcao

# Execute the chosen option
# Executa a opção escolhida
case $opcao in
    1) 
        # Ask for the target IP address
        # Pedir o endereço IP alvo
        read -p "Enter the target IP address: " ip_alvo
        scan_ips 
        ;;
    2) 
        # Ask for the target IP address
        # Pedir o endereço IP alvo
        read -p "Enter the target IP address: " ip_alvo
        monitorar_tcpdump 
        ;;
    *) 
        echo "Invalid option. Exiting." 
        ;;
esac

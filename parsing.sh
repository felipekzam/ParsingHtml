#!/bin/bash

print_color() {
  local color="$1"
  shift
  echo -e "\e[${color}m$@\e[0m"
}

if [ "$1" == "" ]; then
  echo "Modo de uso: ./parsing exemplo.com.br"
else

  if ! command -v lynx &> /dev/null; then
    echo "O lynx não está instalado. Por favor, instale-o usando o seguinte comando:"
    echo "sudo apt-get install lynx  # Para Debian/Ubuntu/Mint"
    echo "sudo dnf install lynx  # Para Fedora/CentOS/RHEL"
    exit 1  
  fi

  echo "=================================================================================================="
  echo ""
  print_color "1;34" "[+] Resolvendo URLs em: $1"
  echo ""
  echo "=================================================================================================="
  echo ""
  print_color "1;32" "[+] Concluído: Salvo em $1.txt"
  echo ""
  echo "=================================================================================================="
  echo -e "Line\t\tIP\t\tADDRESS"
  echo "=================================================================================================="

  wget -q "$1"

  lynx -dump -listonly "$1" | awk '/http/{print $2}' | grep "\." | cut -d '"' -f 1 | grep -v "<l" > lista

  count=1
  while read -r url; do
    ip=$(host "$url" | awk '/has address/ {print $NF}')
    if [ -n "$ip" ]; then
      printf "%-20s\t%-30s\t%s\n" "$count" "$ip" "$url"
      ((count++))
    fi
  done < lista

  rm index.html
  rm lista
fi

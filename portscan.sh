#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  rm $OUTPUT_FILE
  exit 1
}

# Ctrl+C
trap ctrl_c INT

declare -i parameter_counter=0

function ScanPort(){
  IP=$1
  START_PORT=1
  END_PORT=65535
  OUTPUT_FILE="scan.tmp"
  
  echo -e "\n${yellowColour}[!]${grayColour} Iniciando escaneo de puertos en la ip ${redColour}$IP${endColour}\n"
  nc -nvv -w 1 -z $IP 1-65535 >> $OUTPUT_FILE 2>&1

  echo -e "${greenColour}[+] Puertos abiertos:${endColour}\n"
  cat $OUTPUT_FILE | grep " open" | awk '{print $3, $4, $5, $6}'
  rm $OUTPUT_FILE
  echo -e "\n${greenColour}[*] Escaneo completado.${endColour}\n"
}

function helpPanel()
{
  echo -e "\n${yellowColour}[i]${grayColour} Uso:\n"
  echo -e "\t${redColour}h) ${blueColour}Mostrar este panel de ayuda"
  echo -e "\t${redColour}i) ${blueColour}IP a escanear"
  echo -e "\n\t${redColour}ejemplo) ${blueColour}portscan.sh -i ${turquoiseColour}<IP>${endColour}\n"
  exit 0
}

while getopts "hi:" arg; do
  case $arg in
    h) ;;
    i) IP=$OPTARG; let parameter_counter+=1;;
  esac
done

if [[ $parameter_counter -eq 1 ]]; then
  ScanPort "$IP"
else
  helpPanel
fi


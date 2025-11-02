#!/bin/bash

# Encrypt v1.0 - RaZoR
# A powerful password encryptor and decryptor tool.


#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

#Global variables
local_dir=$(pwd)

#Functions
function ctrl_c() {
    echo -e "\n${redColor}[!] Aborting...${endColor}\n"
    exit 1
}

function helpPanel() {
    echo -e "\n${yellowColor}[+]${endColor}${grayColor} Usage: ./encrypt.sh [-parameter]${endColor}"
    echo -e "\n\t${purpleColor}-e${endColor}${grayColor} --Encrypt a password.${endColor}"
    echo -e "\n\t${purpleColor}-d${endColor}${grayColor} --Decrypt a password.${endColor}"
    echo -e "\n\t${purpleColor}-z${endColor}${grayColor} --SHA-256 Mode.${endColor}\n"
    echo -e "\n\t${purpleColor}-o${endColor}${grayColor} --Input file with passwords to encrypt/decrypt.${endColor}"
    echo -e "\n\t${purpleColor}-h${endColor}${grayColor} --Show this help panel.${endColor}\n"
    exit 1
}

function encryptPassword() {
    echo -e "\n${yellowColor}[+]${endColor}${grayColor} Encrypt Password Mode selected.${endColor}\n"
    read -p "$(echo -e ${blueColor}[?]${endColor}${grayColor} Enter the password to encrypt: ${endColor})" passwordToEncrypt
    echo -e "\n${greenColor}[+]${endColor}${grayColor} The encrypted password is: ${endColor}${turquoiseColor}$(echo -n $passwordToEncrypt | openssl enc -aes-256-cbc -a -salt -pass pass:bandit24)${endColor}\n"
}

function sha256Mode() {
    echo -e "\n${yellowColor}[+]${endColor}${grayColor} SHA-256 Mode selected.${endColor}\n"
    read -p "$(echo -e ${blueColor}[?]${endColor}${grayColor} Enter the password to encrypt: ${endColor})" passwordToEncrypt
    echo -e "\n${greenColor}[+]${endColor}${grayColor} The SHA-256 encrypted password is: ${endColor}${turquoiseColor}$(echo -n $passwordToEncrypt | sha256sum | awk '{print $1}')${endColor}\n"
}

function inputFile {
    filePath=$1
    if [ -f $filePath ]; then
        echo -e "\n${yellowColor}[+]${endColor}${grayColor} Processing file: ${endColor}${turquoiseColor}$filePath${endColor}\n"
        while IFS= read -r line; do
            if [ $counter -eq 1 ]; then
                encryptedPassword=$(echo -n $line | openssl enc -aes-256-cbc -a -salt -pass pass:bandit24)
                echo -e "${greenColor}[+]${endColor}${grayColor} Original: ${endColor}${turquoiseColor}$line${endColor} ${grayColor}=> Encrypted: ${endColor}${turquoiseColor}$encryptedPassword${endColor}"
            elif [ $counter -eq 2 ]; then
                decryptedPassword=$(echo -n $line | openssl enc -aes-256-cbc -d -a -pass pass:bandit24)
                echo -e "${greenColor}[+]${endColor}${grayColor} Encrypted: ${endColor}${turquoiseColor}$line${endColor} ${grayColor}=> Decrypted: ${endColor}${turquoiseColor}$decryptedPassword${endColor}"
            elif [ $counter -eq 3 ]; then
                sha256Password=$(echo -n $line | sha256sum | awk '{print $1}')
                echo -e "${greenColor}[+]${endColor}${grayColor} Original: ${endColor}${turquoiseColor}$line${endColor} ${grayColor}=> SHA-256: ${endColor}${turquoiseColor}$sha256Password${endColor}"
            fi
        done < "$filePath"
        echo ""
    else
        echo -e "\n${redColor}[-] Error:${endColor}${grayColor} File not found: ${endColor}${turquoiseColor}$filePath${endColor}\n"
        exit 1
    fi
}

#Indicators
declare -i counter=0;

while getopts "edzo:h" arg; do
    case $arg in
        e) encryptPassword;;
        d) decryptPassword ;;
        z) sha256Mode ;;
        o) inputFile ;;
        h) helpPanel ;;
    esac
done

if [ $counter -eq 1 ]; then
    encryptPassword
elif [ $counter -eq 2 ]; then
    decryptPassword
elif [ $counter -eq 3 ]; then
    sha256Mode
elif [ $counter -eq 4 ]; then
    inputFile "$OPTARG"; let counter+=1;; 
else
    helpPanel
fi



# CTRL + C
trap ctrl_c INT
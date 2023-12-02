#!/bin/bash

user=$(whoami)


if [[ $user = "root" ]];
then
    while IFS=":" read programa proceso;
    do
        programa[${indice}]=$programa
        proceso[${indice}]=$proceso

        comprobacion=$(whereis "${programa[$indice]}" | grep bin | wc -l)

        if [[ ${proceso[$indice]} = "status" ]] || [[ ${proceso[$indice]} = "s" ]];
        then
            if [[ $comprobacion -eq 0 ]];
            then
                echo "el ${programa[$indice]} no esta instalado"
            else
                echo "el ${programa[$indice]}  esta instalado"
            fi
        
        elif [[ ${proceso[$indice]} = "add" ]] || [[ ${proceso[$indice]} = "a" ]];
        then

            if [[ $comprobacion -eq 0 ]];
            then
                if [[ ${programa[$indice]} = "google-chrome" ]];
                then
                    wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                    sudo dpkg -i google-chrome-stable_current_amd64.deb

                elif [[ ${programa[$indice]} = "atom" ]];
                then
                    wget https://github.com/atom/atom/releases/download/v1.35.1/atom-amd64.deb
                    sudo dpkg -i atom-amd64.deb
                    sudo apt install -f atom-amd64.deb

                fi
                sudo apt install -y ${programa[$indice]}
            else
                echo " el ${programa[$indice]} ya fue instalado"
            fi
        
        elif [[ ${proceso[$indice]} = "remove" ]] || [[ ${proceso[$indice]} = "r" ]];
        then
            if [[ $comprobacion -eq 1 ]];
            then
                sudo apt remove -y  ${programa[$indice]}
                sudo apt purge -y ${programa[$indice]}
            else
                echo " el ${programa[$indice]} ya fue eliminado"
            fi
        else
            echo "No se econtro ninguna accion para ${programa[$indice]}" 
        fi
        (( indice ++ ))
    done < paquetes.txt
else
    echo "No eres root, largo de aqui"
    exit 
fi

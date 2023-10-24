#!/bin/bash
#
# About: Script for Install Firmware
# Author: liberodark
# Thanks : 
# License: GNU GPLv3

version="0.0.1"

echo "Welcome on FW Installer $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi


#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================
folder="/usr/lib/firmware/rtl_bt"


usage ()
{
     echo "usage: install.sh -i"
     echo "options:"
     echo "-i: for install firmware"
     echo "-u: for uninstall firmware"
     echo "-h: Show help"
}

# Backup Firmware
backup_fw(){
fw_list="rtl8761b_config
rtl8761b_fw
rtl8761bu_config
rtl8761bu_fw"

for fw in $fw_list
    do
        if [ ! -e "${folder}/${fw}".bin.bak ]; then
            
            mv "${folder}/${fw}.bin" "${folder}/${fw}.bin.bak"
            echo "Backup Firmware Done"
        else
            echo "Backup Exist Skip" > /dev/null 2>&1
        fi
done
}

# Restore Firmware
restore_fw(){
cp -a "${folder}/rtl8761b_config.bin.bak" "${folder}/rtl8761b_config.bin" || exit
cp -a "${folder}/rtl8761b_fw.bin.bak" "${folder}/rtl8761b_fw.bin" || exit
cp -a "${folder}/rtl8761bu_config.bin.bak" "${folder}/rtl8761bu_config.bin" || exit
cp -a "${folder}/rtl8761bu_fw.bin.bak" "${folder}/rtl8761bu_fw.bin" || exit
echo "Uninstall Firmware Done"
}

# Install Firmware
install_fw(){
cp -a ./rtl8761b_config.bin "${folder}/" || exit
cp -a ./rtl8761b_fw.bin "${folder}/" || exit
cp -a ./rtl8761bu_config.bin "${folder}/" || exit
cp -a ./rtl8761bu_fw.bin "${folder}/" || exit
echo "Install Firmware Done"
}

parse_args ()
{
    while [ $# -ne 0 ]
    do
        case "${1}" in
            -i)
                shift
                backup_fw
                install_fw
                return 0
                ;;
            -u)
                shift
                restore_fw
                return 0
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Invalid argument : ${1}" >&2
                usage >&2
                exit 1
                ;;
        esac
        shift
    done

}

parse_args "$@"
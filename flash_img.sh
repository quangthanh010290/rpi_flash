#!/bin/bash
print_usage()
{
    echo -e  "\033[0;32m===== run these commands below to flash the image to sd card =====\033[0m"
    echo -e "\033[0;33m ${0} .check_card \033[0m- check the device name of card in system \033[0m"
    echo -e "\033[0;33m ${0} .unmount \033[0m- disconnect to card\033[0m"
    echo -e "\033[0;33m ${0} .trim_img [new_img] [from_card_img] \033[0m- trim file to fix with card\033[0m"
    echo -e "\033[0;33m ${0} .check_img [original_img] [trimmed_img] \033[0m- check trimmed file with original file\033[0m"
    echo -e "\033[0;33m ${0} .copy_img [image path] [device] \033[0m-  write image to card\033[0m"
}
function check_card()
{
    lsblk -p
}

function unmount()
{
    if [ ! -z "$1" ] ; then
        echo -e "\033[0;32m ok \033[0m"
    else
        echo -e "\033[0;31m no disk information to unmount\033[0m"
    fi
}
function trim_img()
{
    # echo -e "\033[0;33m ${0} .trim_img [new_img] [from_card_img]\033[0m"
    NEW_IMG="${1}"
    CARD_IMG="${2}"
    truncate --reference ${NEW_IMG} ${CARD_IMG}

}
function check_img()
{
    # echo -e "\033[0;33m ${0} .check_img [original_img] [trimmed_img]\033[0m"
    ORI_IMG=${1}
    TRIMMED_IMG=${2}
    diff -s ${TRIMMED_IMG} ${ORI_IMG}
}
function copy_img()
{
    IMG=${1}
    DEVICE=${2}
    if [ ! -f "${IMG}" ] ; then
        echo -e "\033[0;31mimg file is not exist\033[0m"
        return 0
    fi
    dd bs=4M if=${IMG} of=${DEVICE} status=progress conv=fsync

}

case "$1" in
"")
    print_usage
;;
".check_card")
    check_card
;;
".unmount")
    unmount
;;
".trim_img")

    echo -e "\033[0;33m ${0} .trim_img [new_img] [from_card_img]\033[0m"
    new_img={}
;;
".copy_img")
    copy_img ${2} ${3}
;;
esac

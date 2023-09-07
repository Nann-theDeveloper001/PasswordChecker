#!/bin/bash
#Nann Su Htet San
#ID-10632692
#The program is written to read the password-included text files and added into the array where passwords are read line by line with implementation of "IFS"
#The user input password file is tested as the first condition using "-e" and "-s" arguements for "file existence validation" and "file being not empty validation"
#If the user input contradicts the filtering rules, error code "exit 1" is executed while success, "exit 0" will be proceeded
#The passwords included in the 'user-input' file is iterated using "for-loop" by using pattern matching keyword "=~" and extended regular expressions, 
#The password array is validated whether each item contains 10 or more characters, matches with the uppercases/lowercases and digits 
#For the filtering of certain special characters,
#the "grep" keyword is utilized since the extender regex "[[:punct:]]" consists most of special characters, contradicting to be used for assignment's goal
#As each items in the array is "echoed", it is then, being "piped" for the search of matching with certain defined characters
#The individual status codes are executed accordingly to the conditions written 
#The overall password status is coded using the "array-item-counter" keyword whereas accepted and rejected password counts are resulted from total counts

#IFS for the separation of the array into separate lines
origin_IFS=IFS
IFS=$'\n'

pwarray=()
read -p "Enter the name of the candidate password file(including ext):" pwdfile
readarray -t pwarray < $pwdfile     #read the file into the array (-t is to remove newline character)

#counter for accepted and rejected passwords
accept_count=0
reject_count=0

#colors for easy identification 
blue='\e[34m'
red='\e[31m'
green='\e[32m'
default='\e[0m'  #clear colors to none


if [ -e $pwdfile ] && [ -s $pwdfile ]; then         #condition to check whether file exists or is empty
    echo -e "${blue}PASSWORD\t\tSTATUS${default}" 
    for j in ${pwarray[@]}; do                      #for loop for iterating the items in the array
        if [ ${#j} -ge 10 ] && [[ $j =~ [[:upper:]] ]] && [[ $j =~ [[:lower:]] ]] && [[ $j =~ [[:digit:]] ]]; then        #condition whether password matches according to pre-defined rules
            if ! echo "$j" | grep -q '[!#-_$?.,:;+*=|&%~@^<>]' || echo "$j" | grep -q '[\\\/\{\}\(\)\`\ '"[""'"']'; then  #escape key backslash and splitting string with "" is implemented
                echo -e "$j\t\t${red}Rejected${default}"
                reject_count=$(($reject_count+1)) #rejected counter addition
            else 
                echo -e "$j\t\t${green}Accepted${default}"
                accept_count=$(($accept_count+1)) #accepted counter addition
            fi
        else
            echo -e "$j\t\t${red}Rejected${default}"
            reject_count=$(($reject_count+1))
        fi
    done
else
    echo "The file does not exist or is empty"
    exit 1
fi

echo -e "A total of ${blue}${#pwarray[@]}${default}  passwords have been processed  
${green}$accept_count${default} passwords accepted, ${red}$reject_count${default} passwords rejected"   #overall password status output
exit 0

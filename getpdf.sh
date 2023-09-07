#!/bin/bash
#Nann Su Htet San
#ID-10632692
#the pdf file downloading program is coded into five functions namely,
#1-> "main" where the sub functions are executed, 
#2-> the "checkArgs" function where the input command arguement is checked on conditions having "-z","none" and "other invalid options"
#3-> "downloadFiles" for the pdfs download where url link input is aske to the user and conditioned with grep whether the link contains pdf files
#the link including pdf files are saved into urls.txt and are downloaded from it using wget
#counting of pdf files with the usage of "wc","ls" and "grep" through piping and the deletion of temporary urls.txt will take place in this function
#4-> "printFileSize" func will be called for the appropriate resulting of file sizes
#the reading of file sizes is implemented with "du" as well as option "-b" for "bytes"
#"bc" is used for the calculating of MB/KB operation
#5->"fileZipped" for the zipping up of the files
#the total files are finally zipped using the "zip" keyword with options "-q" and "-r" for operating silently and zipping files recursively
#the zip   ped file is then moved to the directory under the oringial designated directory using "mv"
#the global variables are set and directory name is set up with the current date, time format using "date" keyword


#global variables for color codes, url text file, and directory name
post=/*
red="\e[31m"
blue="\e[34m"
green="\e[32m"
reset="\e[0m"
url="urls.txt"
today=$(date +"%Y_%m_%d_%H_%M_%S")
directory="pdfs_"${today}
path=$directory$post
count=0     #count flag for the zipping of files if they exist

#directory path set up with reltaive path from the bash source
dirpath=$(realpath "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname $dirpath)

function printFileSize(){
    for f in $path; do #for loop is applied for looping files throughout the designated directory
        filename=$(basename "$f") #basename of each file is retrieved
        filesize=$(du -b "$f" | awk '{ adj=$1/1024; printf "%d", adj}') #calculating of filesize in bytes
        if [ $filesize -gt 1024 ]; then             #condition to check if the filesize is greater than 1024
            filesize=$(echo "scale=2; $(($filesize))/1024" | bc )
            size="Mb"
        else
            size="Kb"
        fi
        echo -e "$filename\t\t"${blue}"|"${reset}"\t\t${filesize}$size"

    done
}

function filesZipped(){
     zip -q -r "$1.zip" "$1" #zipping of files using quiet mode -q by giving name according to the input arguement called from within "checkArgs" function
     mv "$1.zip" "$DIR_PATH/$1" #moving of the zipped file under the same designated original directory
}

function downloadFiles(){
    read -p "Enter a URL : " link   #reading of the URL from the user
    if curl -s "$link" | grep -q -E '<a[^>]*href="[^"]*pdf[^"]*"[^>]*>'; then   #fetching of matching keywords and conditioning using "curl"
        curl -s "$link" | grep -i -o -E 'https?://[^"]*pdf[^"]*' > $url         #saving of the matching-keyword-included links to the variable, url
        wget -q -P $directory -i $url                                           #downloading of the files from the saved links in the url.txt
        countpdf=$(ls -l $directory | grep "pdf" | wc -l)                       #counting of the pdf files listed in the designated unique directory

        echo -e "Downloading . . . . . . " ${green}"${countpdf}"${reset} "PDF files have been downloaded to the directory "${green}"$directory"${reset}
        echo -e ${blue}"File Name\t\t\t\tSize(Bytes)"${reset}
        printFileSize       #calling printFileSize function
        rm -r $url          #removing of temporary-used url links included text file
        count=1             #flagging of pdfs file existence in the URL
    else
        echo -e ${red}"No PDFs found at this URL - exiting.."${reset}
    fi

}

function checkArgs(){
    if [ "$1" == "-z" ]; then   #checking of arguement perimeter from user input
        downloadFiles
        if [ "$count" == 1 ]; then  #checking for existence of files in the url from the flag
            filesZipped "$directory"
            echo -e "PDFs archieved to "${green} "$directory.zip "${reset} "in the "${green}"$directory"${reset}" directory."
        fi
    elif [ "$1" == "" ]; then   #condition if the arguement perimeter is none
        downloadFiles
    else                        #condition if other invalid characters are used as input
        echo -e ${red}"Invalid arguement . . . . . Exiting"${reset}${blue}"\nUse -z as an option for zipping of files in the directory"${reset}
        exit 1
    fi
}

function main(){    #main function defined where checking of arguements from the user will be initiated
    checkArgs $1
   
}
main $1     #main function called by reading of argument field from the user
exit 0
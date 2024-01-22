#!/bin/bash 

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_banner() {
    echo "
 ███▄ ▄███▓ ██▓ ██▀███   ██▀███   ▒█████   ██▀███     ▒██   ██▒
▓██▒▀█▀ ██▒▓██▒▓██ ▒ ██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒   ▒▒ █ █ ▒░
▓██    ▓██░▒██▒▓██ ░▄█ ▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒   ░░  █   ░
▒██    ▒██ ░██░▒██▀▀█▄  ▒██▀▀█▄  ▒██   ██░▒██▀▀█▄      ░ █ █ ▒ 
▒██▒   ░██▒░██░░██▓ ▒██▒░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒   ▒██▒ ▒██▒
░ ▒░   ░  ░░▓  ░ ▒▓ ░▒▓░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░   ▒▒ ░ ░▓ ░
░  ░      ░ ▒ ░  ░▒ ░ ▒░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░   ░░   ░▒ ░
░      ░    ▒ ░  ░░   ░   ░░   ░ ░ ░ ░ ▒    ░░   ░     ░    ░  
       ░    ░     ░        ░         ░ ░     ░         ░    ░  made by @kyotozx
                                                               
"
echo "
Mirror X is a simple script that can clone a website and return with what the user wants.
"
}

if ! command_exists wget || ! command_exists grep; then
echo "Mirror X error: Please make sure that wget and grep are installed."
exit 1
fi

if [ -z "$1" ]; then
print_banner
echo "
Usage: ./mirrorx.sh <URL>"
exit 1 
fi 

url="$1"

print_banner
echo -n "Do you want to dowload images? (y/n): "
read dowload_images

if [ "$downlaod_images" == "y" ]; then 
wget -mk -e robots=off "$url"
else
wget -m -e robots=off "$url"
fi

wget -m "$url" 

if [ $? -ne 0 ]; then
echo "Error: wget failed. Check the url."
exit 1
fi
 
read -p "Enter the file types to search for (e.g. .js .php .txt .json .py .css): " grep_string
grep -r --include="*$grep_string" .
echo $grep_string

echo -n "Do you want to remove the dowloaded files? (y/n): "
read remove_files

if [ "$remove_files" == "y" ]; then 
rm -rf "$url"
echo "Downloaded files removed."
fi

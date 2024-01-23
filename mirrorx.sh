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

if [ -z "$1" ]; then
    print_banner
    echo "
    Usage: ./mirrorx.sh <URL>"
    exit 1 
fi 


if [ -z "$1" ]; then
  echo "Usage: ./mirrorx.sh <URL>"
  exit 1
fi

url="$1"
if [[ ! $url =~ ^https?:// ]]; then
  echo "Please enter a valid URL (starting with http:// or https://)"
  exit 1
fi

print_banner
wget -m -e robots=off "$url"


grep_string=$(read -p "Enter the file types to search for (e.g., .js .php .txt .json .py .css): ")


files=$(find . -name "*.$grep_string" -type f)


if [ -z "$files" ]; then
  echo "No files found with the specified extension."
else
  for file in $files; do
    echo "$file"
  done
fi


while true; do
  read -p "Do you want to delete the downloaded files (y/n)? " remove_files
  if [ "$remove_files" == "y" ]; then
   
    filename=$(basename "$url")

    if [[ -w "$filename" ]]; then
      rm -rf "$filename"
      echo "File $filename deleted."
    else
      echo "You do not have permission to delete the file $filename."
    fi
    break
  elif [ "$remove_files" == "n" ]; then
    read -p "Do you want to create a compressed archive of the downloaded files (y/n)? " create_archive
    if [ "$create_archive" == "y" ]; then
    
      filename=$(basename "$url")
    
      zip -r "$filename.zip" "$filename"
      echo "Archive $filename.zip created."
      break
    else
      break
    fi
  else
    echo "Invalid input. Please enter y or n."
  fi
done

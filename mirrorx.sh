#!/bin/bash

# Note: THIS IS A EXPERIMENTAL SCRIPT! DID IT JUST TO PRACTICE! Bugs or whatever are expected.

# Creds: https://github.com/kyotozx
# My socials: https://ayo.so/kyotozx
# Discord: kyotozx

# Requirements: wget. Use <sudo apt install wget>.

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
       ░    ░     ░        ░         ░ ░     ░         ░    ░  Mirror X v1.0, made by @kyotozx.
                                                               
"
    echo "
Mirror X is a simple script that can clone a website and return whatever the user wants.
"
}

usage() {
    echo "
 ███▄ ▄███▓ ██▓ ██▀███   ██▀███   ▒█████   ██▀███     ▒██   ██▒
▓██▒▀█▀ ██▒▓██▒▓██ ▒ ██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒   ▒▒ █ █ ▒░
▓██    ▓██░▒██▒▓██ ░▄█ ▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒   ░░  █   ░
▒██    ▒██ ░██░▒██▀▀█▄  ▒██▀▀█▄  ▒██   ██░▒██▀▀█▄      ░ █ █ ▒ 
▒██▒   ░██▒░██░░██▓ ▒██▒░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒   ▒██▒ ▒██▒
░ ▒░   ░  ░░▓  ░ ▒▓ ░▒▓░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░   ▒▒ ░ ░▓ ░
░  ░      ░ ▒ ░  ░▒ ░ ▒░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░   ░░   ░▒ ░
░      ░    ▒ ░  ░░   ░   ░░   ░ ░ ░ ░ ▒    ░░   ░     ░    ░  
       ░    ░     ░        ░         ░ ░     ░         ░    ░  Mirror X v1.0, made by @kyotozx.
                                                               
"
    echo "
Mirror X is a simple script that can clone a website and return whatever the user wants."
    echo "
Usage: $0 <URL> [options]"
    echo "
Options:"
    echo "  -h, --help | Display this help message."
    echo "  -f, --file-types | Specify the file types to download."
    echo "  -e, --exclude-file-type | Specify the file types to exclude from the download."
    echo "  -s, --search-string | Specify the search string to look for in the files."
    echo "  -v, --version | Display the version of the script."
}

version() {
    echo "Mirror X v1.0"
}

main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -f|--file-types)
                file_types="$2"
                shift 2
                ;;
            -e|--exclude-file-types)
                exclude_file_types="$2"
                shift 2
                ;;
            -s|--search-string)
                search_string="$2"
                shift 2
                ;;
            -v|--version)
                version
                exit 0
                ;;
            *)
                url="$1"
                shift
                ;;
        esac
    done

    # Check if the URL is valid
    if [[ ! $url =~ ^https?:// ]]; then
        echo "Error: Invalid URL! | Use -h or --help to see the usage."
        exit 1
    fi

    # Print the banner
    print_banner

    # Download the website
    wget -m -e robots=off --no-check-certificate "$url"

    # Find the files with the specified file types
    if [ -n "$file_types" ]; then
        files=$(find . -name "*.$file_types" -type f)
    else
        files=$(find . -type f)
    fi

    # Exclude the files with the specified file types
    if [ -n "$exclude_file_types" ]; then
        for exclude_file_type in $exclude_file_types; do
            files=$(echo "$files" | grep -v ".$exclude_file_type$")
        done
    fi

    # Get the directory where the script is located
    script_dir=$(dirname "$0")

    # Find all the files that were downloaded by the script
    downloaded_files=$(find "$script_dir" -type f -newer "$script_dir/$0")

    # Search for the specified string in the downloaded files
    if [ -n "$search_string" ]; then
      files=$(grep -ril "$search_string" $downloaded_files)
    else
      files=$downloaded_files
    fi

    # Print the files
    if [ -z "$files" ]; then
        echo "No files found."
    else
        echo "Files found:"
        for file in $files; do
            echo "$file"
        done
    fi

    # Ask the user if they want to delete the downloaded files
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
            # Ask the user if they want to create a compressed archive of the downloaded files
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
}

main "$@"

#!/bin/bash

# Mirror X - Website Cloning Utility
# Experimental script for practice.
# Made by @kyotozx (https://github.com/kyotozx)
# Version: 1.1

# Requirements: wget, zip

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_banner() {
    echo -e "\e[1;36m"
    echo "╔════════════════════════════════════════════╗"
    echo "║ • ▌ ▄ ·. ▪  ▄▄▄  ▄▄▄        ▄▄▄  ▐▄• ▄     ║"
    echo "║ ·██ ▐███▪██ ▀▄ █·▀▄ █·▪     ▀▄ █· █▌█▌▪    ║"
    echo "║ ▐█ ▌▐▌▐█·▐█·▐▀▀▄ ▐▀▀▄  ▄█▀▄ ▐▀▀▄  ·██·     ║"
    echo "║ ██ ██▌▐█▌▐█▌▐█•█▌▐█•█▌▐█▌.▐▌▐█•█▌▪▐█·█▌    ║"
    echo "║ ▀▀  █▪▀▀▀▀▀▀.▀  ▀.▀  ▀ ▀█▄▀▪.▀  ▀•▀▀ ▀▀    ║"
    echo "║                                            ║"
    echo "║     Mirror X - Website Clone Utility       ║"
    echo "║     github.com/kyotozx     |    v1.0       ║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "\e[0m"
    echo "Mirror X is a simple script that clones a website and returns files that match user criteria"
}

usage() {
    print_banner
    echo -e "\e[1;35m╔═════════════════════════════════════════════════════════════════╗\e[0m"
    echo -e "\e[1;35m║                         Usage: $0 <URL> [options]                   ║\e[0m"
    echo -e "\e[1;35m╚═════════════════════════════════════════════════════════════════╝\e[0m"
    echo ""
    echo "Options:"
    echo "  -h, --help                Display this help message."
    echo "  -f, --file-types          Comma-separated file extensions to include."
    echo "  -e, --exclude-file-types  Comma-separated extensions to exclude."
    echo "  -s, --search-string       Search string in the downloaded files."
    echo "  -v, --version             Display script version."
    echo "  -r, --recursive           Enable recursive download with depth."
    echo "  -l, --limit-rate          Limit download speed (e.g., 100k)."
    echo "  -a, --auth                Provide authentication in format user:password."
    echo "  -o, --output-dir          Directory to save the downloaded site."
}

version() {
    print_banner
    echo "Mirror X v1.1"
}

check_requirements() {
    for cmd in wget zip; do
        if ! command_exists $cmd; then
            echo "Error: '$cmd' is not installed. Install it with 'sudo apt install $cmd'."
            exit 1
        fi
    done
}

download_site() {
    local url="$1"
    local auth="$2"
    local limit_rate="$3"
    local recursive="$4"
    local output_dir="$5"

    mkdir -p "$output_dir"
    cd "$output_dir" || exit 1

    local wget_command=(wget -m -e robots=off --no-check-certificate)

    if [ -n "$auth" ]; then
        IFS=':' read -r auth_user auth_pass <<< "$auth"
        wget_command+=(--user="$auth_user" --password="$auth_pass")
    fi

    if [ -n "$limit_rate" ]; then
        wget_command+=(--limit-rate="$limit_rate")
    fi

    if [ -n "$recursive" ]; then
        wget_command+=(-r -l "$recursive")
    fi

    wget_command+=("$url")
    "${wget_command[@]}"
    cd - > /dev/null
}

main() {
    check_requirements

    local file_types=""
    local exclude_file_types=""
    local search_string=""
    local recursive_depth=""
    local limit_rate=""
    local auth=""
    local url=""
    local output_dir="mirrorx_download"

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage; exit 0 ;;
            -f|--file-types)
                file_types="$2"; shift 2 ;;
            -e|--exclude-file-types)
                exclude_file_types="$2"; shift 2 ;;
            -s|--search-string)
                search_string="$2"; shift 2 ;;
            -v|--version)
                version; exit 0 ;;
            -r|--recursive)
                recursive_depth="$2"; shift 2 ;;
            -l|--limit-rate)
                limit_rate="$2"; shift 2 ;;
            -a|--auth)
                auth="$2"; shift 2 ;;
            -o|--output-dir)
                output_dir="$2"; shift 2 ;;
            *)
                url="$1"; shift ;;
        esac
    done

    if [[ ! $url =~ ^https?:// ]]; then
        echo "Error: Invalid URL! Use -h or --help for usage."
        exit 1
    fi

    print_banner
    download_site "$url" "$auth" "$limit_rate" "$recursive_depth" "$output_dir"

    cd "$output_dir" || exit 1

    local files=()
    if [ -n "$file_types" ]; then
        IFS=',' read -ra types <<< "$file_types"
        for ext in "${types[@]}"; do
            files+=( $(find . -type f -name "*.$ext") )
        done
    else
        files=( $(find . -type f) )
    fi

    if [ -n "$exclude_file_types" ]; then
        IFS=',' read -ra ex_types <<< "$exclude_file_types"
        for ext in "${ex_types[@]}"; do
            files=( $(printf "%s\n" "${files[@]}" | grep -v ".$ext$") )
        done
    fi

    if [ -n "$search_string" ]; then
        files=( $(grep -ril "$search_string" .) )
    fi

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found."
    else
        echo "Files found:"
        for f in "${files[@]}"; do
            echo "$f"
        done
    fi

    while true; do
        read -p "Do you want to delete the downloaded files (y/n)? " remove_files
        case "$remove_files" in
            y|Y)
                rm -rf "$output_dir"
                echo "Directory '$output_dir' deleted."
                break ;;
            n|N)
                read -p "Do you want to create a compressed archive of the files (y/n)? " create_archive
                if [[ "$create_archive" == "y" || "$create_archive" == "Y" ]]; then
                    zip -r "$output_dir.zip" "$output_dir"
                    echo "Archive '$output_dir.zip' created."
                fi
                break ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

main "$@"

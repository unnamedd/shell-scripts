#!/bin/bash

function download_all() {
    parameters=("$@")
    folder=${parameters[0]}
    
    unset parameters[0]
    totalPages=${parameters[1]}
    
    cd $folder
    
    echo "Downloading database dump (all pages)..."
    
    for (( index=0; index<$totalPages; index++ )); do
        currentPage=$(( $index+1 ))
        percentage=$(echo "scale=0; ($currentPage * 100) / $totalPages" | bc -l)
        filename="Page$currentPage.gz"
        
        echo -ne "[$currentPage/$totalPages - Progress $percentage%] - Filename: $filename\r"
        download_dump_page $index $filename
    done
}

function download_pages() {
    pages=("$@")
    folder=${pages[0]}
    
    unset pages[0]
    totalPages=${#pages[@]}

    cd $folder

    echo "Downloading database dump (specific pages)..."

    for (( index=0; index<$totalPages; index++ )); do
        currentPage=$(( $index+1 ))
        page=${pages[$currentPage]}
        percentage=$(echo "scale=0; ($currentPage * 100) / $totalPages" | bc -l)
        filename="Page$page.gz"

        echo -ne "[$currentPage/$totalPages - Progress $percentage%] - Filename: $filename\r"
        download_dump_page $index $filename
    done     
}

function download_dump_page() {
    index=$1
    filename=$2
    
    curl "https://personalurl.com/texts?page=$index" \
        -H 'Accept: application/json' \
        -H 'Content-Type: text/html' \
        -H 'Accept-Encoding: gzip' \
        -H "X-Page: $index" \
        --output $filename \
        --silent
    
    if [ -f $filename ]; then
        gzip -d $filename
    fi
}

function download() {
    # Hide cursor
    tput civis 
    
    local parameters=("$@")
    local folder=${parameters[0]}
    unset parameters[0]
    
    command=${parameters[1]}
    unset parameters[1]
    
    if [ "$command" == "--pages" ]; then
        download_pages $folder ${pages[@]}
        
    elif [ "$command" == "--numberOfPages" ]; then
        local totalPages=${parameters[2]}
        download_all $folder $totalPages
        
    else
        echo "Invalid parameter"
        exit
    fi
    
    # Set cursor back
    tput cnorm 
    
    echo -ne "\n"
    echo "Done!"
}

function main() {
    local pages=(258 273 287)
    local folder="/Users/yourusername/foldername"

    download $folder "--pages" "${pages[@]}"
    #download $folder "--numberOfPages" 294
}

main

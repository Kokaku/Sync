#!/bin/zsh

command="md5sum"
args=""
folders=("./")

while [ -n "$folders" ]; do
    folder=$folders[1]
    hash=
    folders=("${folders[@]:1}")
    echo "folder $folder"
    #search for files finishing by our extention in our current directory
    for file in "$folder"*; do
        #do only if it is a file
        if [ -f "$file" ]; then
            #do only if we can read and write else throw a warning
            if [ -r "$file" ]; then
                echo "$command $file"
                hash=`$command $args "$file"`
                hash=`echo "$hash"|cut -d' ' -f1`
                echo "$hash"
            else
                if [ $# -eq 1 ]; then
                    echo "Permission denied: $file"
                fi
            fi
        elif [ -d "$file" ]; then
            folders+=("$file"/)
        fi
    done
done
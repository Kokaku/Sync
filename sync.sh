#!/bin/sh

#parse parameters
while [[ $# > 0 ]]; do
    if [ "$1" = "-v" ]; then
        verbose=1
    elif [ "$1" = "-d" ]; then
        shift
        folder="$1"/
    elif [ "$1" = "-h" ]; then
        shift
        command="$1"
    elif [ "$1" = "help" ]; then
        echo "-v: Activate verbose mode\n-d: Followed by directory's path to syncronise\n-h: Followed by hash command to compare files"
    fi
    shift
done

#set default parameters to unset params
if [ -z "$command" ]; then
    command="md5sum"
fi
if [ -z "$folder" ]; then
    folder="./"
fi

#browse file in current folder
for file in "$folder"* "$folder"**/* ; do
    #if it is a file sync. If it is a folder add in the to process folder list
    if [ -f "$file" ]; then
        #if we cannot read the file print a warning
        if [ -r "$file" ]; then
            #print filename of the currently processed file
            if [ "$verbose" = "1" ]; then
                echo "$file"
            fi

            #compute hash
            cmd="$command \"$file\""
            eval hashValue=\$\($cmd\)
            hashValue=`echo "$hashValue"|cut -d' ' -f1`
            #print computed hash
            if [ "$verbose" = "1" ]; then
                echo "$hashValue"
            fi
        else
            if [ "$verbose" = "1" ]; then
                echo "Permission denied: $file"
            fi
        fi
    fi
done

#!/bin/sh

#parse parameters
while [[ $# > 0 ]]; do
    if [ "$1" = "-v" ]; then
        verbose=1
    elif [ "$1" = "-d" ]; then
        shift
        if [ ${1: -1} = "/" ]; then
            folder=`echo "$1" | sed '$s/.$//'`
        else
            folder="$1"
        fi
    elif [ "$1" = "-h" ]; then
        shift
        command="$1"
    elif [ "$1" = "-p" ]; then
        shift
        if [ "$1" = "OSX" ]; then
            command="md5 -q"
            timeCmd="stat -f %m"
        fi
    elif [ "$1" = "help" ]; then
        echo "-v: Activate verbose mode"
        echo "-d: Followed by directory's path to syncronise"
        echo "-h: Followed by hash command to compare files"
        echo "-p: Followed by a preset name (to preset commands for a particular env.) ex: OSX"
        exit 0
    fi
    shift
done

#set default parameters to unset params
if [ -z "$command" ]; then
    command="md5sum"
fi
if [ -z "$folder" ]; then
    folder="."
fi
if [ -z "$timeCmd" ]; then
    timeCmd="stat -c %Y"
fi

if [ -e oldHashes ]; then
    `rm -r oldHashes`
fi
if [ -e hashes ]; then
    `mv hashes oldHashes`
fi
`touch hashes`

IFS=$'\n'
#browse file in selected folder
for file in `find "$folder" -type f` ; do
    #if we cannot read the file print a warning
    if [ -r "$file" ]; then
        #print filename of processing file
        if [ "$verbose" = "1" ]; then
            echo "$file"
        fi

        #retrieve file date
        cmd="$timeCmd \"$file\""
        eval time=\$\($cmd\)
        #print file date
        if [ "$verbose" = "1" ]; then
            echo "$time"
        fi

        #compute hash
        cmd="$command \"$file\""
        eval hashValue=\$\($cmd\)
        hashValue=`echo "$hashValue"|cut -d' ' -f1`
        #print computed hash
        if [ "$verbose" = "1" ]; then
            echo "$hashValue"
        fi

        #write in hashes file
        echo "$file" >> hashes
        echo "$time" >> hashes
        echo "$hashValue" >> hashes
    else
        if [ "$verbose" = "1" ]; then
            echo "Permission denied: $file"
        fi
    fi
done

if [ -e oldHashes ]; then
    `rm -r oldHashes`
fi
#!/bin/bash
baseMangaDir=$(pwd)
for mangaFolder in */ ; do
    echo $mangaFolder
    cd "$mangaFolder"
    #Make sure that all extensions are lower case
    find . -name '*.*' -type f -exec bash -c 'base=${0%.*} ext=${0##*.} a=$base.${ext,,}; [ "$a" != "$0" ] && mv -- "$0" "$a"' {} \;
    python3 /home/mokuro/.local/bin/mokuro --disable_confirmation --parent_dir . 2>&1| tee -a log.txt
    grep -Fxq "$ERROR" log.txt
    if [ $? -eq 0 ]; then
        mkdir $mangaFolder
        for htmlFile in *.html ; do
            volumeName=$(basename "$htmlFile" .html)
            echo "$volumeName"
            7z a "$volumeName.zip" "$htmlFile" "$volumeName" -mx=9 2>> pzerror.txt 1> /dev/null
            mv "$volumeName.zip" "$mangaFolder/$volumeName.cbz"
            #TODO: Add check to makesure html file is in the .cbz
        done
    else
        echo "Failed in $mangaFolder" >> $baseMangaDir/error.txt
    fi
    cd "$baseMangaDir"
done

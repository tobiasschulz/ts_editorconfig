#!/bin/bash

function find_editorconfigs() {
    find ~/leuchtraketen/ -name .editorconfig \
        | grep -v /build/ \
        | grep -v /vendor/ \
        | grep -v /node_modules/ \
        | grep -v /bin/ \
        | grep -v /obj/ \
        | grep -v /siemens/ \
        | cat
}

find_editorconfigs \
    | while read a
do
    md5sum $a
    MD5=$(md5sum $a | cut -d" " -f1)
    cat $a > $MD5
done | sort

find ~/leuchtraketen/ -name nukebuild | while read a
do
    cat nukebuild.editorconfig > "$a"/.editorconfig
    (cd "$a" && (
        git commit -m ".editorconfig" "$a"/.editorconfig
        git push
    ))
done

find_editorconfigs \
    | grep -v /nukebuild/ \
    | while read a
do
    cat ts.editorconfig > "$a"
    (cd $(dirname "$a") && (
        git commit -m ".editorconfig" "$a"
        git push
    ))
done


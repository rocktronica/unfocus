#!/bin/bash

{

hosts="/etc/hosts"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
backup_hosts="$dir/backup/$(date "+%y%m%d%H%M%S")_hosts.txt"
list="$dir/sites.txt"

comment_tag="# UNFOCUS"

function help() {
    echo "\
A tool to help cut down on time spent on Twitter, reading the news, etc.

Usage:
$0 -h        # shows help, exits
$0 list      # list blocked sites
$0 edit      # opens default editor to edit sites list"
}

function bonk() {
    printf "\a"
}

function remove_blocks() {
    printf "Removing all blocks..."
    sed -i '' "/$comment_tag/d" "$hosts"
    echo "Done"
    echo
}

function backup() {
    printf "Backing up current $hosts to $backup_hosts... "
    cp "$hosts" "$backup_hosts"
    echo "Done"
    echo
}

function get_list() {
    while read -r line; do
        first_char=$(echo $line | head -c 1)

        if (
            [ ! -z "$line" ] && # line isn't empty
            [ "$first_char" != "#" ] # and isn't a comment
        ); then
            echo "$line"
        fi
    done < "$list"
}

function block() {
    for site in $(get_list); do
        echo "Blocking $site"
        echo "127.0.0.1    $site    $comment_tag" >> "$hosts"
    done

    echo
}

function wait() {
    minutes=5

    while [ $minutes -gt 0 ]; do
        echo "$minutes minutes left"
        ((minutes=minutes-1))
        sleep 60
    done

    echo
}

function edit() {
    if [ -z "$EDITOR" ]; then
        open  "$list"
    else
        $EDITOR "$list"
    fi
}

command="$1"
if [ -z "$command" ]; then
    backup
    remove_blocks
    wait
    block
    bonk
elif [ "$command" == '-h' ]; then
    help
elif [ "$command" == 'list' ]; then
    cat "$list"
elif [ "$command" == 'edit' ]; then
    edit
else
    echo "Unkown command: $command"
fi

}

#!/bin/bash

{

hosts="/etc/hosts"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
backup_hosts="$dir/backup/$(date "+%y%m%d%H%M%S")_hosts.txt"

list="$dir/sites_example.txt"
if test -f "$dir/sites.txt"; then
    list="$dir/sites.txt"
fi

comment_tag="# UNFOCUS"
default_minutes="5"

function help() {
    echo "\
A tool to help cut down on time spent on Twitter, reading the news, etc.

Usage:
$0           # allow $default_minutes of unfocus time
$0 15        # ^ but 15 minutes, etc
$0 -h        # shows help, exits
$0 -ls       # list sites to be blocked
$0 -r        # refreshes blocked sites immediately
$0 -e        # edit sites list with default editor"
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
    minutes="$1"

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

number_pattern='^[0-9]+$'
command="$1"

if [ -z "$command" ] || [[ "$1" =~ $number_pattern ]]; then
    backup
    remove_blocks
    wait "${1:-$default_minutes}"
    block
    bonk
elif [ "$command" == '-h' ]; then
    help
elif [ "$command" == '-ls' ]; then
    get_list
elif [ "$command" == '-r' ]; then
    backup
    remove_blocks
    block
elif [ "$command" == '-e' ]; then
    edit
else
    echo "Unkown command: $command"
fi

}

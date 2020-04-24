#!/bin/bash

{

HOSTS="/etc/hosts"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACKUP_HOSTS="$DIR/backup/$(date "+%y%m%d%H%M%S")_hosts.txt"

COMMENT_TAG="# UNFOCUS"

LIST="$DIR/sites.txt"

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
    sed -i '' "/$COMMENT_TAG/d" "$HOSTS"
    echo "Done"
    echo
}

function backup() {
    printf "Backing up current $HOSTS to $BACKUP_HOSTS... "
    cp "$HOSTS" "$BACKUP_HOSTS"
    echo "Done"
    echo
}

function block() {
    while read -r SITE; do
        echo "Blocking $SITE"
        echo "127.0.0.1    $SITE    $COMMENT_TAG" >> "$HOSTS"
    done < "$LIST"
    echo
}

function wait() {
    MINUTES=5

    while [ $MINUTES -gt 0 ]; do
        echo "$MINUTES minutes left"
        ((MINUTES=MINUTES-1))
        sleep 60
    done

    echo
}

function edit() {
    if [ -z "$EDITOR" ]; then
        open  "$LIST"
    else
        $EDITOR "$LIST"
    fi
}

COMMAND="$1"
if [ -z "$COMMAND" ]; then
    backup
    remove_blocks
    wait
    block
    bonk
elif [ "$COMMAND" == '-h' ]; then
    help
elif [ "$COMMAND" == 'list' ]; then
    cat "$LIST"
elif [ "$COMMAND" == 'edit' ]; then
    edit
else
    echo "Unkown command: $COMMAND"
fi

}

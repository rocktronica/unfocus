#!/bin/bash

{

HOSTS="/etc/hosts"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACKUP_HOSTS="$DIR/backup/$(date "+%y%m%d%H%M%S")_hosts.txt"

COMMENT_TAG="# UNFOCUS"

function help() {
    echo "\
Take a lil break. It's okay!

Usage:
$0 -h"
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
    done < sites.txt
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

if [ "$1" == '-h' ]; then
    help
    exit
fi

backup
remove_blocks
wait
block
bonk

}

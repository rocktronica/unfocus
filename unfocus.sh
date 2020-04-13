#!/bin/bash

{

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HOSTS="/etc/hosts"

function help() {
    echo "\
Take a lil break. It's okay!

Usage:
$0 -h"
}

BACKUP_PATH="$DIR/backup/$(date "+%y%m%d%H%M%S")_hosts.txt"

function bonk() {
    printf "\a"
}

function backup() {
    printf "Backing up current $HOSTS to $BACKUP_PATH... "
    cp "$HOSTS" "$BACKUP_PATH"
    echo "Done"

    echo "$(ls backup | wc -l | xargs) backups total"

    # TODO: cleanup after N files
}

function restore() {
    printf "Restoring $HOSTS from $BACKUP_PATH... "
    cp "$BACKUP_PATH" "$HOSTS"
    echo "Done"
}

function wait() {
    MINUTES=5

    while [ $MINUTES -gt 0 ]; do
        echo "$MINUTES minutes left"
        ((MINUTES=MINUTES-1))
        sleep 60
    done
}

if [ "$1" == '-h' ]; then
    help
    exit
fi

backup

# block sites
while read -r SITE; do
    echo "Blocking $SITE"
    echo "127.0.0.1    $SITE    #unfocus" >> "$HOSTS"
done < sites.txt
echo

wait

bonk

restore

}

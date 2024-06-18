#! /usr/bin/env bash

# ZWALL
# A minimal utility for managing wallpapers with hyprpaper
# more backends planned
# usage:
#   zwall <mode> ...Params

CACHE_FILE=$HOME/.zwall_cache
# CURRENT_FILE_PATH_STORE=$HOME/.zwall_info

# inline
alias load="hyprctl hyprpaper load"
alias set="hyprctl hyprpaper wallpaper"

# precheck
precheck() {
    if ! command -v hyprpaper &> /dev/null; then
        echo "Please install hyprpaper"
        exit
    fi
}

# zwall random <path/to/directory>
randomize() {
    NEXT=$(find $1 -type f | shuf -n 1)
    if echo $NEXT | sed '/^.*\(png\|jpg\)$/!{q1}' &> /dev/null; then
        apply $NEXT
    else
        randomize $1
    fi
}

# zwall apply <path>
apply() {
    hyprctl hyprpaper unload $CACHE_FILE
    cp $1 $CACHE_FILE &> /dev/null
    
    hyprctl hyprpaper preload $CACHE_FILE
    hyprctl hyprpaper wallpaper ",${CACHE_FILE}"
}

# zwall unload_all
unload_all() {
    echo "Not implemented"
}

# zwall restore
restore() {
    apply $CACHE_FILE
}

#zwall restart
restart() {
    pkill hyprpaper
    hyprpaper & disown
    sleep 0.5
    restore
}

show_help() {
    echo "Help Text"
}

# main

# check if it command exsists
precheck

# start if not alive
if ! pgrep -x hyprpaper &> /dev/null; then
    hyprpaper & disown
    sleep 0.5
fi

case $1 in
    restore)
        restore
        ;;
    unload_all)
        unload_all
        ;;
    apply)
        apply $2
        ;;
    random)
        randomize $2
        ;;
    restart)
        restart
        ;;
    *)
        show_help
        ;;
esac

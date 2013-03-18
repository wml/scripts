#!/bin/bash

function _pacman() {
    RESULT='pacman -S '

    which pacman >/dev/null 2>&1
    if [ 0 -ne $? ]; then
        RESULT='yum install '
        which yum >/dev/null 2>&1
        if [ 0 -ne $? ]; then
            RESULT='apt-get install '
            which apt-get >/dev/null 2>&1
            if [ 0 -ne $? ]; then
                echo 'ERROR: unable to determine package manager ' \
                    '(pacman, yum, apt-get)' >&2
                exit 187
            fi
        fi
    fi

    echo "sudo $RESULT"
}

function _user() {
    RESULT="$USER"

    if [ -z "$RESULT" ]; then
        RESULT="$USERNAME"
    fi

    if [ -z "$RESULT" ]; then
        RESULT=`whoami`
    fi

    echo $RESULT
}

function _bs_packages() {
    PACMAN=`_pacman`
    $PACMAN emacs w3m
}

function _bs_scripts() {
    USR=`_user`
    SCRIPT_DIR="/tmp/will-env/$USR"

    rm -rf $SCRIPT_DIR
    mkdir -p $SCRIPT_DIR

    CAPS="$SCRIPT_DIR/caps"
    curl https://raw.github.com/wml/scripts/master/caps > $CAPS
    chmod +x $CAPS

    ENTER="$SCRIPT_DIR/enter"
    curl https://raw.github.com/wml/scripts/master/enter > $ENTER
    chmod +x $ENTER

    ALIASES="$SCRIPT_DIR/.bash_aliases"
    curl https://raw.github.com/wml/dotfiles/master/.bash_aliases > $ALIASES
    . $ALIASES

    export PATH=$SCRIPT_DIR:$PATH
}

function _bs_config() {
    caps >/dev/null 2>&1
    enter >/dev/null 2>&1
    export PS1='\[\033[32m\][\h]\[\033[0m\] \u@\W$ '
}

_bs_packages
_bs_scripts
_bs_config

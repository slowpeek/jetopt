# -*- mode: sh; sh-shell: bash; -*-
# shellcheck shell=bash

# MIT license (c) 2021-2022 https://github.com/slowpeek
# Homepage: https://github.com/slowpeek/jetopt

jetopt () {
    local arg type mode='' short='' long=''

    while (( $# )); do
        arg=$1

        case $arg in
            -*)
                # Break on any literal option or '--'
                break ;;

            ,*)
                # Scanning mode.
                [[ $arg == ,[+-] ]] && mode=${arg:1} ;;

            *)
                # Option type.
                type=${arg##*[!:]}
                arg=${arg%"$type"}

                # Short option, if present.
                [[ $arg == .* ]] || short+=${arg::1}$type
                arg=${arg:1}

                # Long option, if present.
                [[ -z $arg ]] || long+=,$arg$type
        esac

        shift
    done

    getopt -o "$mode$short" -l "${long:1}" "$@"
}

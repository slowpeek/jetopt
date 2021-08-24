# -*- mode: sh; sh-shell: bash; -*-
# shellcheck shell=bash

# MIT license (c) 2021 https://github.com/slowpeek
# Homepage: https://github.com/slowpeek/jetopt

jetopt () {
    local s type mode='' short='' long=''

    while (($#)); do
        # Break on any literal option or '--'
        [[ ! $1 == -* ]] || break

        s=$1
        shift

        # Scanning mode.
        if [[ $s == ,* ]]; then
            [[ ! $s == ,[+-] ]] || mode=${s:1}
            continue
        fi

        # Option type.
        type=''
        if [[ $s == *: ]]; then
            [[ $s == *:: ]] && type=:: || type=:
            s=${s%$type}
        fi

        # Short option, if present.
        [[ $s == .* ]] || short+=${s::1}$type

        # Long option, if present.
        test -z "${s:1}" || long+=,$_$type
    done

    getopt -o "$mode$short" -l "${long:1}" "$@"
}

#!/usr/bin/env bash

# MIT license (c) 2021-2022 https://github.com/slowpeek
# Homepage: https://github.com/slowpeek/jetopt

jetopt () {
    # shellcheck disable=SC2034
    local -r JETOPT_VERSION=0.1
    # --

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

[[ ${BASH_SOURCE[0]} == "$0" ]] || return

version() {
    local line

    while read -r line; do
        if [[ $line =~ JETOPT_VERSION=([^ ;]+) ]]; then
            echo "jetopt ${BASH_REMATCH[1]}"
            exit
        fi
    done < <(declare -f jetopt)

    exit 1
}

usage() {
    cat <<EOF
USAGE --

In standalone mode jetopt recognizes such options:
-h, --help                 Show usage
-V, --version              Show version

If the first arg is not among those, the args list is treated as input
to the jetopt function i.e. short and long options description in
jetopt syntax. The output is values for corresponding -o and -l getopt
options.

Sample output:
> jetopt.sh hhelp .label: q Vversion
-o hqV -l help,label:,version

More details on jetopt syntax https://github.com/slowpeek/jetopt
EOF

    exit
}

case $1 in
    -V|--version)
        version
        : ;;
    -h|--help)
        usage
        : ;;
esac

getopt() {
    printf -- '-o %s -l %s\n' "${2:-''}" "${4:-''}"
}

jetopt "$@"

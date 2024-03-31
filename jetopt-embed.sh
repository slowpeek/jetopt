# -*- mode: sh; sh-shell: bash; -*-
# MIT license (c) 2021-2024 https://github.com/slowpeek
# Homepage: https://github.com/slowpeek/jetopt
jetopt_embed() {
    local arg type mode='' short='' long=''

    while (( $# )); do
        arg=$1

        case $arg in
            -*)
                break ;;

            ,*)
                [[ ! $arg == ,[+-] ]] || mode=${arg:1} ;;

            *)
                type=${arg##*[!:]}
                arg=${arg%"$type"}

                [[ $arg == .* ]] || short+=${arg::1}$type
                arg=${arg:1}

                [[ -z $arg ]] || long+=,$arg$type
        esac

        shift
    done

    local args=()

    if [[ -n $short || -n $long ]]; then
        short=$mode$short

        if [[ -z $short ]]; then
            args+=(-o "''")
        else
            args+=(-o "$short")
        fi

        [[ -z $long ]] || args+=(-l "${long:1}")
    fi

    getopt "${args[@]}" "$@"
}

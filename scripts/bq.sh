#!/bin/bash

# simple function to query component bugs in given RHEL/Fedora with given state
bugzilla_query() {

    local usage="usage: bq {-5|-6|-7|-f} {-n|-q|-m|-v|-c} COMPONENT"
    local bin="/bin/bugzilla"
    local bug_state=""
    local product=""

    if [[ "$#" != "3" ]]; then
        echo "$usage"
        return 1
    fi

    local version=${1/-}

    if [[ ! "$version" =~ [567f] ]]; then
        echo "$usage"
        return 1
    fi

    if [[ "$version" = "f" ]]; then
        product="Fedora"
        version=""
    else
        product="Red Hat Enterprise Linux"
    fi


    case "$2" in
        -n)
            bug_state="NEW,ASSIGNED";;
        -q)
            bug_state="ON_QA";;
        -m)
            bug_state="POST,MODIFIED";;
        -v)
            bug_state="VERIFIED";;
        -c)
            bug_state="CLOSED";;
        *)
            echo "$usage" && return 1;;
    esac

    if [[ ! -e "$bin" ]]; then
        echo "error: bugzilla cli client not installed, install \"python-bugzilla\" package"
        return 1
    fi

    if [[ ! -e "$HOME/.bugzillacookies" &&  ! -e "$HOME/.bugzillatoken" ]]; then
        /bin/bugzilla login
    fi

    /bin/bugzilla query -p "$product $version" -c "$3" -t "$bug_state" | sed s/#// | sort -n
}

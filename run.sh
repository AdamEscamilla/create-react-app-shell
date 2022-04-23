#!/usr/bin/env bash
##############################################
# Create React App Shell
##############################################
WORKDIR=$(pwd)
CMD=App

function App() {
    [ $# -eq 0 ] && set -- null -h;
    project=$1; shift;
    props=$@;
    template=cras-template

    [ $project == '-h' ] && { usage;  exit 0; }

    for prop in $props;
    do
        case $prop in
            -h | --help)
                usage && exit 0;;
            *) log 2 "unknown option \`$prop\`"
        esac
    done

    [ -d $project ] && log 2 "path ${project} exists"

    remote=AdamEscamilla/create-react-app-shell
    branch=master
    url=https://api.github.com/repos/${remote}/git/trees/${branch}?recursive=1
    data=`fetch $url`

    trees=`jq '.tree[]|select(.type=="tree").path' -r <<< "$data"`
    blobs=`jq '.tree[]|select(.type=="blob").path' -r <<< "$data"`

    validate https://raw.githubusercontent.com/${remote}/${branch}/requirements.txt

    log 0 "`banner`"
    log 0 "Creating a new React app in ${WORKDIR}/${project}."
    printf "\n"
    log 0 "Installing packages. This might take a couple of minutes."
    log 0 "Installing react, react-dom, and react-scripts with ${template}..."
    printf "\n"
    #log 0 "Initialized a git repository."
    #printf "\n"
    log 0 "Installing template dependencies using bash..."
    printf "\n"

    (
        cd $WORKDIR &&

        for tree in $trees
        do
            dir=${tree/$template/$project}
            mkdir -p $dir
        done

        for blob in $blobs
        do
            [[ ! `dirname $blob` =~ ^$template/* ]] && continue

            blob=`trimURL <<< $blob`
            file=https://raw.githubusercontent.com/${remote}/${branch}/${blob}
            fetch -o ${blob/$template/$project} $file
        done
    )

    log 0 "Success! Created ${project} at ${WORKDIR}/${project}."
    printf "\n"
    log 0 "We suggest that you begin by typing:"
    printf "\n"
    log 0 "\tcd ${project}"
    log 0 "\tdocker-compose up"
    printf "\n"
    log 0 "Happy hacking!"

    exit 0
}

function validate {
    packages=`fetch -o - $*`
    if ! requires $packages;
    then
        log 2 "missing package dependency"
    fi
}

function fetch { curl -s $* ; }

function log() { state=$1;
    INFO=0
    ERROR=1
    PANIC=2
    reset='\033[0m'
    info='\033[1;32m'
    error='\033[0;31m'
    case $state in
        $INFO)   status=info;;
        $ERROR|$PANIC) status=error;;
    esac
    shift;
    printf "${!status}${*}${reset}\n"
    if [ $state -eq $PANIC ]
    then
        exit $PANIC
    fi
}

function trimURL() { sed 's/?.*//' ; }

function usage() {
    echo "
Usage:
    create-react-app-shell <project name> [-h]

Options
    -h, --help      Show the help menu

Examples
    Create a new React app
    \$ create-react-app-shell my-app
    Show the help menu
    \$ create-react-app-shell -h
";
}

function requires() {
    local package
    for dependency in $@
    do
        [ -z $dependency ] && continue
        package=$(command -v $dependency)
        if [ -z $package ]; then
            printf "missing %s package\n" $dependency
            return 1
        fi
    done
    return 0
}

function banner() {
    cat <<BANNER
                                                                                
  #####                                      ######                             
 #     # #####  ######   ##   ##### ######   #     # ######   ##    ####  ##### 
 #       #    # #       #  #    #   #        #     # #       #  #  #    #   #   
 #       #    # #####  #    #   #   #####    ######  #####  #    # #        #   
 #       #####  #      ######   #   #        #   #   #      ###### #        #   
 #     # #   #  #      #    #   #   #        #    #  #      #    # #    #   #   
  #####  #    # ###### #    #   #   ######   #     # ###### #    #  ####    #   
                                                                                
    #                     #####                                                 
   # #   #####  #####    #     # #    # ###### #      #                         
  #   #  #    # #    #   #       #    # #      #      #                         
 #     # #    # #    #    #####  ###### #####  #      #                         
 ####### #####  #####          # #    # #      #      #                         
 #     # #      #        #     # #    # #      #      #                         
 #     # #      #         #####  #    # ###### ###### ######                    
                                                                                
BANNER
}

set -o errexit
set -- $CMD $@

${ENTRY:-$@}

#! /bin/bash

# todo separatly import ansi init
initializeANSI()
{
    esc=""  # If this does not work, enter an ESC directly.

    # Foreground colors
    blackf="${esc}[30m";    redf="${esc}[31m";  greenf="${esc}[32m"
    yellowf="${esc}[33m";   bluef="${esc}[34m"; purplef="${esc}[35m"
    cyanf="${esc}[36m";     whitef="${esc}[37m"

    # Background colors
    blackb="${esc}[40m";    redb="${esc}[41m";  greenb="${esc}[42m"
    yellowb="${esc}[43m";   blueb="${esc}[44m"; purpleb="${esc}[45m"
    cyanb="${esc}[46m";     whiteb="${esc}[47m"

    # Bold, italic, underline, and inverse style toggles
    boldon="${esc}[1m";     boldoff="${esc}[22m"
    italicon="${esc}[3m";   italicoff="${esc}[23m"
    ulon="${esc}[4m";       uloff="${esc}[24m"
    invon="${esc}[7m";      invoff="${esc}[27m"

    reset="${esc}[0m"
}

initializeANSI

# The goal is to allow me to register projects
# to allow per-project specific automation
projects_dir="$HOME/.arsth/projects"
projects_file="$projects_dir/map.txt"

if [ ! -d $projects_dir ] ; then
    echo "${redf}$0: no projects directory found.${reset}" >&2
    echo "Aborting." >&2
    exit 1
fi

if [ ! -f "$projects_file" ] ; then
    echo "${redf}$0: no projects file found.${reset}" >&2
    echo "Aborting." >&2
    exit 2
fi

function addProject()
{
    project_name=$1

    if [ -z "$1" ] ; then
        echo "${redf}$0: you must provide a project name${reset}" >&2
        exit 3
    fi

    # Get the id we are going to assign to the project to be created
    project_id="$(awk 'id < $0 { id=$0 } END { print id + 1 }'\
        $projects_file)"

    mkdir "$projects_dir/$project_id"
    project_conf_file="$projects_dir/$project_id/conf.json"
    cat templates/template_conf.json | sed "s/<id>/$project_id/g" | sed "s/<name>/$project_name/g" > $project_conf_file
    echo "$project_id:$project_name:true" >> $projects_file
    echo "$project_id"
}

# === Main script
if [ "$1" = "add" ] ; then
    project_id=$(addProject $2)
    echo "${greenf}Project registered successfully with id: ${project_id}${reset}"
fi

# basically another script will read through the projects file to do stuff: for example create yakuake sessions
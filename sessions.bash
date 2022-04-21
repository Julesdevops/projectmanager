#!/bin/bash
source ./yakuake.bash
sessions_file="$HOME/.arsth/projects/.sessions.json"

for session in $(cat "$sessions_file" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${session} | base64 --decode | jq -r ${1}
    }
    session_name=$(_jq '.name')
    session_id=$(addSession $session_name)

    i=0

    for terminal in $(echo ${session} | base64 --decode | jq -r '.terminals[] | @base64'); do
        terminal_wd=$(echo ${terminal} | base64 --decode | jq -r '.wd')
        terminal_command=$(echo ${terminal} | base64 --decode | jq -r '.launch_command')
        launch_command="cd ${terminal_wd} && ${terminal_command}"

        if [ $i -eq "0" ] ; then
            runCommand "$launch_command"
        else
            addTerminal $session_id
            runCommand "$launch_command"
        fi

        let "i++"
    done
done
#!/bin/bash
projects_dir="$HOME/.arsth/projects"
conf="$projects_dir/$1/conf.json"
log_file="./log.txt"

INITIAL_ID=`qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.activeSessionId`

function run {
    local cmd="qdbus org.kde.yakuake $1"
    echo $cmd >> $log_file
    local output=$(eval $cmd)
    echo "$output"
}

function getActiveSessionid {
    run "/yakuake/sessions org.kde.yakuake.activeSessionId"
}

# Add a new yakuake session with the given title
function addSession {
    session_id=$(run "/yakuake/sessions org.kde.yakuake.addSession")
    run "/yakuake/tabs setTabTitle $session_id \"$1\""
    echo "$session_id"
}

function addTerminal {
    local session_id=$1
    local terminal_id=$(run /yakuake/sessions org.kde.yakuake.terminalIdsForSessionId \"$session_id\")
    run "/yakuake/sessions org.kde.yakuake.splitTerminalTopBottom \"$terminal_id\""
    echo "$terminal_id"
}

function runCommandInTerminal {
    terminal_id=$1
    run "/yakuake/sessions runCommandInTerminal $1 \"$2\"" 
}

function removeSession {
    local session_id=$1
    run "/yakuake/sessions org.kde.yakuake.removeSession $session_id"
}

session_id=$(addSession test)
# addTerminal $session_id
# terminal_id=$(addTerminal $session_id)
sleep 0.5
runCommandInTerminal $session_id "pwd"

# session_name=$(cat "$conf" | jq -r '.sessions[0].name')
# launch_command=$(cat "$conf" | jq -r '.sessions[0].terminals[0].launch_command')
# addSession $session_name $launch_command

#!/bin/bash
projects_dir="$HOME/.arsth/projects"
conf="$projects_dir/$1/conf.json"

INITIAL_ID=`qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.activeSessionId`

function run {
    local cmd="qdbus org.kde.yakuake $1"
    local output=$(eval $cmd)
    echo "$output"
}

function getActiveSessionid {
    run "/yakuake/sessions org.kde.yakuake.activeSessionId"
}

# Add a new yakuake session with the given title
function addSession {
    session_id=$(run "/yakuake/sessions org.kde.yakuake.addSession")
    sleep 0.5
    run "/yakuake/tabs setTabTitle $session_id \"$1\""
    sleep 0.2
    echo "$session_id"
}

function addTerminal {
    local session_id=$1
    local current_terminal_id=$(run /yakuake/sessions activeTerminalId)
    run "/yakuake/sessions splitTerminalLeftRight $current_terminal_id"
}

function runCommandInTerminal {
    terminal_id=$1
    run "/yakuake/sessions runCommandInTerminal $1 \"$2\"" 
}

function runCommand {
    run "/yakuake/sessions runCommand \"$1\""
}

function removeSession {
    local session_id=$1
    run "/yakuake/sessions org.kde.yakuake.removeSession $session_id"
}

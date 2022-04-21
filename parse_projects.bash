#!/bin/bash
# TODO make this an env variable?
projects_dir="$HOME/.arsth/projects"
projects_file="$projects_dir/map.txt"
project_sessions_file="$projects_dir/.sessions.json"
project_ids="$(cat $projects_file | awk -F: '{print $1}')"

sessions_to_register="[]"

function parseProjectFile {
    conf=$1
    session_flag=$(cat "$conf" | jq -r '.session')
    project_name=$(cat "$conf" | jq -r '.name')
    final_sessions_array="[]"

    if [ $session_flag = "true" ] ; then
        # Create the sessions
        sessions=$(cat "${conf}" | jq -c '.sessions[]')

        for session in $sessions; do
            original_name=$(echo $session | jq -r '.name')
            built_session=$(echo $session | jq -r ".name = \"$project_name - $original_name\"")
            final_sessions_array=$(echo "$final_sessions_array" | jq ". + [$built_session]")
        done
    fi

    sessions_to_register=$(echo "$sessions_to_register" | jq ". + $final_sessions_array")
}

for project_id in $(echo $project_ids); do
    # Get the configuration file of the project
    project_conf_file="$projects_dir/$project_id/conf.json"

    if [ ! -f $project_conf_file ] ; then
        echo "ERROR: project conf file does not exist."
        exit 1
    fi

    parseProjectFile $project_conf_file
done

echo "$sessions_to_register" > $project_sessions_file

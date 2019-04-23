<?php

function getUpdates($data, $type) {
    global $db;
    
    //Check parameter presence
    if(!isset($data['latest_update_timestamp']))
        throw new InvalidRequestException("latest_update_timestamp cannot be blank", 3001);

    $id;
    switch ($type) {
        case "commits":
            $id = "commit_id";
            break;
        case "requests":
            $id = "request_id";
            break;
        default:
            throw new Exception("Impossible to use the endpoint");
    }

    $time = $data['latest_update_timestamp'];

    //Get the last added commit' timestamp (TODO: commit count) -- query is safe here
    $data = $db->query("SELECT MAX(approvation_date) as latest_timestamp FROM $type");

    $out = [
        "latest_update_timestamp" => strtotime($data[0]['latest_timestamp']),
        //"new_commit_count" => $db->query("SELECT COUNT(timestamp) as new_commit FROM commit WHERE '$time' < commit.timestamp")[0]['new_commit']
    ];
    //Boolean condition
    $out['updates_found'] = $out['latest_update_timestamp'] > $time;

    return $out;
}
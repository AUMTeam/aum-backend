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

    //Get the last added commit' timestamp -- query is safe here
    $approv = $db->preparedQuery("SELECT MAX(approvation_date) as latest_timestamp FROM $type");
    //$new_count = $db->preparedQuery("SELECT COUNT(*) as new_commit FROM commits WHERE ? < creation_date", [$time]);

    $out = [
        "latest_update_timestamp" => strtotime($approv[0]['latest_timestamp']),
        //"new_count" => $new_count[0]['new_commit']
    ];
    //Boolean condition
    $out['updates_found'] = $out['latest_update_timestamp'] > $time;

    return $out;
}
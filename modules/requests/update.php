<?php

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {
    global $db;

    //Check parameter presence
    if(!isset($data['latest_update_timestamp']))
        throw new InvalidRequestException("latest_update_timestamp cannot be blank", 3001);

    $time = $data['latest_update_timestamp'];

    //Get the last added request' timestamp (TODO: commit count)
    $data = $db->query("SELECT MAX(modified_date) as latest_timestamp, COUNT(request_id) as amount_request FROM requests");

    $out = [
        "count" => $data[0]['amount_request'],
        "latest_update_timestamp" => strtotime($data[0]['latest_timestamp']),
        //"new_commit_count" => $db->query("SELECT COUNT(timestamp) as new_commit FROM commit WHERE '$time' < commit.timestamp")[0]['new_commit']
    ];
    //Boolean condition
    $out['updates_found'] = $out['latest_update_timestamp'] > $time;

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
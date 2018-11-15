<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 12/11/2018
 * Time: 15:48
 */

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['latest_commit_timestamp']))
        throw new InvalidRequestException("latest_commit_timestamp cannot be blank", 3001);

    $time = $data['latest_commit_timestamp'];

    $data = $db->query("SELECT MAX(timestamp) as latest_timestamp, COUNT(commit_id) as amount_commit FROM commit_m");

    $out = [
        "commit_count" => $data[0]['amount_commit'],
        "latest_commit_timestamp" => strtotime($data[0]['latest_timestamp']),
        //"new_commit_count" => $db->query("SELECT COUNT(timestamp) as new_commit FROM commit_m WHERE '$time' < commit_m.timestamp")[0]['new_commit']
    ];

    $out['updates_found'] = $out['latest_commit_timestamp'] > $time;

    //if($time == $out['commit_latest'])
        //throw new NotEditedException();

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
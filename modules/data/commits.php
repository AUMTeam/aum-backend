<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;
    $out = [];

    $res = $db->preparedQuery("SELECT commit_id FROM commits WHERE author_user_id=?", [$user['user_id']]);

    foreach($res as $entry)
        array_push($out, $entry['commit_id']);

    return [
        "response_data" => $out,
        "status_code" => 200,
    ];
};
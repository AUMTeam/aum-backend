<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    global $db;
    $user_id = getMyInfo($token)['user_id'];
    $out = [];

    $res = $db->preparedQuery("SELECT commit_id FROM commits WHERE author_user_id=?", [$user_id]);

    foreach($res as $entry)
        array_push($out, $entry['commit_id']);

    return [
        "response_data" => $out,
        "status_code" => 200,
    ];
};
<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    require_once __DIR__ . "/../../lib/libCommitRequest/libList.php";

    $user_info = getUserData($token);
    $user_id = $user_info['user_id'];
    $role_id = $user_info['role'];

    return [
        "response_data" => get_list("commits", $data, $user_id, $role_id),
        "status_code" => 200,
    ];
};
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
    global $token;

    require_once __DIR__ . "/../../lib/libCommitRequest/libList.php";

    validateInput($data, "request");

    $user_info = getUserData($db, $token);
    $user_id = $user_info['user_id'];
    $role_id = $user_info['role'];

    return [
        "response_data" => get_list_data("request", $data, $db, $user_id, $role_id),
        "status_code" => 200,
    ];
};
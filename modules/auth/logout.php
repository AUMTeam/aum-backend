<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    //One-step token erasing
    $db->query("DELETE FROM users_token WHERE token = '$token'");

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
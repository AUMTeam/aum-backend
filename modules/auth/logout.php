<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    //Erase the token from the DB
    $db->query("DELETE FROM users_tokens_v2 WHERE token = '$token'");

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
<?php

$init = function (array $data) : array {

    global $db;
    global $token;

    //Take token validity
    return [
        "result" => $db->query("SELECT token_expire FROM users_token WHERE token = '$token'")
    ];
};

$exec = function (array $data, array $data_init) : array {
    return [
        "response_data" => [
            "token_expire" => $data_init['result'][0]['token_expire']
        ],
        "status_code" => 200
    ];
};
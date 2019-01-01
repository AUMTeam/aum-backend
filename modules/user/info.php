<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    //We are done here
    return [
        "response_data" => getUserData($db, $token, $data),
        "status_code" => 200
    ];
};
<?php

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    $ret = send($db, $token, 3, 1);

    return [
        "response_data" => $ret,
        "status_code" => 200
    ];
};
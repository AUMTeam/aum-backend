<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;

    //We are done here, see libUserInfo/include.php for details
    return [
        "response_data" => getUserData($token, $data),
        "status_code" => 200
    ];
};
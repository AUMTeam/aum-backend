<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    $out = [];

    if (isset($data['user_id']))
        $out = getUserInfo($data['user_id']);
    else
        $out = getMyInfo($token);

    //We are done here, see libUserInfo/include.php for details
    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
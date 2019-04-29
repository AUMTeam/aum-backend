<?php

$init = function (array $data) : array { return []; };

/**
 * Gets the current user info, or an user info if user_id is specified
 */
$exec = function (array $data, array $data_init) : array {
    $out = [];

    //user_id was specified
    if (isset($data['user_id']))
        $out = getUserInfo($data['user_id']);
    else {  //Use the current user
        global $user;
        $out = $user;
    }

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
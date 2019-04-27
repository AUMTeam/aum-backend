<?php

$init = function (array $data) : array { return []; };

/**
 * Gets the current user info, or an user info if user_id is specified
 */
$exec = function (array $data, array $data_init) : array {
    $out = [];

    if (isset($data['user_id']))
        $out = getUserInfo($data['user_id']);
    else {
        global $user;
        $out = $user;
    }

    //We are done here, see libUserInfo/include.php for details
    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
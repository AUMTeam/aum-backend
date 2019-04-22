<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    $type;
    require_once __DIR__ . "/../../lib/libCommitRequest/libList.php";

    if (isset($data['role_id'])) {
        $role = $data['role_id'];

        if ($role == 4)
            $type = "client";
        else
            $type = "requests";

    } else
        throw new InvalidRequestException("Error: missing role_id parameter!");

    $user_info = getUserData($token);
    $user_id = $user_info['user_id'];
    $role_id = $user_info['role'];

    return [
        "response_data" => get_list($type, $data, $user_id, $role_id),
        "status_code" => 200,
    ];
};
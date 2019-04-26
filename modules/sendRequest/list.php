<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    $type;
    require_once __DIR__ . "/../../lib/libCommitRequest/libList.php";

    if (isset($data['role'])) {

        if ($data['role'] == 4)
            $type = TYPE_CLIENT;
        else
            $type = TYPE_REQUEST;

    } else  //Fallback for now to 'requests' TODO: Remove this
        //throw new InvalidRequestException("Error: missing role_id parameter!");
        $type = TYPE_REQUEST;

    $user_info = getMyInfo($token);
    $user_id = $user_info['user_id'];
    $role_id = $user_info['role'];

    return [
        "response_data" => get_list($type, $data, $user_id, $role_id),
        "status_code" => 200,
    ];
};
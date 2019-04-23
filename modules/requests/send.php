<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    global $db;

    $role = getMyInfo($token)['role'];
    if (in_array(3, $role)) {
        if (isset($data['id'])) {
            $db->query("UPDATE requests SET is_approved=2 WHERE request_id=?", [$data['id']]);
        }
    } else {
        throw new UnauthorizedException();
    }
    
    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};
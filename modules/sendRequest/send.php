<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    global $db;

    if (!isset($data['id'])) {
        throw new InvalidRequestException("Missing 'id' parameter!");
    }

    $role = getMyInfo($token)['role'];
    if (in_array(3, $role)) {
        if (isset($data['id'])) {
            $db->preparedQuery("UPDATE requests SET is_approved=2 WHERE request_id=?", [$data['id']]);

            $cli = $db->preparedQuery("SELECT client_user_id FROM requests_clients WHERE request_id=?", [$data['id']]);
            foreach($cli as $entry)
                send($token, $entry['client_user_id'], $data['id'], MAIL_NEW_PATCH);
        }
    } else {
        throw new UnauthorizedException();
    }
    
    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};
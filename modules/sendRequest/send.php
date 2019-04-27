<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;

    if (!isset($data['id'])) {
        throw new InvalidRequestException("Missing 'id' parameter!");
    }

    if (in_array(3, $user['role'])) {
        if (isset($data['id'])) {
            $db->preparedQuery("UPDATE requests SET is_approved=2 WHERE request_id=?", [$data['id']]);

            $cli = $db->preparedQuery("SELECT client_user_id FROM requests_clients WHERE request_id=?", [$data['id']]);
            foreach($cli as $entry)
                send($entry['client_user_id'], $data['id'], MAIL_NEW_PATCH, TYPE_REQUEST);
        }
    } else {
        throw new UnauthorizedException();
    }
    
    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};
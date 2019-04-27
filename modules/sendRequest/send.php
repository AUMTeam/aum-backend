<?php

$init = function (array $data) : array { return []; };

/**
 * Send a new update to the clients
 */
$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;

    if (!isset($data['id']) || !isset($data['install_link'])) {
        throw new InvalidRequestException();
    }

    if (in_array(3, $user['role'])) {   //Only revision office members can send updates
        $db->preparedQuery("UPDATE requests SET is_approved=2, install_link=? WHERE request_id=?", [$data['id'], $data['install_link']]);

        //Send an email to the clients
        $cli = $db->preparedQuery("SELECT client_user_id FROM requests_clients WHERE request_id=?", [$data['id']]);
        foreach($cli as $entry)
            sendMail($entry['client_user_id'], $data['id'], MAIL_NEW_PATCH, TYPE_REQUEST);
    } else
        throw new UnauthorizedException();
    
    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};
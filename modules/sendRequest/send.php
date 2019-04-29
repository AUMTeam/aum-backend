<?php

$init = function (array $data) : array { return []; };

/**
 * Send a new update to the clients
 */
$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;

    //Only member of the Revision Office can execute this endpoint
    if (!in_array(ROLE_REVOFFICE, $user['role_name']))
        throw new UnauthorizedException("The current user is not authorized to perform this action!");

    //Check if all fields are in place
    if (!isset($data['id']) || !isset($data['install_link']))
        throw new InvalidRequestException();


    //Check if the send request is present and if it hasn't already been validated
    $entry = $db->preparedQuery("SELECT is_approved FROM requests WHERE request_id=?", [$data['id']]);
    if (count($entry) == 0)
        throw new InvalidArgumentException("id not found");
    else if ($entry[0]['is_approved'] != 1)
        throw new InvalidRequestException("Request status is invalid");

    $db->preparedQuery("UPDATE requests SET is_approved=2, install_link=? WHERE request_id=?", [$data['install_link'], $data['id']]);


    //Send an email to the clients
    $cli = $db->preparedQuery("SELECT client_user_id FROM requests_clients WHERE request_id=?", [$data['id']]);
    foreach($cli as $entry)
        sendMail($entry['client_user_id'], MAIL_NEW_PATCH, $data['id']);
    
    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
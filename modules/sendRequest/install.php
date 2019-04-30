<?php

/**
 * Notifty IBT that a client has installed a new update
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    global $user;

    //Only clients can execute this endpoint
    if (!in_array(ROLE_CLIENT, $user['role_name']))
        throw new UnauthorizedException("The current user is not authorized to perform this action!");

    //Check fields presence
    if (empty($data['id']))
        throw new InvalidRequestException("Missing 'id' parameter!");
    $feedback = "";     //Feedback is not mandatory
    if (!empty($data['feedback']))
        $feedback = $data['feedback'];

    
    $now = time();
    //Update the DB
    $db->preparedQuery("UPDATE requests_clients SET comment=?, install_date=FROM_UNIXTIME(?), install_status=1
        WHERE request_id=? AND client_user_id=?", [$feedback, $now, $data['id'], $user['user_id']]);
    

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
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
    if (empty($data['id']) || empty($data['install_status']) || ($data['install_status'] != -1 && $data['install_status'] != 1))
        throw new InvalidRequestException();
    $feedback = "";     //Feedback is not mandatory
    if (!empty($data['feedback']))
        $feedback = $data['feedback'];

    //Check if the ID is valid
    $req = $db->preparedQuery("SELECT request_id, install_status FROM requests_clients WHERE request_id=? AND client_user_id=? AND install_status NOT IN('1', '-1')", [$data['id'], $user['user_id']]);
    if (count($req) == 0)
        throw new InvalidRequestException("Error: request not found or request already approved");
    
    //Update the DB
    $db->preparedQuery("UPDATE requests_clients SET comment=?, install_timestamp=now(), install_status=?
        WHERE request_id=? AND client_user_id=?", [$feedback, $data['install_status'], $data['id'], $user['user_id']]);
    

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
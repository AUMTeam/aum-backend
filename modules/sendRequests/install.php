<?php

/**
 * Notifty IBT that a client has installed a new update
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    global $user;

    //Only clients can execute this endpoint
    if (!in_array(ROLE_CLIENT, $user['role_name']))
        throw new UnauthorizedException();

    //Check fields presence
    if (empty($data['id']) || empty($data['install_status']) || ($data['install_status'] != -1 && $data['install_status'] != 1))
        throw new InvalidRequestException();
    $feedback = "";     //Feedback is not mandatory
    if (!empty($data['feedback']))
        $feedback = $data['feedback'];

    //Check if the ID is valid
    $req = $db->preparedQuery("SELECT request_id, install_status, approval_status FROM requests_clients WHERE request_id=? AND client_user_id=?", [$data['id'], $user['user_id']]);
    if (count($req) == 0)
        throw new InvalidRequestException("Send request not found", "ERROR_INVALID_ID");
    else if ($req[0]['approval_status'] != 2)
        throw new InvalidRequestException("The current send request was not sent to the client", "ERROR_WRONG_APP_STATUS");
    
    //Update the DB
    $db->preparedQuery("UPDATE requests_clients SET comment=?, install_timestamp=now(), install_status=?
        WHERE request_id=? AND client_user_id=?", [$feedback, $data['install_status'], $data['id'], $user['user_id']]);
    
    //Send a mail to the author, to the approver and to the sender
    $users = $db->preparedQuery("SELECT author_user_id, sender_user_id, approver_user_id FROM requests WHERE request_id=?", [$data['id']])[0];
    sendMail($users['approver_user_id'], MAIL_FEEDBACK_ADDED, $data['id']);
    sendMail($users['author_user_id'], MAIL_FEEDBACK_ADDED, $data['id']);
    sendMail($users['sender_user_id'], MAIL_FEEDBACK_ADDED, $data['id']);

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
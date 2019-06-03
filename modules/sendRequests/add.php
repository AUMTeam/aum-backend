<?php

/**
 * Adds a new send request to the database
 */
$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;

    //Only developers can add new send requests
    if (!in_array(ROLE_DEVELOPER, $user['role_name']))
        throw new UnauthorizedException();

    //Check if all the fields are in place
    if(empty($data['title']) || empty($data['description']) || !isset($data['install_type']) || $data['install_type'] < 0 || $data['install_type'] > 1
        || empty($data['dest_clients']) || empty($data['components']) || empty($data['branch']))
        throw new InvalidRequestException();
    

    //Get the current user's id, which is the author's id
    $author_user_id = $user['user_id'];

    
    //If the user is part of the tech area, the send request will be automatically approved
    $approval_status = "0";
    $approver_user_id = NULL;
    if (in_array(ROLE_TECHAREA, $user['role_name'])) {
        $approval_status = "1";
        $approver_user_id = $author_user_id;
    }

    $db->beginTransaction();

    try {
        //Add the request into the database, and get the ID of the just added request
        $db->preparedQuery("INSERT INTO requests(title, description, install_type, author_user_id, components, branch_id, approval_status, approver_user_id) VALUES 
                (?, ?, ?, ?, ?, ?, ?, ?)", 
                [$data['title'], $data['description'], $data['install_type'], $author_user_id, $data['components'], $data['branch'], $approval_status, $approver_user_id]); 
        $request_id = $db->getLastInsertId();

        //Destination clients and Commits are in separated tables: add the data also in those tables using the received request_id
        $clients = $data['dest_clients'];
        foreach($clients as $client_user_id)
            $db->preparedQuery("INSERT INTO requests_clients(request_id, client_user_id) VALUES (?, ?)", [$request_id, $client_user_id]);

        if (isset($data['commits'])) {  //commits' array is not strictly required
            $commits = $data['commits'];
            foreach($commits as $commit_id)
                $db->preparedQuery("INSERT INTO requests_commits(request_id, commit_id) VALUES (?, ?)", [$request_id, $commit_id]);
        }

        $db->commit();

        //Send an email to the tech area responsibles
        foreach($user['resp'] as $resp)
        sendMail($resp, MAIL_NEW_ENTRY, $request_id, TYPE_REQUEST);
    } catch (DBException $ex) {
        $db->rollback();
        throw new DBException($ex->getIntMessage(), $ex->getErrorCode(), $ex->getStatusCode());
    }

    
    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
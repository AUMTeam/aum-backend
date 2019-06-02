<?php

/**
 * Adds a new commit to the database
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    global $user;

    //Only developers can add new commits
    if (!in_array(ROLE_DEVELOPER, $user['role_name']))
        throw new UnauthorizedException();
        
    //Check if all the fields are in place
    if(empty($data['title']) || empty($data['description']) || empty($data['components']) || empty($data['branch']))
        throw new InvalidRequestException();


    //Get the current user's id, which is the author's id
    $author_user_id = $user['user_id'];

    //If the user is part of the tech area, the commit will be automatically approved
    $approval_status = "0";
    $approver_user_id = NULL;
    if (in_array(ROLE_TECHAREA, $user['role_name'])) {
        $approval_status = "1";
        $approver_user_id = $author_user_id;
    }

    //Add the commit into the database and get its ID
    $db->preparedQuery("INSERT INTO commits(title, description, components, branch_id, author_user_id, approval_status, approver_user_id)
        VALUES (?, ?, ?, ?, ?, ?, ?)",
        [$data['title'], $data['description'], $data['components'], $data['branch'], $author_user_id, $approval_status, $approver_user_id]);
    $id = $db->getLastInsertId();
    
    
    //Send the email to the tech area responsibles
    foreach($user['resp'] as $resp)
        sendMail($resp, MAIL_NEW_ENTRY, $id, TYPE_COMMIT);
    
    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
<?php

$init = function (array $data) : array { return [ ]; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $user;

    //Check if all the fields are in place
    if(!isset($data['title']) || !isset($data['description']) || !isset($data['components']) || !isset($data['branch']))
        throw new InvalidRequestException("Invalid request", 3000);

    //Get the current user's id, which is the author's id
    $author_user_id = $user['user_id'];

    //Add the commit into the database
    $db->preparedQuery("INSERT INTO commits(title, description, components, branch_id, author_user_id) VALUES (?, ?, ?, ?, ?)", [$data['title'], $data['description'], $data['components'], $data['branch'], $author_user_id]);
    $id = $db->preparedQuery("SELECT LAST_INSERT_ID() as 'id' FROM commits")[0]['id'];
    
    foreach($user['resp'] as $resp) {
        send($resp['user_id'], $id, MAIL_NEW_COMMIT, TYPE_COMMIT);
    }
    
    return [
        "response_data" => [],
        "status_code" => 200
    ];

};
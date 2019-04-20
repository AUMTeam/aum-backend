<?php

$init = function (array $data) : array { return [
    // Source: https://stackoverflow.com/questions/15737408/php-find-all-occurrences-of-a-substring-in-a-string
    'strpos_all' => function (string $haystack, string $needle) : array {
        $offset = 0;
        $allpos = array();
        while (($pos = strpos($haystack, $needle, $offset)) !== FALSE) {
            $offset   = $pos + 1;
            $allpos[] = $pos;
        }
        return $allpos;
    }
]; };

$exec = function (array $data, array $data_init) : array {
    global $token;

    //Check if all the fields are in place
    if(!isset($data['description']) || !isset($data['install_type']) || $data['install_type'] < 0 || $data['install_type'] > 1
        || !isset($data['install_link']) || !isset($data['dest_clients']) || !isset($data['component']) || !isset($data['branch']))
        throw new InvalidRequestException("Invalid request", 3000);
    else {
        str_replace('"', '\"', $data['description'], count($data_init['strpos_all']($data['description'],'"')));
        str_replace('"', '\"', $data['install_link'], count($data_init['strpos_all']($data['install_link'],'"')));
    }
    
    //Get the current user's id, which is the author's id
    $author_user_id = getUserData($token)['user_id'];

    //Add the request into the database, and consequently get the ID of the just added request
    $db->query("INSERT INTO requests(description, install_type, install_link, author_user_id, component_id, branch_id) VALUES 
            (\"{$data['description']}\", ${data['install_type']}, '${data['install_link']}', $author_user_id, ${data['component']}, ${data['branch']})"); 
    $request_id = $db->query("SELECT LAST_INSERT_ID() as 'request_id'")[0]['request_id'];

    //Destination clients and Commits are in separated tables: add the data also in those tables using the received request_id
    $clients = $data['dest_clients'];
    foreach($clients as $client_user_id)
        $db->query("INSERT INTO requests_clients(request_id, client_user_id) VALUES (${request_id}, ${client_user_id})");

    if (isset($data['commits'])) {  //commits' array is not strictly required
        $commits = $data['commits'];
        foreach($clients as $commit_id)
            $db->query("INSERT INTO requests_commits(request_id, commit_id) VALUES (${request_id}, ${commit_id})");
    }

    return [
        "response_data" => [ ],
        "status_code" => 200
    ];

};
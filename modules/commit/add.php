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
    global $db;
    global $token;

    //Check if all the fields are in place
    if(!isset($data['description']) || !isset($data['component']) || !isset($data['branch']))
        throw new InvalidRequestException("Invalid request", 3000);
    else
        str_replace('"', '\"', $data['description'], count($data_init['strpos_all']($data['description'],'"')));

    //Get the current user's id, which is the author's id
    $author_user_id = getUserData($db, $token)['user_id'];

    //Add the commit into the database
    $db->query("INSERT INTO commits(description, component_id, branch_id, author_user_id) VALUES (\"{$data['description']}\",${data['component']}, ${data['branch']}, $author_user_id)");

    return [
        "response_data" => [],
        "status_code" => 200
    ];

};
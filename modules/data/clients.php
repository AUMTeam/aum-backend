<?php

$init = function (array $data) : array { return []; };

/**
 * Get the list of clients present in the DB
 */
$exec = function (array $data, array $data_init) : array {
    global $db;

    $data = $db->preparedQuery("SELECT users.user_id FROM users, users_roles WHERE 
        users.user_id=users_roles.user_id AND role_id=?", [4]);   //users
    $out = [];

    foreach ($data as $entry) {
        $user = getUserInfo($entry['user_id']);
        $out[] = $user;
    }

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
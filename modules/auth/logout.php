<?php

/**
 * Log the user out of the application by removing its token
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    //Erase the token from the DB
    $db->preparedQuery("DELETE FROM users_tokens WHERE token=?", [$token]);

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
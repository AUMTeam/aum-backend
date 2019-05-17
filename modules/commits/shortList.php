<?php

/**
 * Gets the list commits ID for the current user, used for autocomplete in the frontend
 */
$exec = function (array $data, array $data_init) : array {
    global $user;
    global $db;
    $out = [];

    $res = $db->preparedQuery("SELECT commit_id, title FROM commits WHERE author_user_id=?", [$user['user_id']]);

    foreach($res as $entry)
        $out[] = $entry;
    return [
        "response_data" => $out,
        "status_code" => 200,
    ];
};
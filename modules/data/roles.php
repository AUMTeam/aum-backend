<?php

/**
 * Get the list of roles present in the DB (id + desc)
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    $out = [];

    $data = $db->preparedQuery("SELECT * FROM roles");

    foreach ($data as $entry)
        $out[] = [
            'role_id' => $entry['role_id'],
            'role_string' => $entry['role_string']
        ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
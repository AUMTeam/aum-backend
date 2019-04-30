<?php

/**
 * Get the list of branches present in the DB
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    $out = [];

    $data = $db->preparedQuery("SELECT * FROM branches");

    foreach ($data as $entry) {
        $out[] = [
            'id' => $entry['branch_id'],
            'name' => $entry['branch_name']
        ];
    }

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
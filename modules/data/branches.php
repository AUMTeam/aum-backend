<?php

$init = function (array $data) : array { return []; };

/**
 * Get the list of branches present in the DB
 */
$exec = function (array $data, array $data_init) : array {
    global $db;

    $data = $db->preparedQuery("SELECT * FROM branches");
    $out = [];

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
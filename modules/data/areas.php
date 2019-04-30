<?php

/**
 * Get the list of areas present in the DB (id + desc)
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    $out = [];

    $data = $db->preparedQuery("SELECT * FROM areas");

    foreach ($data as $entry)
        $out[] = [
            'area_id' => $entry['area_id'],
            'area_string' => $entry['area_name']
        ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
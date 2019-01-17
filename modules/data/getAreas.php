<?php

$init = function (array $data) : array { return []; };

/**
 * Get the list of areas_v2 present in the DB (id + desc)
 */
$exec = function (array $data, array $data_init) : array {
    global $db;

    $data = $db->query("SELECT * FROM areas_v2");

    $out = [];

    foreach ($data as $entry)
        $out[] = [
            'area_id' => $entry['area_id'],
            'area_tring' => $entry['area_name']
        ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
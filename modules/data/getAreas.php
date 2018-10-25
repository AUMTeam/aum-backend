<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/25
 * Time: 21:07
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    //One-step token erasing
    $data = $db->query("SELECT * FROM areas_m");

    $out = [];

    foreach ($data as $entry)
        $out[] = [
            'area_id' => $entry['area_id'],
            'area_string' => $entry['area_string']
        ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
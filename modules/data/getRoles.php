<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/25
 * Time: 21:04
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    //One-step token erasing
    $data = $db->query("SELECT * FROM roles_m");

    $out = [];

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
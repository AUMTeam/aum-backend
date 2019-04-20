<?php

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libUpdate.php";

    return [
        "response_data" => getUpdates($data, "requests"),
        "status_code" => 200
    ];
};
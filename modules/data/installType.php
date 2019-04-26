<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    $out = [
        ['id' => 0,
        'desc' => 'A Caldo'],
        ['id' => 1,
        'desc' => 'A Freddo']
    ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
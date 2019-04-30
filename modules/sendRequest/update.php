<?php

/**
 * Check if there are new send request since the last update
 */
$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libUpdate.php";

    return [
        "response_data" => getUpdates($data, TYPE_REQUEST),
        "status_code" => 200
    ];
};
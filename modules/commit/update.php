<?php

$init = function (array $data) : array { return []; };

/**
 * Check if there are new commits since the last update
 */
$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libUpdate.php";

    return [
        "response_data" => getUpdates($data, TYPE_COMMIT),
        "status_code" => 200
    ];
};
<?php

/**
 * Delete a commit with a given ID
 */
$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libRemove.php";

    remove(TYPE_REQUEST, $data);

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};
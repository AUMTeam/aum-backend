<?php

$init = function (array $data) : array { return []; };

/**
 * Gets the list of commits
 */
$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libList.php";

    return [
        "response_data" => get_list(TYPE_COMMIT, $data),
        "status_code" => 200,
    ];
};
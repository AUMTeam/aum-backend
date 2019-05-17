<?php

/**
 * Approve a commit with a given ID and approvation flag
 */
$exec = function (array $data, array $data_init) : array {
    require_once __DIR__ . "/../../lib/libCommitRequest/libApprove.php";

    approve($data, TYPE_COMMIT);

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};
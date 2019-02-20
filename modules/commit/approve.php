<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;
    require_once __DIR__ . "/../../lib/libCommitRequest/libApprove.php";

    $user = getUserData($db, $token);
    approve($db, $data, $user, "commit");

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};
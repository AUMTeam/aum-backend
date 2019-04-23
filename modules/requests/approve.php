<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $token;
    require_once __DIR__ . "/../../lib/libCommitRequest/libApprove.php";

    $user = getMyInfo($token);
    approve($data, $user, "requests");

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};
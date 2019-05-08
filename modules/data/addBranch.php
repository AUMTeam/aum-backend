<?php

/**
 * Adds a new branch to the DB
 */
$exec = function (array $data, array $data_init) : array {
    if (empty($data['branch_name']))
        throw new InvalidRequestException();

    global $user;
    global $db;

    if (!in_array(ROLE_POWERUSER, $user['role_name']))   //Only power users (admins) are allowed
        throw new UnauthorizedException();

    $db->preparedQuery("INSERT INTO branches(branch_name) VALUES(?)", [$data['branch_name']]);

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
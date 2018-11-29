<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 29/11/2018
 * Time: 20:43
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    if(!isset($data['description']))
        throw new InvalidRequestException("description comment be blank", 3000);
    else
        $data['description'] = base64_encode($data['description']);

    if(!isset($data['destination_client'])) throw new InvalidRequestException("destination_client cannot be blank", 3000);

    $user_id = getUserData($db, $token)['user_id'];

    $db->query("INSERT INTO requests_m(description, requester, destination_client) VALUES (\"{$data['description']}\",$user_id, {$data['destination_client']})");

    return [
        "response_data" => [],
        "status_code" => 200
    ];

};
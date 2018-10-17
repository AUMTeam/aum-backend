<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 19:06
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    $user_data = $db->query("SELECT user_id, name, role_id, area_id FROM users WHERE token = '$token'");

    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    $out = $user_data[0];

    $out['role'] = $db->query("SELECT role_name FROM role WHERE role_id = {$out['role_id']}");

    if(is_null($out['area']))
        $out['area'] = $db->query("SELECT area_name FROM area WHERE area_id = {$out['area_id']}");

    $out = [
        'role' => $out['role'],
        'area' => $out['area'],
        'user_id' => $out['user_id'],
        'name' => $out['name']
    ];

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
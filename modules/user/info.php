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

    //Retreive user data
    $user_data = $db->query("SELECT user_id, name, role_id, area_id FROM users WHERE token = '$token'");

    //Don't know if it will be really useful since main checks it but who knows
    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    //Temporary storing
    $out = $user_data[0];

    //Obtaining string for 'role'
    $out['role'] = $db->query("SELECT role_name FROM roles WHERE role_id = {$out['role_id']}")[0]['role_name'];

    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id']))
        $out['area_id'] = $db->query("SELECT area_name FROM areas WHERE area_id = {$out['area_id']}")[0]['area_name'];

    //Make a new correct response
    $out = [
        'role' => $out['role'],
        'area' => $out['area_id'],
        'user_id' => $out['user_id'],
        'name' => $out['name']
    ];

    //We are done here
    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 29/11/2018
 * Time: 20:36
 */

function getUserData(DatabaseWrapper $db, string $token, array $data = []) : array {
    //Retreive user data
    if(isset($data['user_id'])){
        $user_data[0]['user_id'] = $data['user_id'];
        goto user_id;
    }
    else
        $user_data = $db->query("SELECT user_id FROM users_token_m WHERE token = '$token'");

    //Don't know if it will be really useful since main checks it but who knows
    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    user_id:
    $user_data = $db->query("SELECT user_id, name, role_id, area_id, email FROM users_m WHERE user_id = {$user_data[0]['user_id']}");

    //Don't know if it will be really useful since main checks it but who knows
    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    //Temporary storing
    $out = $user_data[0];

    $out['role'] = explode(",",$out['role_id']);

    foreach ($out['role'] as $posi => $role)
        $out['role'][$posi] = (int) $role;

    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id']))
        $out['area_id'] = $db->query("SELECT area_name FROM areas_m WHERE area_id = {$out['area_id']}")[0]['area_name'];

    //Make a new correct response
    $out = [
        'email' => $out['email'],
        'role' => $out['role'],
        'area' => $out['area_id'],
        'user_id' => $out['user_id'],
        'name' => $out['name']
    ];

    return $out;
}
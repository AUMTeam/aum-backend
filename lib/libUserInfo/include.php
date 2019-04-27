<?php

function getMyInfo(string $token) : array {
    global $db;
    $out = [];

    $user_id = $db->preparedQuery("SELECT user_id FROM users_tokens WHERE token=?", [$token]);

    if (count($user_id) > 0)
        $out = getUserInfo($user_id[0]['user_id']);
    else
        throw new InvalidTokenException();

    return $out;
}

function getUserInfo(int $user_id) : array {
    global $db;

    //Retrive data from the DB
    $user_data = $db->preparedQuery("SELECT user_id, name, area_id, email FROM users WHERE user_id=?", [$user_id]);

    if(count($user_data) == 0)
        throw new UserNotFoundException("User not found");

    //Temporary storing
    $out = $user_data[0];
    $out['resp'] = [];

    //Get the list of roles
    $roles = $db->preparedQuery("SELECT role_id FROM users_roles WHERE user_id=?", [$user_id]);
    for($i=0; $i < count($roles); $i++)
       $out['role_id'][$i] = (int) $roles[$i]['role_id'];

    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id'])) {
        $out['area_name'] = $db->preparedQuery("SELECT area_name FROM areas WHERE area_id=?", [$out['area_id']])[0]['area_name'];

        //Gets the tech area boss
        $tech = $db->preparedQuery("SELECT users.user_id, name, email FROM users, users_roles WHERE 
            users.user_id=users_roles.user_id AND area_id=? AND role_id=?", [$out['area_id'], 2]);
        
        foreach($tech as $entry) {
            $arr = [
                'email' => $entry['email'],
                'user_id' => $entry['user_id'],
                'name' => $entry['name']
            ]; 
            array_push($out['resp'], $arr);
        }
    }

    //Make a new correct response
    $out = [
        'email' => $out['email'],
        'role' => $out['role_id'],
        'area' => $out['area_id'],
        'user_id' => $out['user_id'],
        'name' => $out['name'],
        'resp' => $out['resp']
    ];

    return $out;
}
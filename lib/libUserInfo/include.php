<?php

/**
 * Get the current user infos given its token
 */
function getMyInfo() : array {
    global $db;
    global $token;
    $out = [];

    $user_id = $db->preparedQuery("SELECT user_id FROM users_tokens WHERE token=?", [$token]);

    if (count($user_id) == 1)
        $out = getUserInfo($user_id[0]['user_id']);
    else
        throw new InvalidTokenException();

    return $out;
}

/**
 * Get the infos of an user with a defined user_id
 */
function getUserInfo(int $user_id) : array {
    global $db;

    //Retrive data from the DB
    $query = $db->preparedQuery("SELECT user_id, username, name, area_id, email FROM users WHERE user_id=?", [$user_id]);

    if(count($query) == 0)
        throw new UserNotFoundException("User not found");
    $query = $query[0];
    
    //Prepopulate the response array
    $out = [
        'user_id' => $query['user_id'],
        'username' => $query['username'],
        'name' => $query['name'],
        'email' => $query['email'],
        'role' => [],
        'role_name' => [],
        'resp' => [],
        'area_id' => $query['area_id']
    ];

    //Get the list of roles
    $roles = $db->preparedQuery("SELECT roles.role_id, role_name FROM users_roles, roles
        WHERE roles.role_id=users_roles.role_id AND user_id=?", [$user_id]);
    for($i=0; $i < count($roles); $i++) {
       $out['role'][$i] = (int) $roles[$i]['role_id'];
       $out['role_name'][$i] = $roles[$i]['role_name'];
    }

    //A tech area member is automatically a developer
    if (in_array(ROLE_TECHAREA, $out['role_name'])) {
        $out['role'][] = 1;
        $out['role_name'][] = ROLE_DEVELOPER;
    }


    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id'])) {
        $out['area_name'] = $db->preparedQuery("SELECT area_name FROM areas WHERE area_id=?", [$out['area_id']])[0]['area_name'];

        //Gets the tech area members for the current user
        $tech = $db->preparedQuery("SELECT users.user_id FROM users, users_roles WHERE 
            users.user_id=users_roles.user_id AND area_id=? AND role_id=?", [$out['area_id'], 2]);
        
        foreach($tech as $entry) {
            $out['resp'][] = $entry['user_id'];
        }
    }

    return $out;
}

/**
 * Returns the list of user_id having the same role
 */
function getUserIdByRole(string $role_name) : array {
    global $db;
    $out = [];

    $query = $db->preparedQuery("SELECT users.user_id as 'id' FROM users, users_roles, roles
        WHERE roles.role_id=users_roles.role_id AND users.user_id=users_roles.user_id AND role_name=?", [$role_name]);

    foreach($query as $entry)
        $out[] = $entry['id'];

    return $out;
}
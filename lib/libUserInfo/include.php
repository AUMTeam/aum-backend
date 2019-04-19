<?php


function getUserData(DatabaseWrapper $db, string $token, array $data = []) : array {
    //Keep selected user_id if it's present, else extract it starting from the token
    if(isset($data['user_id']))
        $user_data[0]['user_id'] = $data['user_id'];
    else
        $user_data = $db->preparedQuery("SELECT user_id FROM users_tokens WHERE token=?", [$token]);  //FIXME: Duplicated

    //TODO: Needed? (And others)
    if(count($user_data) == 0)
        throw new UserNotFoundException("User not found");

    //Retrive data from the DB
    $user_data = $db->preparedQuery("SELECT user_id, name, area_id, email FROM users WHERE user_id=?", [$user_data[0]['user_id']]);

    if(count($user_data) == 0)
        throw new UserNotFoundException("User not found");

    //Temporary storing
    $out = $user_data[0];

    $roles = $db->preparedQuery("SELECT role_id FROM users_roles WHERE user_id=?", [$user_data[0]['user_id']]);
    for($i=0; $i < count($roles); $i++)
       $out['role_id'][$i] = (int) $roles[$i]['role_id'];

    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id']))
        $out['area_id'] = $db->preparedQuery("SELECT area_name FROM areas WHERE area_id=?", [$out['area_id']])[0]['area_name'];

    //Make a new correct response
    $out = [
        'email' => $out['email'],
        'role' => $out['role_id'],
        'area' => $out['area_id'],
        'user_id' => $out['user_id'],
        'name' => $out['name']
    ];

    return $out;
}
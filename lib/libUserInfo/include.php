<?php


function getUserData(DatabaseWrapper $db, string $token, array $data = []) : array {
    //Keep selected user_id if it's present, else extract it starting from the token
    if(isset($data['user_id']))
        $user_data[0]['user_id'] = $data['user_id'];
    else
        $user_data = $db->query("SELECT user_id FROM users_tokens WHERE token = '$token'");  //FIXME: Duplicated

    //TODO: Needed? (And others)
    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    //Retrive data from the DB
    $user_data = $db->query("SELECT user_id, name, area_id, email, role_id FROM users WHERE user_id = {$user_data[0]['user_id']}");

    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    //Temporary storing
    $out = $user_data[0];

    if ($out['role_id'] == 5) $out['role_id'] = [1, 2, 3, 4];
    else $out['role_id'] = [(int) $out['role_id']];

    //Obtaining string for 'area' if needed
    if(!is_null($out['area_id']))
        $out['area_id'] = $db->query("SELECT area_name FROM areas WHERE area_id = {$out['area_id']}")[0]['area_name'];

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
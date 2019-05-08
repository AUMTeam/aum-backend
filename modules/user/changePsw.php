<?php

/**
 * Changes the user's password to the new one
 */
$exec = function (array $data, array $data_init) : array {
    if (empty($data['old_password'] || empty($data['new_password'])))
        throw new InvalidRequestException();
    
    global $user;
    global $db;

    $username;
    if ($user == null || in_array(ROLE_POWERUSER, $user['role_name']) && !empty($data['username']))   //Admin users can modify other users' password
        $username = $data['username'];
    else
        $username = $user['username'];

    //Check if the old password correspond to the saved one
    $result = $db->preparedQuery("SELECT hash_pass FROM users WHERE username=?", [$username]);
    if(!password_verify($data['old_password'], $result[0]['hash_pass']))
        throw new InvalidCredentialsException("Credentials are wrong", "ERROR_LOGIN_INVALID_CREDENTIALS");

    //Change the password
    $db->preparedQuery("UPDATE users SET hash_pass=? WHERE username=?", [password_hash($data['new_password'], PASSWORD_DEFAULT), $username]);

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
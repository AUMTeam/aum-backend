<?php

/**
 * Register a new user into the database
 */
$exec = function (array $data, array $data_init) : array {
    if(empty($data['username']) || empty($data['name']) || empty($data['email']) 
        || empty($data['roles']))
        throw new InvalidRequestException();

    global $db;
    global $user;
    if (!in_array(ROLE_POWERUSER, $user['role_name']))
        throw new UnauthorizedException();

    $db->beginTransaction();
    try {      
        //Get the area_id (not mandatory)
        $area_id = null;
        if (!empty($data['area_name'])) {
            $area_id = $db->preparedQuery("SELECT area_id FROM areas WHERE area_name=?", [$data['area_name']]);
            if (count($role) == 0)
                throw new DBException("Error: unknown area!");
            $area_id = $area_id[0]['area_id'];
        }

        $default_psw = password_hash("cambiami", PASSWORD_DEFAULT);

        $db->preparedQuery("INSERT INTO users(username, hash_pass, name, email, area_id) VALUES (?, ?, ?, ?, ?)", 
            [$data['username'], $default_psw, $data['name'], $data['email'], $area_id]);
        $user_id = $db->getLastInsertId();

        foreach($data['roles'] as $entry) {   //One user can have multiple roles
            $role = $db->preparedQuery("SELECT role_id FROM roles WHERE role_name=?", [$entry]);
            if (count($role) == 0)
                throw new DBException("Error: unknown role!");
            
            $db->preparedQuery("INSERT INTO users_roles(user_id, role_id) VALUES (?, ?)", [$user_id, $role[0]['role_id']]);

        }

        $db->commit();
    } catch (DBException $ex) {
        $db->rollback();
        throw new DBException($ex->getIntMessage(), $ex->getErrorCode(), $ex->getStatusCode());
    }

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
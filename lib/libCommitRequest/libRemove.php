<?php

function remove(string $type, array $data) : void {
    if (empty($data['id']))
        throw new InvalidRequestException("missing id parameter");
    
    //Check if $type is a valid parameter
    $id_name;
    switch ($type) {
        case TYPE_COMMIT:
            $id_name = TYPE_COMMIT_ID;
            break;
        case TYPE_REQUEST:
            $id_name = TYPE_REQUEST_ID;
            break;
        default:
            throw new InvalidRequestException("Impossible to use the endpoint");
    }

    global $user;
    global $db;

    //Only developers can remove commits / send requests
    if (!in_array(ROLE_DEVELOPER, $user['role_name']))
        throw new UnauthorizedException();

    //Get the element
    $elem = $db->preparedQuery("SELECT $id_name, approval_status FROM $type WHERE $id_name=? AND author_user_id=?", [$data['id'], $user['user_id']]);
    
    if (count($elem) == 0)
        throw new InvalidRequestException("ID not found or element already approved", "ERROR_INVALID_ID");
    else if ($elem[0]['approval_status'] != 0)
        throw new InvalidRequestException("Element already approved: you cannot remove it", "ERROR_WRONG_APP_STATUS");

    //If the element is a commit, check if it hasn't already been included in a send request
    if ($type == TYPE_COMMIT) {
        $comm = $db->preparedQuery("SELECT $id_name FROM requests_commits WHERE $id_name=?", [$data['id']]);
        if (count($comm) > 0)
            throw new InvalidRequestException("Commit already included in a send request", "ERROR_REMOVE_COMMIT_ALREADY_INCLUDED");
    }

    $elem = $elem[0][$id_name];

    //Delete the element
    $db->preparedQuery("DELETE FROM $type WHERE $id_name=?", [$elem]);
}

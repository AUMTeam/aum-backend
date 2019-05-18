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

    //Get the element
    $elem = $db->preparedQuery("SELECT $id_name FROM $type WHERE approval_status IN ('0') AND $id_name=?", [$data['id']]);
    if (count($elem) == 0)
        throw new InvalidRequestException("ID not found or element already approved");

    $elem = $elem[0][$id_name];

    //Delete the element
    $db->preparedQuery("DELETE FROM $type WHERE $id_name=?", [$elem]);
}

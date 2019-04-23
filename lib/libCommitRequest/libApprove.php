<?php

function approve($data, $user, $type) {
    global $db;
    
    //Checks fields integrity
    if(!isset($data['id']))
        throw new InvalidRequestException("Commit ID cannot be omitted", 3007);
    if(!isset($data['approve_flag']) || ($data['approve_flag'] != -1 && $data['approve_flag'] != 1))     //1: Approved / -1: Rejected
        throw new InvalidRequestException("Invalid approved flag!", 3007);

    //Check whether the current user is a technical area manager or not
    $user_id = $user['user_id'];
    $role_id = $user['role'];

    //Only Tech Area users (role: 2) and Power Users (role: 5) are authorized to approve commits/requests
    if (!in_array(2, $role_id) && !in_array(5, $role_id))
        throw new InvalidRequestException("The current user is not authorized to perform this action!", 103, 401);    //TODO: New error code?

    $id;
    switch ($type) {
        case "commits":
            $id = "commit_id";
            break;
        case "requests":
            $id = "request_id";
            break;
        default:
            throw new Exception("Impossible to use the endpoint");
    }

    //Check if commit_id is valid and whether the commit has already been approved
    $query = $db->preparedQuery("SELECT is_approved FROM $type WHERE $id=?", [$data['id']]);
    if (count($query) == 0)
        throw new InvalidRequestException("id doesn't refer to a valid commit!", 3007);
    else if ($query[0]['is_approved'] != 0)
        throw new InvalidRequestException("Already approved!", 3007);

    $approvation_comment = "";
    if (isset($data['approvation_comment'])) $approvation_comment = $data['approvation_comment'];


    $db->preparedQuery("UPDATE $type SET is_approved=?, approvation_comment=?, approver_user_id=? WHERE $id=?", [$data['approve_flag'], $approvation_comment, $user_id, $data['id']]);
}
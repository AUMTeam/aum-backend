<?php

/**
 * Approve a commit/request with a specified ID and approval_flag
 */
function approve(array $data, string $type) : void {
    global $db;
    global $user;

    //Check whether the current user is a technical area manager or not
    $user_id = $user['user_id'];
    //Only Tech Area users (role: 2) are authorized to approve commits/requests
    if (!in_array(ROLE_TECHAREA, $user['role_name']))
        throw new UnauthorizedException("The current user is not authorized to perform this action!");

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
            throw new Exception("Impossible to use the endpoint");
    }
    
    //Checks fields integrity
    if(!isset($data['id']))
        throw new InvalidRequestException("Commit ID cannot be omitted", 3007);
    if(!isset($data['approve_flag']) || ($data['approve_flag'] != -1 && $data['approve_flag'] != 1))     //1: Approved / -1: Rejected
        throw new InvalidRequestException("Invalid approved flag!", 3007);
    //Approvation_comment is not mandatory: check if it's present
    $approvation_comment = "";
    if (isset($data['approvation_comment']))
        $approvation_comment = $data['approvation_comment'];

    
    //Check if commit_id is valid and whether the commit has already been approved - $type is safe
    $query = $db->preparedQuery("SELECT is_approved, author_user_id FROM $type WHERE $id_name=?", [$data['id']])[0];
    if (count($query) == 0)
        throw new InvalidRequestException("id doesn't refer to a valid commit!", 3007);
    else if ($query['is_approved'] != 0)
        throw new InvalidRequestException("Already approved!", 3007);


    //Execute the query
    $db->preparedQuery("UPDATE $type SET is_approved=?, approvation_comment=?, approver_user_id=? WHERE $id_name=?", [$data['approve_flag'], $approvation_comment, $user_id, $data['id']]);


    //Send the response to the author
    sendMail($query['author_user_id'], MAIL_APPROVED, $data['id'], $type);

    //In case of send request, send the mail to the Revision Office
    if ($type==TYPE_REQUEST && $data['approve_flag']==1) {
        $revOffice = getUserIdByRole(3);
        
        foreach($revOffice as $entry)
            sendMail($entry, MAIL_NEW_ENTRY, $data['id'], TYPE_REQUEST);
    }
}
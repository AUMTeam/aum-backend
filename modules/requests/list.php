<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 28/11/2018
 * Time: 23:18
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['sort']))
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "request_id"
        ];

    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", 3000);

    if(!isset($data['sort']['order']))
        $data['sort']['order'] = "DESC";

    if(!isset($data['sort']['parameter']))
        $data['sort']['parameter'] = "timestamp";
    else{
        $data['sort']['parameter'] = strtolower($data['sort']['parameter']);
        switch ($data['sort']['parameter']){
            case "id":
                $data['sort']['parameter'] = "request_id";
                break;
            case "description":
                $data['sort']['parameter'] = "description";
                break;
            case "author":
                $data['sort']['parameter'] = "requester";
                break;
            case "approval_status":
                $data['sort']['parameter'] = "is_approved";
                break;
            default:
                throw new InvalidRequestException("Invalid sort parameter");
        }
    }

    return [
        "response_data" => get_list_data("request", $data, $db),
        "status_code" => 200
    ];

};
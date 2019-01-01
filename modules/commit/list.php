<?php

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['sort']))
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "timestamp"
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
                $data['sort']['parameter'] = "commit_id";
                break;
            case "description":
                $data['sort']['parameter'] = "description";
                break;
            case "timestamp":
                $data['sort']['parameter'] = "timestamp";
                break;
            case "author":
                $data['sort']['parameter'] = "author_user_id";
                break;
            case "approval_status":
                $data['sort']['parameter'] = "is_approved";
                break;
            default:
                throw new InvalidRequestException("Invalid sort parameter");
        }
    }

    return [
        "response_data" => get_list_data("commit", $data, $db),
        "status_code" => 200
    ];

};
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

    return [
        "response_data" => get_list_data("request", $data, $db),
        "status_code" => 200
    ];

};
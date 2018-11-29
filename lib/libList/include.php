<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 28/11/2018
 * Time: 23:15
 */

function to_int($i) : int {
    return (int) $i;
}

function get_list_data(string $type, array $data, DatabaseWrapper $db){

    $req = $data;

    switch ($type){
        case "commit":
        case "COMMIT":
            $data = $db->query(
            "SELECT users_m.username, commit_m.*
             FROM commit_m, users_m
             WHERE commit_m.author_user_id = users_m.user_id
             ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
            );
            $id = "commit_id";
            $author = "author_user_id";
            break;
        case "request":
        case "REQUEST":
            if($data['sort']['parameter'] == "timestamp")
                $data['sort']['parameter'] = "request_id";
            $data = $db->query(
            "SELECT users_m.username, requests_m.*
             FROM requests_m, users_m
             WHERE requests_m.requester = users_m.user_id
             ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
            );
            $id = "request_id";
            $author = "requester";
            break;
        default:
            throw new Exception("Impossible to use the list");

    }

    $out = [
        'count' => 0,
        'count_total' => count($data),
        'list' => [],
        'page' => $req['page'],
        'page_total' => 0
    ];

    $max_page = count($data) / $req['limit'];

    if(is_float($max_page))
        $max_page = to_int($max_page) + 1;

    $out['page_total'] = $max_page;

    for( $i=($req['page'] * $req['limit']); $i<(($req['page']+1) * $req['limit']); $i++ ) {
        $entry = $data[$i];

        if ($entry == NULL)
            break;

        $temp = [
            'id' => $entry[$id],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['timestamp']),
            'approval_status' => $entry['is_approved'],
            'author' => [
                'user_id' => $entry[$author],
                'username' => $entry['username']
            ]
        ];

        if(!is_null($temp['description']))
            $temp['description'] = base64_decode($temp['description']);

        $out['list'][] = $temp;
    }

    $out['count'] = count($out['list']);

    return $out;
}
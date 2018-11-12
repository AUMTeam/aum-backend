<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 12/11/2018
 * Time: 15:48
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['latest_commit_timestamp']))
        throw new InvalidRequestException("latest_commit_timestamp cannot be blank", 3001);

    $time = date("Y-m-d H:i:s", $data['latest_commit_timestamp']);

    $data = $db->query(
        "SELECT users_m.username, commit_m.*
        FROM commit_m, users_m
        WHERE commit_m.author_user_id = users_m.user_id AND commit_m.timestamp > '$time' 
        ORDER BY commit_m.timestamp DESC"
    );

    if(is_null($data) || is_bool($data) || count($data) == 0)
        throw new NotEditedException();

    $out = [
        'count' => 0,
        'commit_list' => []
    ];

    foreach ($data as $entry)
        $out['commit_list'][] = [
            'id' => $entry['commit_id'],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['timestamp']),
            'author' => [
                'user_id' => $entry['author_user_id'],
                'username' => $entry['username']
            ]
        ];

    $out['count'] = count($out['commit_list']);

    /*
    //One-step token erasing
    $data = $db->query("SELECT * FROM areas_m");

    $out = [];

    foreach ($data as $entry)
        $out[] = [
            'area_id' => $entry['area_id'],
            'area_string' => $entry['area_string']
        ];

    $out = [
        'count' => 2,
        'commit_list' => [
            [
                'id' => "oofFoo",
                'desc' => "A sample of a commit",
                'timestamp' => 0,
                'author' => [
                    'user_id' => 1,
                    'username' => "Mario"
                ]
            ],
            [
                'id' => "fooOOF",
                'desc' => "A sample commit",
                'timestamp' => 0,
                'author' => [
                    'user_id' => 2,
                    'username' => "Luigi"
                ]
            ]
        ]
    ];*/

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};
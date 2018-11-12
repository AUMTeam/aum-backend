<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 05/11/2018
 * Time: 19:17
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    /**
     *CREATE TABLE `commit_m` (
    `commit_id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `timestamp`	TIMESTAMP NOT NULL DEFAULT (datetime('now','localtime')),
    `author_user_id`	INTEGER NOT NULL,
    `is_approved`	INTEGER DEFAULT 0
    );
     */

    if(!isset($data['sort']))
        throw new InvalidRequestException("sort cannot be blank", 3002);

    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['sort']['order']))
        $data['sort']['order'] = "DESC";

    if(!isset($data['sort']['parameter']))
        $data['sort']['order'] = "timestamp";

    $data = $db->query(
        "SELECT users_m.username, commit_m.*
        FROM commit_m, users_m
        WHERE commit_m.author_user_id = users_m.user_id
        ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
    );

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

    /**$out = [
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
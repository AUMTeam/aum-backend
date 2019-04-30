<?php

$exec = function (array $data, array $data_init) : array {
    //Return the token's expiration date
    return [
        "response_data" => [
            "token_expire" => getTokenExpire()
        ],
        "status_code" => 200
    ];
};
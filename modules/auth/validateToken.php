<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:11
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    //Token is already checked by main. Just return an empty object and an OK status.
    return [
        "response_data" => [],
        "status_code" => 200
    ];
};
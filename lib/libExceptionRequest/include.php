<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:25
 */

abstract class ExceptionRequest extends Exception {

    protected $message;
    protected $error_code;
    protected $status_code;

    public function __construct(string $message = "", int $error_code = 0, int $status_code = 400)
    {
        parent::__construct($message, 0, null);
        $this->status_code = $status_code;
        $this->message = $message;
        $this->error_code = $error_code;
    }

    public function getErrorResponse() : array {
        return [
            "response_data" => [
                'error_code' => $this->error_code,
            ],
            "message" => $this->message,
            "status_code" => $this->status_code
        ];
    }
}

$dir = scandir(__DIR__);

foreach ($dir as $file){
    switch ($file){
        case ".":
        case "..":
            break;
        default:
            #printf(__DIR__ . $file);
            include_once __DIR__ . "/$file";
    }
}
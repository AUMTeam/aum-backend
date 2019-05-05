<?php

/**
 * Basic class for all custom exceptions used in the project
 */
abstract class ExceptionRequest extends Exception {
    protected $message;      //Verbose message
    protected $error_code;   //Internal error code
    protected $status_code;  //HTTP Error Code

    public function __construct(string $message = "", int $error_code = 0, int $status_code = 400) {
        parent::__construct($message, 0, null);
        $this->status_code = $status_code;
        $this->message = $message;
        $this->error_code = $error_code;
    }

    /**
     * Returns the exception parameters in a JSON-like format
     */
    public function getErrorResponse() : array {
        return [
            "response_data" => [
                'error_code' => $this->error_code,
            ],
            "message" => $this->message,
            "status_code" => $this->status_code
        ];
    }

    //Getters

    public function getIntMessage() {
        return $this->message;
    }

    public function getErrorCode() {
        return $this->error_code;
    }

    public function getStatusCode() {
        return $this->status_code;
    }
}

//Include all the child exceptions
$dir = scandir(__DIR__);
foreach ($dir as $file) {
    switch ($file) {
        case ".":
        case "..":
        case "include.php":
            break;
        default:
            require_once __DIR__ . "/$file";
    }
}
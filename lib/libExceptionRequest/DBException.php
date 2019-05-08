<?php

class DBException extends ExceptionRequest {

    public function __construct(string $message, string $error_code = "ERROR_GLOBAL_DB", int $status_code = 500) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
<?php

class InvalidCredentialsException extends ExceptionRequest {

    public function __construct(string $message, int $error_code = 1000, int $status_code = 401) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
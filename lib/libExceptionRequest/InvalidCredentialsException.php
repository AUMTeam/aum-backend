<?php

class InvalidCredentialsException extends ExceptionRequest {

    public function __construct(string $message, string $error_code = "ERROR_LOGIN_INVALID_CREDENTIALS", int $status_code = 401) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }

}
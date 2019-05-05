<?php

class InvalidRequestException extends ExceptionRequest {

    public function __construct(string $message = "Invalid Request", string $error_code = "ERROR_GLOBAL_USER_NOT_FOUND", int $status_code = 400) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
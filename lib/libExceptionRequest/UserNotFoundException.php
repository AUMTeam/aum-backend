<?php

class UserNotFoundException extends ExceptionRequest {
    
    public function __construct(string $message = "", string $error_code = "ERROR_USER_INFO_NOT_FOUND", int $status_code = 404) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
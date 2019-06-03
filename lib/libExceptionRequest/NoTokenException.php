<?php

class NoTokenException extends ExceptionRequest {
    
    public function __construct(string $message = "Token is missing", string $error_code = "ERROR_GLOBAL_MISSING_TOKEN", int $status_code = 401) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }

}
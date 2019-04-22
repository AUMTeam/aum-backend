<?php

class UnauthorizedException extends ExceptionRequest {

    public function __construct(string $message, int $error_code = 104, int $status_code = 403) {
        if (is_null($message))
            $message = "Unauthorized!";
        
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
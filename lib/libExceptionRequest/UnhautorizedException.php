<?php

class UnauthorizedException extends ExceptionRequest {
    
    public function __construct(string $message = "Unhautorized!", int $error_code = 104, int $status_code = 403) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
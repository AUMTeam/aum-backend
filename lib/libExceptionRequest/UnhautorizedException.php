<?php

class UnauthorizedException extends ExceptionRequest {
    
    public function __construct(string $message = "Unhautorized!", string $error_code = "ERROR_GLOBAL_UNAUTHORIZED", int $status_code = 403) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
<?php

class NotEditedException extends ExceptionRequest {
    public function __construct(string $message = "", int $error_code = 3008, int $status_code = 304)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }
}
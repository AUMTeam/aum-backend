<?php

class NotImplementedException extends ExceptionRequest
{

    public function __construct(string $message, int $error_code = 102, int $status_code = 404)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }

}
<?php

class NotEditedException extends ExceptionRequest {

    public function __construct(string $message = "", string $error_code = "ERROR_COMMIT_LIST_NO_PAGE", int $status_code = 304) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
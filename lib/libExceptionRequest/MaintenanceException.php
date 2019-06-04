<?php

class MaintenanceException extends ExceptionRequest {

    public function __construct(string $message = "Server in manutenzione", string $error_code = "ERROR_SRV_IN_MAINTENANCE", int $status_code = 503) {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array {
        return parent::getErrorResponse();
    }
}
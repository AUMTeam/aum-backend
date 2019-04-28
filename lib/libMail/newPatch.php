<?php

/**
 * Mail to inform client of the presence of a new update of the app
 */
class NewPatchMail extends AbstractMail {

    public function __construct(string $from, string $to) {
        parent::__construct($from, $to);
    }

    public function getSubject() : string {
        return "IBT - Nuova Patch";
    }

    public function getTitle() : string {
        return "Nuovo aggiornamento disponibile";
    }
    
    public function getContent() : string {
        return "<b>Gentile $this->to, un nuovo aggiornamento è disponibile per l'installazione</b>";
    }

    public function getMsg() : string {
        return parent::getMsg();
    }
}
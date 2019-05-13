<?php

/**
 * Mail used to communicate that there's a new commit/request to the tech area members
 */
class NewEntryMail extends AbstractMail {
    public function getSubject() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "AUM - Nuovo commit pubblicato da " . $this->from;
        else
            return "AUM - Nuova richiesta di invio pubblicata da " . $this->from;
    }

    public function getTitle() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "$this->from ha pubblicato un nuovo commit";
        else
            return "$this->from ha pubblicato una nuova richiesta di invio";
    }
    
    public function getContent() : string {
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr><td><b>Autore: </b></td><td>$this->from</td></tr>
            </table>";
    }
}
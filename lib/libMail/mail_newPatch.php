<?php

/**
 * Mail to inform client of the presence of a new update of the app
 */
class NewPatchMail extends AbstractMail {
    public function getSubject() : string {
        return "IBT - Nuova Patch";
    }

    public function getTitle() : string {
        return "Gentile $this->to, un nuovo aggiornamento è disponibile per l'installazione";
    }
    
    public function getContent() : string {
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            </table>";
    }
}
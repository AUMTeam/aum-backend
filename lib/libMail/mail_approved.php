<?php

/**
 * Mail for approved commits/send requests
 */
class ApprovedMail extends AbstractMail {
    public function getSubject() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "AUM - Commit Approvato da " . $this->to;
        else
            return "AUM - Richiesta di invio approvata da " . $this->to;
    }

    public function getTitle() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "Un tuo commit è stato approvato";
        else
            return "Una tua richiesta di invio è stata approvata";
    }
    
    public function getContent() : string {
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr><td><b>Approvato da: </b></td><td>$this->from</td></tr>
            </table>";
    }
}
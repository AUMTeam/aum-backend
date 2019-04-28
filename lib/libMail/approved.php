<?php

/**
 * Mail for approved commits/send requests
 */
class ApprovedMail extends AbstractMail {
    private $title;
    private $desc;
    private $typeCommit;

    public function __construct(string $from, string $to, string $typeCommit, string $idType, int $id) {
        parent::__construct($from, $to);
        global $db;

        //Gets title and description from the current commit/sendRequest
        $out = $db->preparedQuery("SELECT title, description FROM $typeCommit WHERE $idType=?", [$id])[0];
        $this->title = $out['title'];
        $this->desc = $out['description'];
        $this->typeCommit = $typeCommit;
    }

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
            <h4>Contenuto:</h4>
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr><td><b>Approvato da: </b></td><td>$this->from</td></tr>
            </table>";
    }
}
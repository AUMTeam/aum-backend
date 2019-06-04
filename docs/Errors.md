# Elenco degli errori

## Codici errore HTTP

I seguenti codici sono riportati sia tramite HTTP che nel campo `status_code` della risposta codificata in JSON.

* `200` - `OK`: Valore di default, la richiesta è andata a buon fine.
* `400` - `Bad Request`: La richiesta non è conforme all’esecuzione. Questo è possibile se la richiesta è stata strutturata in un modo totalmente differente a quella dettata, oppure se mancano uno o più parametri.
* `401` - `Unauthorized`: La richiesta non può essere eseguita per assenza di privilegi. Questo errore viene generato se il token inviato al server non è valido o assente e quando l’username o la password sono errati.
* `403` - `Forbidden`: La richiesta non può essere esaudita per mancanza di privilegi. Questo capita quando un’utente tenta di accedere ad un entry point che solo un particolare gruppo di utenti può utilizzare.
* `404` - `Not Found`, ovvero la richiesta non può essere esaudita perché tale azione non è stata implementata.
* `405` - `Method Not Allowed`: La richiesta è stata effettuata utilizzando metodi HTTP diversi da POST e OPTIONS.
* `500` - `Internal Server Error`: Il server ha riscontrato un problema nel processare l’azione. Se la risposta è codificata in formato JSON, significa che è un errore previsto dall'API; si rimanda alla sezione sottostante per ulteriori spiegazioni. Se la risposta non è un JSON, si tratta di un errore non gestito del sistema.
* `503` - `Service Unavailable`: Il server non è al momento disponibile perché è in stato di manutenzione.


## Codici errore interni

Le API utilizzano un sistema di errori codificati sotto forma di stringa per poter gestire in modo efficiente le eccezioni che possono generarsi nell'esecuzione di un endpoint. In particolare, il codice di errore è contenuto nel campo `error` della risposta:

```json
{
  "response_data":{},
  "error":"ERROR_GLOBAL_SAMPLE_ERROR", //Qua si trova il nostro codice errore
  "message":"Messaggio testuale (facoltativo)",
  "status_code":500
}
```

Di seguito viene fornito l'elenco di tutti i possibili codici di errore. 

## Errori globali
* `100` = `ERROR_GLOBAL_MISSING_TOKEN` - Il token identificativo è assente
* `101` = `ERROR_GLOBAL_INVALID_TOKEN` - Il token identificativo è invalido
* `102` = `ERROR_GLOBAL_NOT_IMPLEMENTED` - L'azione richiesta non è stata implementata
* `103` = `ERROR_GLOBAL_INVALID_REQUEST` - La richiesta è strutturata in modo errato (alcuni parametri sono mancanti)
* `104` = `ERROR_GLOBAL_UNAUTHORIZED` - L'utente non è autorizzato ad eseguire l'endpoint corrente
* `105` = `ERROR_GLOBAL_DB` - Errore interno nella comunicazione con il DB (errore nella connessione o nell'esecuzione di una query)
* `106` = `ERROR_REQUEST_NOT_JSON` - La richiesta non è formattata in JSON
* `107` = `ERROR_INVALID_ID` - L'ID specificato non è valido
* `108` = `ERROR_SRV_IN_MAINTENANCE` - Server in manutenzione

## Modulo `auth/*`
* `200` = `ERROR_LOGIN_INVALID_CREDENTIALS` - Credenziali errate (username o password)

## Modulo `user/*`
* `300` = `ERROR_USER_NOT_FOUND` - Utente non trovato nel sistema

## `commits/list` e `sendRequests/list`
* `401` = `ERROR_LIST_INVALID_PARAMETER` - Il parametro utilizzato per la ricerca o per l'ordinamento non è valido

## `commits/remove` e `sendRequests/remove`
* `500` = `ERROR_REMOVE_COMMIT_ALREADY_INCLUDED` - Il commit è già stato incluso in una richiesta di invio
* `501` = `ERROR_REMOVE_ALREADY_APPROVED` - L'elemento è già stato approvato da un referente di area tecnica e dunque non può essere eliminato

## `commits/approve` e `sendRequests/approve`
* `600` = `ERROR_APPROVE_ALREADY_APPROVED` - L'elemento è già stato approvato in precedenza da un referente di area tecnica

## `sendRequests/send`
* `700` = `ERROR_SEND_NOT_APPROVED` - La richiesta di invio è presente nel DB ma non è ancora stata approvata da un referente di area tecnica

## `sendRequests/install`
* `800` = `ERROR_INSTALL_PATCH_NOT_SENT` - La richiesta di invio è presente nel DB ma non è ancora inviata dall'ufficio revisioni, dunque non è possibile esprimere un feedback
# Lista codici errore

Lista codici errore. I codici errore possono essere trovati qua:

```json
{
  "response_data":{},
  "error":"ERROR_GLOBAL_SAMPLE_ERROR", //Qua si trova il nostro codice errore
  "message":"Messaggio testuale (facoltativo)",
  "status_code":500
}
```

## Errori globali
* `100` = `ERROR_GLOBAL_MISSING_TOKEN` - Il token identificativo è assente
* `101` = `ERROR_GLOBAL_INVALID_TOKEN` - Il token identificativo è invalido
* `102` = `ERROR_GLOBAL_NOT_IMPLEMENTED` - L'azione richiesta non è stata implementata
* `103` = `ERROR_GLOBAL_INVALID_REQUEST` - La richiesta è strutturata in modo errato (alcuni parametri sono mancanti)
* `104` = `ERROR_GLOBAL_UNAUTHORIZED` - L'utente non è autorizzato ad eseguire l'endpoint corrente
* `105` = `ERROR_GLOBAL_DB` - Errore interno nella comunicazione con il DB (errore nella connessione o nell'esecuzione di una query)
* `106` = `ERROR_REQUEST_NOT_JSON` - La richiesta non è formattata in JSON
* `107` = `ERROR_INVALID_ID` - L'ID specificato non è valido
* `108` = `ERROR_SRV_IN_MANITEANCE` - Server in manutenzione

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
# Lista codici errore

Lista codici errore. I codici errore possono essere trovati qua:

```json
{
  "response_data":{},
  "error":"ERROR_GLOBAL_SAMPLE_ERROR", //Qua si trova il nostro codice errore
  "status_code":500
}
```

## `global`

* `100` = `ERROR_GLOBAL_MISSING_TOKEN` - Il token identificativo è assente
* `101` = `ERROR_GLOBAL_INVALID_TOKEN` - Il token identificativo è invalido
* `102` = `ERROR_GLOBAL_NOT_IMPLEMENTED` - L'azione richiesta non è stata implementata
* `103` = `ERROR_GLOBAL_USER_NOT_FOUND` - L'utente non è stato trovato

## `auth/*` module

* `1000` = `ERROR_LOGIN_INVALID_CREDENTIALS` - Credenziali errate
* `1001` = `ERROR_LOGIN_INVALID_REQUEST` - Richiesta (parametri) invalida

## `user/*` module
* `2000` = `ERROR_USER_INFO_NOT_FOUND` - Utente non trovato nel sistema

## `commit / send requests` list

* `3000` = `ERROR_LIST_NO_LIMIT` - Il limite dei commit da visualizzare non può essere assente
* `3001` = `ERROR_COMMIT_INFO_INVALID_REQUEST` - La richiesta per le info del commit è invalida
* `3002` = `ERROR_LIST_NO_PAGE` - Il numero della pagina non può essere omesso
* `3003` = `ERROR_LIST_INVALID_PARAMETER` - Il parametro utilizzato per la ricerca o per l'ordinamento non è valido

## `commit / send requests approve`

* `4000` = `ERROR_APPROVE_ALREADY_APPROVED` - L'elemento è già stato approvato
* `4001` = `ERROR_APPROVE_INVALID_ID` - L'ID inviato non è valido
* `4002` = `ERROR_COMMIT_APPROVE_INVALID_REQUEST` - La richiesta per l'approvazione del commit è invalida

## `commit / send requests remove`

* `5000` = `ERROR_REMOVE_INVALID_ID` - L'ID inviato non è valido
* `5001` = `ERROR_REMOVE_COMMIT_ALREADY_INCLUDED` - Il commit è già stato incluso in una richiesta di invio

## `commit / send requests update`

* `6001` = `ERROR_UPDATE_NO_TIMESTAMP` - Il timestamp di riferimento non può essere assente


#### PATTERN DOCUMENTAZIONE
* `X` = `Y`
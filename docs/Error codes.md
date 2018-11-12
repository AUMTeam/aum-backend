# Lista codici errore

Lista codici errore. I codici errore possono essere trovati qua:

```json
{
  "response_data":{
    "error_code":100 //Qua si trova il nostro codice errore
  },
  "status_code":401
}
```

## `global`

* `100` = `ERROR_GLOBAL_MISSING_TOKEN` - Il token identificativo è assente
* `101` = `ERROR_GLOBAL_INVALID_TOKEN` - Il token identificativo è invalido
* `102` = `ERROR_GLOBAL_NOT_IMPLEMENTED` - L'azione richiesta non è stata implementata
* `103` = `ERROR_GLOBAL_BLOCKED_USER` - L'utente è stato bloccato dall'amministratore (unused?)
* `104` = `ERROR_GLOBAL_USER_NOT_FOUND` - L'utente non è stato trovato

## `auth/*` module

* `1000` = `ERROR_LOGIN_INVALID_CREDENTIALS` - Credenziali errate (login/access)
* `1001` = `ERROR_LOGIN_INVALID_REQUEST` - Richiesta (parametri) invalida (login/access)
* `1002` = `ERROR_LOGIN_INVALID_TOKEN` - Token non valido (login/auth)
* `1003` = `ERROR_LOGIN_BLOCKED_USER` - L'utente è stato bloccato dall'amministratore (auth/login) (unused?)

## `user/*` module
* `2000` = `ERROR_USER_INFO_NOT_FOUND` - Utente non trovato nel sistema
* `2001` = `ERROR_USER_INVALID_REQUEST` - user_id non fornito nella richiesta

## `commit/*` module

* `3000` = `ERROR_COMMIT_LIST_NO_LIMIT` - Il limite dei commit da visualizzare non può essere assente
* `3001` = `ERROR_COMMIT_UPDATE_NO_TIMESTAMP` - Il timestamp di riferimento non può essere assente
* `3002` = `ERROR_COMMIT_LIST_NO_SORT` - Il tipo di sort deve essere specificato
* `3003` = `ERROR_COMMIT_LIST_INVALID_SORT` - I parametri del sort inviati non sono validi
* `3004` = `ERROR_COMMIT_INFO_COMMIT_NOT_FOUND` - Il commit selezionato non esiste (info)
* `3005` = `ERROR_COMMIT_APPROVE_COMMIT_NOT_FOUND` - Il commit selezionato non esiste (approve)
* `3006` = `ERROR_COMMIT_INFO_INVALID_REQUEST` - La richiesta per le info del commit è invalida
* `3007` = `ERROR_COMMIT_APPROVE_INVALID_REQUEST` - La richiesta per l'approvazione del commit è invalida
* `3008` = `ERROR_COMMIT_UPDATE_NO_UPDATES` - Non vi sono nuovi commit


#### PATTERN DOCUMENTAZIONE
* `X` = `Y`
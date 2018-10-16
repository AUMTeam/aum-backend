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

## `auth/*` module

* `1000` = `ERROR_LOGIN_INVALID_CREDENTIALS` - Credenziali errate (login/access)
* `1001` = `ERROR_LOGIN_INVALID_REQUEST` - Richiesta (parametri) invalida (login/access)
* `1002` = `ERROR_LOGIN_INVALID_TOKEN` - Token non valido (login/auth)
* `1002` = `ERROR_LOGIN_BLOCKED_USER` - L'utente è stato bloccato dall'amministratore (auth/login) (unused?)

## `user/*` module
* `2000` = `ERROR_USER_INFO_NOT_FOUND` - Utente non trovato nel sistema
* `2001` = `ERROR_USER_INVALID_REQUEST` - user_id non fornito nella richiesta

#### PATTERN DOCUMENTAZIONE
* `X` = `Y`
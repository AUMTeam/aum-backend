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

## `global`
* `100` = `ERROR_GLOBAL_MISSING_TOKEN` - Il token identificativo è assente
* `101` = `ERROR_GLOBAL_INVALID_TOKEN` - Il token identificativo è invalido
* `102` = `ERROR_GLOBAL_NOT_IMPLEMENTED` - L'azione richiesta non è stata implementata
* `103` = `ERROR_GLOBAL_INVALID_REQUEST` - La richiesta è strutturata in modo errato (alcuni parametri sono mancanti)
* `104` = `ERROR_GLOBAL_UNAUTHORIZED` - L'utente non è autorizzato ad eseguire l'endpoint corrente
* `105` = `ERROR_REQUEST_NOT_JSON` - La richiesta non è formattata in JSON
* `106` = `ERROR_INVALID_ID` - L'ID specificato non è valido
* `107` = `ERROR_WRONG_APP_STATUS` - Lo stato di approvazione dell'elemento specificato non può essere usato con l'endpoint corrente
* `108` = `ERROR_SRV_IN_MANITEANCE` - Server in manutenzione

## `auth/*` module
* `1000` = `ERROR_LOGIN_INVALID_CREDENTIALS` - Credenziali errate (username o password)

## `user/*` module
* `2000` = `ERROR_USER_NOT_FOUND` - Utente non trovato nel sistema

## `commit / send requests` list
* `3001` = `ERROR_LIST_INVALID_PARAMETER` - Il parametro utilizzato per la ricerca o per l'ordinamento non è valido

## `commit / send requests remove`
* `4000` = `ERROR_REMOVE_COMMIT_ALREADY_INCLUDED` - Il commit è già stato incluso in una richiesta di invio
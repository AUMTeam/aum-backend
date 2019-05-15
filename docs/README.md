# Authorization Manager API
## A cosa ci serve?
Serve a comunicare con il server per vari cambiamenti di dati o accessi avvenuti tramite client (nel nostro caso web-application).

## Installazione e configurazione iniziale
Vedere il file 'Setup.md'

## Struttura dati richiesta e risposta
Vi sono due vie per creare la richiesta:
1. **Richiesta codificata in JSON**
	I parametri "module" ed "action" sono obbligatori:
	```json
		POST aum.altervista.org/main.php
		{
			"module":"auth",
			"action":"login",
			"request_data":{
				"username":"mario.rossi",
				"password":"mario"
			}
		}
	```
2. **Richiesta ad un modulo specifico**
	In questo caso "module" ed "action" sono specificati direttamente nell'URL:
	```json
		POST aum.altervista.org/main.php/auth/login
		{
			"request_data":{
				"username":"mario.rossi",
				"password":"mario"
			}
		}
	```

La risposta, invece, sarà necessariamente un JSON. La struttura di default delle risposte è:
```json
{
	"response_data":[],
	"status_code":200,
	"message":"",
	"dev_message":""
}
```
Per la spiegazione dei vari parametri, andare nella sezione `Parametri di risposta`.

## Parametri di richiesta

* **module**: insieme di "azioni" con uno stesso scopo (esempio: `commit` per add,list,update,...)
* **action**: azione che l'utente intende eseguire (esempio: `list`)
* **request_data**: serie di dati strutturati come richiesto dall’entrypoint (può anche essere vuoto)

Per la definizione di tutte le richieste e risposte si rimanda al file ```API Requests-Responses```

## Parametri di risposta
I parametri **obbligatori** della risposta sono:

* `response_data` : i dati della risposta ottenuti dalla propria richiesta
* `status_code` : in questo campo viene riportato il codice HTTP della risposta. Di default, se tutto è andato bene, il valore è `200` (`HTTP 200 OK`). In caso contrario, verranno usati diversi valori. Per un approfondimento si rimanda alla sezione `Errori - Codici errore HTTP server`.

I parametri opzionali sono:

* `message` : messaggio di errore
* `dev_message` : messaggio utilizzato in fase di sviluppo. Mostra informazioni più dettagliate rispetto al primo


## Errori

### Codici errore HTTP

Nella sezione `Parametri di risposta` è stato introdotto il parametro `status_code` che non è altro che l’HTTP code della richiesta. Elenchiamo tutti i codici utilizzati:

* `200` : `OK`. Valore di default, la richiesta è andata a buon fine (in teoria).
* `400` : `Bad Request`, ovvero la richiesta non è conforme all’esecuzione. Questo è possibile se la richiesta è stata strutturata in un modo totalmente differente a quella dettata, oppure se mancano uno o più parametri.
* `401` : `Unauthorized`, ovvero la richiesta non può essere eseguita per assenza di privilegi. Questo capita se il token inviato al server non è valido oppure assente. Inoltre, è usato quando l’username o la password sono errati.
* `403` : `Forbidden`, ovvero la richiesta non può essere esaudita per privilegi inferiori a quelli richiesti per l’azione. Questo capita, per esempio, quando un’utente base tenta di accedere a entry point dove solo i privilegiati possono usufruire di tale accesso.
* `404` : `Not Found`, ovvero la richiesta non può essere esaudita perché tale azione non è stata implementata (al momento).
* `405` : `Method Not Allowed`, ovvero la richiesta viene automaticamente bloccata se il metodo della richiesta non è POST.
* `500` : `Internal Server Error`, ovvero il server ha riscontrato un problema nella processione dell’azione. Se la risposta corrisponde a un JSON, significa che è un errore dell'API. Tale errore può essere rintracciato se segnato l’ID errore univoco ricevuto. In caso di sviluppo e manutenzione, è possibile ottenere uno stack trace dell’eccezione. Se la risposta non è un JSON, si tratta di un errore interno del sistema del server per problemi di varia natura.
* `503` : `Service Unavailable`, ovvero il server non è al momento disponibile per motivi di manutenzione. E' tuttavia possibile bypassarlo tramite un parametro e un account abilitato a fare questo tipo di test per motivi di sicurezza.

## Come andiamo a implementare le azioni per l’API?
Per l’implementazione di un’azione bisogna tenere in mente il seguente pattern directory:
```
* main.php
* multi.php
* lib/
- * libDatabase/
(...)
* modules/
- * login/
- - * auth.php
- - * access.php
(...)
```

I nomi dei moduli sono le cartelle che contengono i codici delle azioni possibili fare per il server. In codice PHP si traduce in:
```php
<?php

require_once “./modules/$module/$action.php”;
```

Affinché sia possibile usufruire dell’entrypoint `multi.php` dobbiamo rendere le azioni più modulari possibile. E questo è possibile grazie alle funzioni anonime salvate in una variabile.

Il pattern da seguire sarà: 
```php
$init = function (array $data) {
	//Usato per inizializzare qualcosa necessaria prima di eseguire la funzione sottostante. Pertanto, la sua esistenza non è obbligatoria se questo non è necessario.
}

$exec = function (array $data, array $init_data = NULL) : array {
	//Questa è la funzione necessaria per eseguire qualunque cosa debba fare l’azione.
}
``` 

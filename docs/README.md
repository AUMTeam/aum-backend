# Authorization Manager API

## Installazione e configurazione iniziale
Si rimanda al file [Setup](setup/Setup.md)

## Struttura del progetto
Il progetto è strutturato nel seguente modo:
```
* main.php
* multi.php
* lib/
- * libDatabase/
(...)
* modules/
- * auth/
- - * login.php
- - * logout.php
(...)
```
Le richieste sono possibili specificando un particolare **modulo** (insieme di azioni con uno stesso scopo, come *auth*) e di un'**azione** (operazione che si intende eseguire, come *login*).


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

* **module**: insieme di "azioni" con uno stesso scopo (esempio: `commits` per add,list,update,...)
* **action**: azione che l'utente intende eseguire (esempio: `list`)
* **request_data**: serie di dati strutturati come richiesto dall’entrypoint (può anche essere vuoto)

Per la definizione di tutte le richieste e risposte si rimanda al file [Messages](Messages.md)

## Parametri di risposta
I parametri **obbligatori** della risposta sono:

* `response_data` : contiene i dati restituiti in base alla richiesta effettuata
* `status_code` : qui viene riportato il codice HTTP di risposta. Se tutto è andato correttamente, il valore sarà `200`. In caso contrario, verranno usati diversi valori; si rimanda al file [Errors](Errors.md) per un approfondimento.

I parametri opzionali sono:

* `error` : codice di errore sotto forma di stringa (es: ERROR_INVALID_REQUEST)
* `message` : descrizione testuale dell'errore
* `dev_message` : contiene informazioni più dettagliate rispetto al precedente

## Implementazione di nuove azioni

I nomi dei moduli sono le cartelle che contengono i codici delle azioni possibili fare per il server. In codice PHP si traduce in:
```php
<?php

require_once “./modules/$module/$action.php”;
```

Le azioni devno essere il più modulari possibile. E questo è possibile grazie alle funzioni anonime salvate in una variabile.

Il pattern da seguire sarà: 
```php
$init = function (array $data) {
	//Usato per inizializzare qualcosa necessaria prima di eseguire la funzione sottostante. Pertanto, la sua esistenza non è obbligatoria se questo non è necessario.
}

$exec = function (array $data, array $init_data = NULL) : array {
	//Questa è la funzione necessaria per eseguire qualunque cosa debba fare l’azione.
}
``` 

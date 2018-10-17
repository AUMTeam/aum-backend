# API STRUTTURA AUM COOPERATIVA
## Cosa ci serve?
Serve a comunicare con il server per vari cambiamenti di dati o accessi avvenuti tramite client (nel nostro caso web-application).

## Struttura dati richiesta e risposta
Vi sono due vie per creare la richiesta:
1. **Richiesta completamente in JSON**: La richiesta sarà completamente in JSON e verrà parsato solo nel server e serviranno dei parametri essenziali:
```json
{
	“module”:”login”,
	“action”:”access”,
	“request_data”:{}
}
```
2. **Richiesta con parametri POST per valori essenziali e gli elementi da elaborare in JSON**: La richiesta utilizzerà più parametri POST rispetto a prima ma velocizzerà il parsing delle variabili necessarie per il richiamo delle funzioni da eseguire. L’unico parametro ad avere una struttura JSON è appunto quella riservata ai dati
```ini
module=login
access=access
request_data={}
```

La risposta, invece, dovrà essere **obbligatoriamente** un JSON, in modo tale che l’applicazione riesca a parsarlo e a ottenere i dati. La struttura di default delle risposte sarà:
```json
{
	“response_data”:{},
	“status_code”:200,
	“message”:””,
	“dev_message”:””
}
```
Per la spiegazione dei vari parametri, andare nella sezione `Parametri di risposta`.

## Parametri di richiesta
Prima abbiamo visto degli esempi di richieste e tale struttura sarà quella usata come standard. Ora analizziamo tali parametri:

* **module**: serie di “azioni” raggruppati denominati in modo tale che rappresenti il loro scopo (esempio: `login`)
* **action**: azione che un utente vuole eseguire richiamando l’API (esempio: `access`)
* **request_data**: serie di dati organizzati come l’entrypoint chiede in modo tale che l’operazione possa essere eseguita (può essere anche che non vi siano dati se proprio non sono richiesti. Tuttavia, tale parametro dovrà essere SEMPRE un JSON (in caso di modello 2) oppure un oggetto vuoto (in caso di modello 1)

## Parametri di risposta
Definiamo i parametri **obbligatori** della risposta:

* `response_data` : i dati della risposta ottenuta dalla propria richiesta (quello che veramente vogliamo insomma)
* `status_code` : semplicemente viene riportato in questo campo l’HTTP code della risposta. Di default, se tutto è andato bene, il valore è `200` (`HTTP 200 OK`). In caso contrario, verranno usati diversi valori. Per un approfondimento andare nella sezione `Errori - Codici errore HTTP server`.

Ora definiamo i parametri opzionali e quando questi appaiono:

* `message` : messaggio di errore semplice che viene mostrato in caso di errore. Un esempio potrebbe essere semplicemente quando un parametro necessario all’azione richiesta è assente.
* `dev_message` : ha uno scopo leggermente differente rispetto al parametro differente. Viene usato **esclusivamente** per il debugging veloce dell’API in fase di sviluppo e manutenzione, quindi questo parametro non può essere presente se il progetto dovesse andare in produzione. Quando il progetto va in modalità produzione, gli errori di questo livello verranno salvati in un file log dove è possibile rintracciarlo per una veloce ricerca dell’errore e fix.

## Errori
Capita che una richiesta non va a buon fine. Però vi è sempre un motivo se è successo ciò. Quindi è essenziale riportare quali sono gli errori.

### Codici errore HTTP

Nella sezione `Parametri di risposta` è stato introdotto il parametro `status_code` che non è altro che l’HTTP code della richiesta. Elenchiamo tutti i codici utilizzati:

* `200` : `OK`. Valore di default, la richiesta è andata a buon fine (in teoria).
* `400` : `Bad Request`, ovvero la richiesta non è conforme all’esecuzione. Questo è causato per aver impostato la richiesta in un modo totalmente differente a quella dettata, oppure per l’azione interrogata manca uno o più parametri.
* `401` : `Unauthorized`, ovvero la richiesta non può essere esaudita per assenza di privilegi. Questo capita se il token inviato al server non è valido oppure è assente. Inoltre, è usato quando l’username o la password è errata.
* `403` : `Forbidden`, ovvero la richiesta non può essere esaudita per privilegi inferiori a quelli richiesti per l’azione. Questo capita, per esempio, quando un’utente base tenta di accedere a entry point dove solo i privilegiati possono usufruire di tale accesso.
* `404` : `Not Found`, ovvero la richiesta non può essere esaudita perché tale azione non è stata implementata (al momento).
* `405` : `Method Not Allowed`, ovvero la richiesta viene automaticamente bloccata se il metodo della richiesta **NON È POST**.
* `423` : `Locked`, ovvero la richiesta non può essere esaudita perché l’utente in questione non ha più accesso all’API (comunemente chiamato in gergo `bannato`.
* `500` : `Internal Server Error`, ovvero il server ha riscontrato un problema nella processione dell’azione. Se la risposta corrisponde a un JSON, significa che è un errore dello script API. Tale errore può essere rintracciato se segnato l’ID errore univoco ricevuto. In caso di sviluppo e manutenzione, è possibile ottenere pure uno stack trace dell’eccezione. In caso contrario, si tratta di un errore interno del sistema del server per problemi di varia natura.
* `503` : `Service Unavailable`, ovvero il server non è al momento disponibile. Può essere che è stato impostato per la manutenzione dell’API, tuttavia, per i test è possibile bypassarlo tramite un parametro e un account abilitato a fare questo tipo di test per motivi di sicurezza.

## Come funzionano le richieste a livello di codice?
Dopo aver caricato tutto su server oppure in local host, le richieste vengono effettuate come quando fai una richiesta ai server di a Google per ottenere i dati della tua ricerca, però questo deve essere effettuato tramite JS (web app) oppure tramite richieste native (app native). È possibile anche fare richieste tramite `cURL`.

L’URL per le richieste server non in localhost è:
`http://aum.altervista.org/main.php`
Se possibile, è buona prassi utilizzare un altro entrypoint per eseguire più richieste alla volta in un solo JSON di risposta. 
`http://aum.altervista.org/multi.php`
Per questo entrypoint è necessario seguire la seguente struttura:
```json
[
	{
		“module”:”login”,
		“action”:”auth”,
		“request_data”:{}
	},
	{
		“module”:”commit”,
		“action”:”approve”,
		“request_data”:{
			“commit_id”:15
		}
	}
]
```

È importante mettere in ordine l’array di richieste perché il server eseguirà le richieste seguendo l’ordine degli indici (`0` è il primo ad essere eseguito)

La risposta sarà sempre un array di risposte che seguiranno sempre l’ordine delle richieste fatte. Ad esempio, se la richiesta `login/auth` è stata fatta per prima, allora è quella che viene messo nell’indice `0` dell’array.

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
include_once “./modules/$module/$action.php”;
```

Affinché sia possibile usufruire dell’entrypoint `multi.php` dobbiamo rendere le azioni più modulari possibile. E questo è possibile grazie alle funzioni anonime salvate in una variabile.

Il pattern da seguire sarà: 
```php
$init = function (array $data){
	//Usato per inizializzare qualcosa che è necessario fare prima di iniziare ad eseguire il codice. Pertanto, la sua esistenza non è obbligatoria se questo non è necessario.
}

$exec = function (array $data, array $init_data = NULL) : array{
	//Questa è la funzione necessaria per eseguire qualunque cosa debba fare l’azione.
}
```
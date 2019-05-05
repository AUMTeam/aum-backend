# Setup of the project

## Package installation
Install the following packets: 

For **Arch Linux**:
```bash
pacman -S php php-fpm php-cgi php-pgsql apache
```

For **Debian**:
```bash
apt-get install php php-fpm php-cgi php-pgsql apache2
```

PHP has to support PCNTL with --enable-pcntl flag and LDAP with --enable-ldap flag


## Apache configuration

Create ```/etc/httpd/conf/extra/php-fpm.conf``` with:

```ini
DirectoryIndex index.php index.html
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"
</FilesMatch>
```



Open ```/etc/httpd/conf/httpd.conf``` with your favourite text editor and:

- Add the following modules:

  ```ini
  LoadModule proxy_module modules/mod_proxy.so
  LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
  LoadModule http2_module modules/mod_http2.so
  ```


- Add this lines at the end of the file:

  ```ini
  Include conf/extra/php-fpm.conf
  Protocols h2 http/1.1
  ```

Http2 is not strictly required, but it should increase performance.


## PHP Configuration

Create ```/etc/php/conf.d/db.ini``` with:

```
extension=pdo_pgsql
extension=pgsql
```


## Service enable

Issue the following commands:

```bash
systemctl enable php-fpm httpd postgres
systemctl start php-fpm httpd postgres
```

## Project configuration
Open ```config.php```:
- Edit the DB configuration:
  ```php
  //$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
  $db_type = "mysql"; //Uncomment this for MySQL usage

  //DB configuration
  $db_config = [
      'server' => "",
      'username' => "",
      'password' => "",
      'db_name' => "",
  ];
  ```

- Edit the mail configuration:
  ```php
  //URL to the Front-End, used in mails
  $gui_url = "";
  //Mail server parameters
  $mail_config = [
    'server' => '',
    'protocol' => 'tls', //or ssl
    'port' => 587,
    'username' => '',
    'password' => ''
  ];
  ```

-Edit the LDAP configuration:
  ```php
//--LDAP Configuration--
  $ldap_config = [
      'enabled' => false,
      'server' => "ldaps://localhost:389",
      'domain' => 'mydomain',
      'tld' => '.com'
  ];
  ```
<?php
/* Database credentials. Assuming you are running MySQL
server with default setting (user 'root' with no password) */

$db_server = getenv('MYSQL_CONNECTION');
$db_user = getenv('SECRET_USERNAME');
$db_pwd = getenv('SECRET_PASSWORD');

define('DB_SERVER', $db_server);
define('DB_USERNAME', $db_user);
define('DB_PASSWORD', $db_pwd);
define('DB_NAME', 'demo');

/* Attempt to connect to MySQL database */
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Check connection
if($link === false){
    echo "ERROR: Could not connect to database." . mysqli_connect_error();
}
?>
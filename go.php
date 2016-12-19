<?php

 $db = mysqli_connect("mysql.hostinger.com.br","u990873117_user","maristela",'u990873117_base')
 or die('Error connecting to MySQL server.');



if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');    // cache for 1 day
}

$query = "SELECT * FROM favorecido";
$sth = mysqli_query($db, $query) or die('Error querying database.');

mysqli_query("SELECT ...");
$rows = array();
while($r = mysqli_fetch_assoc($sth)) {
    $rows[] = $r;
}
print json_encode($rows);
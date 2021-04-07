<?php
$servername = "localhost";
$username   = "madkiddo_sluser";
$password   = ".dH9frLp8UPs";
$dbname     = "madkiddo_second_life";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
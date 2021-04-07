<?php
error_reporting(0);
include_once("dbconnect.php");
$prodid = $_POST['prodid'];

$sqldelete = "DELETE FROM PRODUCT WHERE PRODID = '$prodid'";

if ($conn->query($sqldelete) == TRUE){
       
       echo "success";
    }else {
        echo "failed";
    }


    
?>
<?php
error_reporting(0);
include_once ("dbconnect.php");
$prid = $_POST['prid'];
$prname  = ucwords($_POST['prname']);
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$weight  = $_POST['weight'];
$description  = $_POST['description'];
$location  = $_POST['location'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../productimage/'.$prid.'.jpg';

$sqlupdate = "UPDATE PRODUCT SET NAME = '$prname', PRICE = '$price', QUANTITY= '$quantity',WEIGHT ='$weight' ,TYPE = '$type' ,DESCRIPTION = '$description', LOCATION = '$location' WHERE PRODID = '$prid'";

if (isset($encoded_string)){
   if ($conn->query($sqlupdate) === true)
{
    //echo 'success';
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
} 
}else{
    if ($conn->query($sqlupdate) === true){
        echo 'success';
        
    }
    else {
        echo 'failed';
        
    }
}

   


?>
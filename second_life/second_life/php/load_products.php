<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];
$email = $_POST['email'];

if (isset($type)){
    if ($type == "All"){
        $sql = "SELECT * FROM PRODUCT ORDER BY DATE DESC";    
    }else{
        $sql = "SELECT * FROM PRODUCT WHERE TYPE = '$type'";    
    }
}else{
    $sql = "SELECT * FROM PRODUCT ORDER BY DATE DESC";    
}
if (isset($email)){
   $sql = "SELECT * FROM PRODUCT WHERE EMAIL =  '$email'";
}
if (isset($name)){
   $sql = "SELECT * FROM PRODUCT WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["name"] = $row["NAME"];
        $productlist["id"] = $row["PRODID"];
        $productlist["price"] = $row["PRICE"];
        $productlist["quantity"] = $row["QUANTITY"];
        $productlist["sold"] = $row["SOLD"];
        $productlist["weigth"] = $row["WEIGHT"];
        $productlist["type"] = $row["TYPE"];
        $productlist["date"] = $row["DATE"];
        $productlist["description"] = $row["DESCRIPTION"];
        $productlist["location"] = $row["LOCATION"];
        $productlist["email"] = $row["EMAIL"];
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
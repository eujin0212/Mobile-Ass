<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT PRODUCT.PRODID, PRODUCT.NAME, PRODUCT.PRICE, CARTHISTORY.CQUANTITY FROM PRODUCT INNER JOIN CARTHISTORY ON CARTHISTORY.PRODID = PRODUCT.PRODID WHERE CARTHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["PRODID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["price"] = $row["PRICE"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
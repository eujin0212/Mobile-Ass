<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT pay.ORDERID, ADDRESS, ch.PRODID, prod.NAME, prod.WEIGHT, CQUANTITY, prod.EMAIL FROM PAYMENT AS pay INNER JOIN CARTHISTORY as ch ON pay.ORDERID = ch.ORDERID INNER JOIN PRODUCT AS prod ON ch.PRODID = prod.PRODID WHERE prod.EMAIL = '$email'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["custorder"] = array();
    while ($row = $result->fetch_assoc())
    {
        $custorderlist = array();
        $custorderlist["orderid"] = $row["ORDERID"];
        $custorderlist["address"] = $row["ADDRESS"];
        $custorderlist["prodid"] = $row["PRODID"];
        $custorderlist["name"] = $row["NAME"];
        $custorderlist["weight"] = $row["WEIGHT"];
        $custorderlist["cquantity"] = $row["CQUANTITY"];
        array_push($response["custorder"], $custorderlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
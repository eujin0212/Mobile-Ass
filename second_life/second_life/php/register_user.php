<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE) VALUES ('$name','$email','$password','$phone')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}

//https://madkiddo.com/second_life/php/register_user.php?name=Ahmad%20Hanis&email=slumberjer@gmail.com&phone=01949494959&password=123456

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Second Life'; 
    $message = 'https://madkiddo.com/second_life/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@secondlife.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>


<?php
    $email = $_POST["A"];
    //$email='dharsandiyadeep1234@gmail.com';
    $vcode = mt_rand(100000,999999); 
    $title="Email Verification";
    $body="Verificaion Code is ".$vcode;
    require("Mail/EmailSender.php");
    echo json_encode($vcode);
    
?>
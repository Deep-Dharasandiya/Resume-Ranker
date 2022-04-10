<?php

     require("connect.php");
     $email = $_POST["A"];
     
     $query="SELECT COUNT(email) FROM applicant where email='$email';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
        $query="SELECT COUNT(email) FROM recruiter where email='$email';";
        $statement = $db->prepare($query);
        $statement->execute();
        $count=$statement->fetch(PDO::FETCH_ASSOC);
        if(intval($count['COUNT(email)'])==0){
            echo json_encode(0);
        }else{
            $vcode = mt_rand(100000,999999); 
            $title="Email Verification For Change Password";
            $body="Verificaion Code is ".$vcode;
            require("Mail/EmailSender.php");
            echo json_encode($vcode);
        }
     }else{
        $vcode = mt_rand(100000,999999); 
        $title="Email Verification For Change Password";
        $body="Verificaion Code is ".$vcode;
        require("Mail/EmailSender.php");
        echo json_encode($vcode);
     }
?>
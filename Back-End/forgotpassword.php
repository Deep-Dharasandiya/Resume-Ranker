<?php

     require("connect.php");
     $email = $_POST["A"];
     $password = $_POST["B"];

     
     $query="SELECT COUNT(email) FROM applicant where email='$email';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
        $query="UPDATE recruiter SET password='$password' WHERE email='$email';";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }else{
        $query="UPDATE applicant SET password='$password' WHERE email='$email';";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }
?>
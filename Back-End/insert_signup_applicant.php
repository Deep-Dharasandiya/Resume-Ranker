<?php

     require("connect.php");
     $uname = $_POST["A"];
     $uemail = $_POST["B"];
     $upassword = $_POST["C"];
     $ucono = $_POST["D"];

     
     $query="SELECT COUNT(email) FROM applicant where email='$uemail';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
        $query="INSERT INTO applicant VALUES ('$uname','$uemail','$upassword','$ucono','applicant')";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }else{
        echo json_encode("Email Already Exist");
     }
?>
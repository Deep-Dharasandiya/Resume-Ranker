<?php

    require("connect.php");
     $email = $_POST["A"];
     $name =$_POST["B"];
     $lavel =$_POST["C"];
     $score=$_POST["D"];
   
    $query="UPDATE resume_technicalskills SET eligible='false',score='$score' where email='$email' and name='$name' and lavel='$lavel'";
    $statement = $db->prepare($query);
    $statement->execute();
    echo json_encode(1);
     
   
?>
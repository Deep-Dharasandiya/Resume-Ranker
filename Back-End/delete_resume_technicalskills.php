<?php

    require("connect.php");
     $email = $_POST["A"];
     $name =$_POST["B"];
     $lavel =$_POST["C"];
     $eligible=$_POST["D"];
     if($eligible=='true'){
        $query="DELETE FROM resume_technicalskills where email='$email' and name='$name' and lavel='$lavel'";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }else{
        $query="UPDATE resume_technicalskills SET live='false' where email='$email' and name='$name' and lavel='$lavel'";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }
   
?>
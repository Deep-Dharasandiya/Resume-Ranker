<?php

    require("connect.php");
     $email=$_POST["A"];
     $name=$_POST["B"];
     $query="DELETE FROM resume_certificates where email='$email' and name='$name'";
     $statement = $db->prepare($query);
     $statement->execute();
    echo json_encode(1);
   
?>
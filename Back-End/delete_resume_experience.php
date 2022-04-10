<?php

    require("connect.php");
     $email=$_POST["A"];
     $company=$_POST["B"];
     $post=$_POST["C"];
     $query="DELETE FROM resume_experiences where email='$email' and company='$company' and post='$post'";
     $statement = $db->prepare($query);
     $statement->execute();
    echo json_encode(1);
   
?>
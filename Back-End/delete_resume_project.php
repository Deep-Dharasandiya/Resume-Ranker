<?php

    require("connect.php");
     $email=$_POST["A"];
     $title=$_POST["B"];
     $query="DELETE FROM resume_projects where email='$email' and title='$title'";
     $statement = $db->prepare($query);
     $statement->execute();
    echo json_encode(1);
   
?>
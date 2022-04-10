<?php

    require("connect.php");
     $email=$_POST["A"];
     $program=$_POST["B"];
     $course=$_POST["C"];
     $query="DELETE FROM resume_eduacation where email='$email' and program='$program' and course='$course'";
     $statement = $db->prepare($query);
     $statement->execute();
    echo json_encode(1);
   
?>
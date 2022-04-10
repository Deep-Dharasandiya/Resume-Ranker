<?php
     require("connect.php");
     $email=$_POST["A"];
     $query="SELECT * from resume_experiences where email='$email'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
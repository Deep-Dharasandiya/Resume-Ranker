<?php
     require("connect.php");
     $email=$_POST["A"];
     $query="SELECT name,lavel,eligible from resume_technicalskills where email='$email' and live='true' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
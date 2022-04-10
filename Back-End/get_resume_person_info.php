<?php
     require("connect.php");
     $email=$_POST["A"];
     //$email="deep2@gmail.com";
     $query="SELECT * from Resume_Person_info where email='$email'";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
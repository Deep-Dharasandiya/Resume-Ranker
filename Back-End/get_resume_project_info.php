<?php
     require("connect.php");
     $email = $_POST["A"];
     $query="SELECT * FROM resume_projects where email='$email' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
<?php
     require("connect.php");
     $email = $_POST["A"];
     $post = $_POST["B"];
     $query="SELECT * FROM vacancy where email='$email' and post='$post' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
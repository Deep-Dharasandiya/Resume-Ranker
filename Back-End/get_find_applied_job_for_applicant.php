<?php
     require("connect.php");
     $email = $_POST["A"];
     //$email="deep@gmail.com";
     $query="SELECT coemail,post,eligible,live FROM  applyingjob where email='$email'";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
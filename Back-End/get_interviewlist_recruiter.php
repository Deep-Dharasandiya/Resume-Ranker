<?php
     require("connect.php");
     $email=$_POST["A"];
     $flag="true";
     $query="SELECT * FROM applyingjob where coemail='$email' and status='Interview Onprogress' and live='$flag';";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
         $result[]=$row;
    }
    echo json_encode($result);
?>
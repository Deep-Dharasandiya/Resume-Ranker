<?php
     require("connect.php");
     $coemail=$_POST["A"];
     $email=$_POST["B"];
     $query="SELECT * FROM interview where coemail='$coemail' and email='$email' and live='true';";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
         $result[]=$row;
    }
    echo json_encode($result);
?>
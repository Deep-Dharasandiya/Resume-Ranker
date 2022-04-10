<?php
     require("connect.php");
     $email=$_POST["A"];
     $coemail=$_POST["B"];
     $post=$_POST["C"];
     $live='false';
     $query="SELECT * FROM interview where email='$email' and coemail='$coemail' and post='$post' and live='$live'";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
         $result[]=$row;
    }
    echo json_encode($result);
?>
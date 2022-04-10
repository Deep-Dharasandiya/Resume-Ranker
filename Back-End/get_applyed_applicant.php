<?php
     require("connect.php");
     $email=$_POST["A"];
     $post=$_POST["B"];
     $query="SELECT * from applyingjob where coemail='$email'and post='$post' and live='true' ORDER BY total DESC";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
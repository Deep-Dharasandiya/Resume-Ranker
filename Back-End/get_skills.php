<?php
     require("connect.php");
     $query="SELECT DISTINCT skillname FROM apptest; ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row['skillname'];
    }
    echo json_encode($result);
?>
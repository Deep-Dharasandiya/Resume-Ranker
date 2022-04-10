<?php
     require("connect.php");
    
     $query="SELECT name FROM collage_details ORDER BY name ASC ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
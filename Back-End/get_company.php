<?php
     require("connect.php");
     $query="SELECT name FROM registrationnumber; ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row['name'];
    }
    echo json_encode($result);
?>
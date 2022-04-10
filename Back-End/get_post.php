<?php
     require("connect.php");
     $query="SELECT DISTINCT post FROM skills_cluster; ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row['post'];
    }
    echo json_encode($result);
?>
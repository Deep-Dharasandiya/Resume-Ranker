<?php
     require("connect.php");
     $query="SELECT * FROM vacancy INNER JOIN recruiter ON vacancy.email=recruiter.email ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        if($row['lastdate'] >=date('Y-m-d')){
            $result[]=$row;
        }
    }
    echo json_encode($result);
?>
<?php
     require("connect.php");
     $query="SELECT * FROM applyingjob INNER JOIN recruiter ON applyingjob.email=recruiter.email where applyingjob.live like 'true' ;";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
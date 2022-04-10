<?php
     require("connect.php");
     $email=$_POST["A"];
    // $email="deep@gmail.com";
     $flag="true";
     $query="SELECT * FROM applyingjob INNER JOIN recruiter ON applyingjob.coemail=recruiter.email where applyingjob.email='$email' and live = '$flag' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
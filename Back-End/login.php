<?php
     require("connect.php");
     $Email =$_POST["A"];
     $Password = $_POST["B"];
    
     $query="SELECT name,email,contect,role FROM applicant WHERE email='$Email' AND password='$Password'";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row; 
    }
   
    if(sizeof($result) == 0)
    {
        $result2=array();
        $query="SELECT name,email,contect,ladd,city,dis,ta,pin,contain,other,role FROM recruiter WHERE email='$Email' AND password='$Password'";
        $statement = $db->prepare($query);
        $statement->execute();
            while($row=$statement->fetch(PDO::FETCH_ASSOC))
        {
            $result2[]=$row;
        }

        if(sizeof($result2) == 0)
        {
            echo json_encode(0);
        }
        else
        {
            echo json_encode($result2);
        }
    }
    else
    {
        echo json_encode($result);
    }
    
?>

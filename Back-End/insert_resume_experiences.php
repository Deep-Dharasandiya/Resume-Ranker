<?php

     require("connect.php");
     $email = $_POST["A"];
     $completed =$_POST["B"];
     $intern=$_POST["C"];
     $post = $_POST["D"];
     $company =$_POST["E"];
     $startmonth=$_POST["F"];
     $endmonth=$_POST["G"];
     $description=$_POST["H"];
     $joblatter=$_POST["I"];
    
     $query="SELECT COUNT(email) FROM resume_experiences where email='$email' and company='$company' and post='$post';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO resume_experiences (email,completed,intern,post,company,startmonth,endmonth,description,joblatter) VALUES ('$email','$completed','$intern','$post','$company','$startmonth','$endmonth','$description','$joblatter')";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
      }else{
         $query="UPDATE resume_experiences SET completed='$completed',intern='$intern',startmonth='$startmonth',endmonth='$endmonth',description='$description',joblatter='$joblatter' where email='$email' and company='$company' and post='$post'";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
      }
?>
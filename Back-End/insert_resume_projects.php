<?php

     require("connect.php");
     $email = $_POST["A"];
     $competed=$_POST["B"];
     $title = $_POST["C"];
     $repo = $_POST["D"];
     $aboutprojecte =$_POST["E"];
     $startdate=$_POST["F"];
     $enddate=$_POST["G"];
     $query="SELECT COUNT(email) FROM resume_projects where email='$email' and title='$title';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO resume_projects (email,completed,title,repo,aboutproject,startdate,enddate) VALUES ('$email','$competed','$title','$repo','$aboutprojecte','$startdate','$enddate')";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }else{
         $query="UPDATE resume_projects SET completed='$competed',title='$title',repo ='$repo', aboutproject='$aboutprojecte',startdate='$startdate',enddate='$enddate' where email='$email' and title='$title'";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }

?>
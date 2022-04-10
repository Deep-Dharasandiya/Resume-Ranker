<?php
     require("connect.php");
     $email = $_POST["A"];
     $program =$_POST["B"];
     $course=$_POST["C"];
     $collage=$_POST["D"];
     $percentage = $_POST["E"];
     $mode =$_POST["F"];
     $startyear=$_POST["G"];
     $endyear=$_POST["H"];
     $result=$_POST["I"];

     
     
     $query="SELECT COUNT(email) FROM resume_eduacation where email='$email' and program='$program' and course='$course';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO resume_eduacation VALUES ('$email','$program','$course','$collage','$percentage','$mode','$startyear','$endyear','$result');";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }else{
         $query="UPDATE resume_eduacation SET collage='$collage',percentage='$percentage',mode='$mode',startyear='$startyear',endyear='$endyear',result='$result' where email='$email' and program='$program' and course='$course'";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }
?>
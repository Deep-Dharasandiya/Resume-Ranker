<?php

     require("connect.php");
     $email = $_POST["A"];
     $fname =$_POST["B"];
     $mname=$_POST["C"];
     $lname = $_POST["D"];
     $resume_email =$_POST["E"];
     $cono=$_POST["F"];
     $picture=$_POST["G"];
     $dob=$_POST["H"];
     $aboutself=$_POST["I"];
     $ladd=$_POST["J"];
     $city=$_POST["K"];
     $dis=$_POST["L"];
     $ta=$_POST["M"];
     $pin=$_POST["N"];
     
     
     $query="SELECT COUNT(email) FROM Resume_Person_info where email='$email';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO Resume_Person_info VALUES ('$email','$fname','$mname','$lname','$resume_email','$cono','$picture','$dob','$aboutself','$ladd','$city','$dis','$ta','$pin')";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }else{
         $query="UPDATE Resume_Person_info SET fname='$fname',mname='$mname',lname='$lname',resume_email='$resume_email',cono='$cono',profile_picture='$picture',dob='$dob',aboutself='$aboutself',ladd='$ladd',city='$city',dis='$dis',ta='$ta',pin='$pin' where email='$email'";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }
?>
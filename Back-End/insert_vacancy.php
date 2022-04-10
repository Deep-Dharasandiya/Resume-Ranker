<?php
     require("connect.php");
     $email = $_POST["A"];
     $no =$_POST["B"];
     $post =$_POST["C"];
     $minsalary =$_POST["D"];
     $maxsalary =$_POST["E"];
     $other =$_POST["F"];
     $lastdate =$_POST["G"];
     $location =$_POST["H"];
     $requiredskill =$_POST["I"];
     $que =$_POST["J"];
     $uploaded_date=date("d-m-Y");


     $query="SELECT COUNT(email) FROM vacancy where email='$email' and post='$post';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);

     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO vacancy (email,no,post,minsalary,maxsalary,vacancydata,uploded_date,lastdate,location,requiredskill,que) VALUES 
         ('$email','$no','$post','$minsalary','$maxsalary','$other','$uploaded_date','$lastdate','$location','$requiredskill','$que')";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }else{
      $query="UPDATE vacancy SET no ='$no',minsalary='$minsalary',maxsalary='$maxsalary',vacancydata='$other',uploded_date='$uploaded_date',lastdate='$lastdate',location='$location',
              requiredskill='$requiredskill' , que='$que' where email='$email' and post='$post'";
      $statement = $db->prepare($query);
      $statement->execute();
       echo json_encode(1);
     }
?>
<?php
     require("connect.php");
     $email = $_POST["A"];
     $skill_name =$_POST["B"];
     $skill_level=$_POST["C"];

     $query="SELECT COUNT(email) FROM resume_technicalskills where email='$email' and name='$skill_name' and lavel='$skill_level';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);

     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO resume_technicalskills (email,name,lavel,eligible,live) VALUES ('$email','$skill_name','$skill_level','true','true')";
         $statement = $db->prepare($query);
         $statement->execute();
         echo json_encode(1);
     }else{
      $query="UPDATE resume_technicalskills SET name ='$skill_name',lavel='$skill_level',live='true' where email='$email' and name='$skill_name' and lavel='$skill_level'";
      $statement = $db->prepare($query);
      $statement->execute();
       echo json_encode(1);
     }
?>
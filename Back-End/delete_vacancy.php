<?php

    require("connect.php");
     $email = $_POST["A"];
     $post =$_POST["B"];
     $query="DELETE FROM vacancy where email='$email' and post='$post'";
     $statement = $db->prepare($query);
     $statement->execute();
     $query="UPDATE applyingjob SET status='Job is Cencled' where coemail='$email' and post='$post'";
      $statement = $db->prepare($query);
      $statement->execute();
      
     echo json_encode(1);
   
?>
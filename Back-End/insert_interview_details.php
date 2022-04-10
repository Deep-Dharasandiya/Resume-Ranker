<?php
     require("connect.php");
     $coemail = $_POST["A"];
     $email =$_POST["B"];
     $add=$_POST["C"];
     $time=$_POST["D"];
     $date=$_POST["E"];
     $post=$_POST["F"];
     $title=$_POST["G"];
     $redo=$_POST["H"];
     
     $query="SELECT name from recruiter where email='$coemail'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     $coompanyname=$statement->fetch(PDO::FETCH_ASSOC);

     $query="SELECT COUNT(email) FROM interview where email='$email' and coemail='$coemail' and post='$post'";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);

     if(intval($count['COUNT(email)'])==0){
         $query="INSERT INTO interview (email,coemail,post,title,address,time,date,requireddocument,remark,live) VALUES ('$email','$coemail','$post','$title','$add','$time','$date','$redo','Pending','true')";
         $statement = $db->prepare($query);
         $statement->execute();
         $title="Regarding Interview";
        $body="Your interview for ".$post." in ".$coompanyname['name']."is schedual on ".$date." : ".$time."at ".$add." and carry with mentioned 
        document ".$redo;
        require("Mail/EmailSender.php");
         echo json_encode(1);
     }else{
      $query="UPDATE interview SET title ='$title',address='$add',time='$time',date='$date',requireddocument='$redo',live='true' where email='$email' and coemail='$coemail' and post='$post'";
      $statement = $db->prepare($query);
      $statement->execute();
      $title="Regarding Interview";
        $body="Your interview for ".$post." in ".$coompanyname['name']."is updated schedual on ".$date." : ".$time."at ".$add." and carry with mentioned 
        document ".$redo;
        require("Mail/EmailSender.php");
       echo json_encode(1);
     }
?>
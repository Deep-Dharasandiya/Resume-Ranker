<?php

     require("connect.php");
     $coemail = $_POST["A"];
     $email =$_POST["B"];
     $post =$_POST["C"];
     $status=$_POST["D"];

     $query="SELECT name from recruiter where email='$coemail'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     $coompanyname=$statement->fetch(PDO::FETCH_ASSOC);

     $query="UPDATE applyingjob SET status='$status' where coemail='$coemail' and email='$email' and post='$post'";
    $statement = $db->prepare($query);
    $statement->execute();
    $title="Regarding Job Status";
        $body="Your Job Status of ".$post." in ".$coompanyname['name']."have sucessfuly updated to [ ".$status." ]";
        require("Mail/EmailSender.php");
    echo json_encode(1);
        
     
?>
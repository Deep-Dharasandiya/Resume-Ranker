<?php

     require("connect.php");
     $coemail = $_POST["A"];
     $email =$_POST["B"];
     $post =$_POST["C"];
     $status=$_POST["D"];
     if($status=='Job is Cencled'){
        $query="DELETE FROM applyingjob where email='$email' and coemail='$coemail' and post='$post'";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }else{
        $query="UPDATE applyingjob SET live='false' where coemail='$coemail' and email='$email' and post='$post'";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }
     
     
?>
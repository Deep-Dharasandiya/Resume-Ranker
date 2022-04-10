<?php

     require("connect.php");
     $uname = $_POST["A"];
     $uemail =$_POST["B"];
     $upassword = $_POST["C"];
     $ucono =$_POST["D"];
     $ladd=$_POST["E"];
     $city=$_POST["F"];
     $dis=$_POST["G"];
     $ta=$_POST["H"];
     $pin=$_POST["I"];
     $contain=$_POST["J"];
     $other=$_POST["K"];
     $icon=$_POST["L"];
     $reno=$_POST["M"];


     $query="SELECT ragistrationnumber FROM RegistrationNumber";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     $temp=0;
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        if($reno==$row["ragistrationnumber"])
        {
           $temp=1;
        }
        
    }
   if($temp==1){
        $query="SELECT COUNT(email) FROM recruiter where email='$uemail';";
        $statement = $db->prepare($query);
        $statement->execute();
        $count=$statement->fetch(PDO::FETCH_ASSOC);
        if(intval($count['COUNT(email)'])==0){
            $query="INSERT INTO recruiter VALUES ('$uname','$uemail','$upassword','$ucono','$ladd','$city','$dis','$ta','$pin','$contain','$other','$icon','reqruiter')";
            $statement = $db->prepare($query);
            $statement->execute();
            echo json_encode(1);
        }else{
             echo json_encode("Email Already Exist");
        }
    
    
   }
   else{
       echo json_encode("Enter Valid Registraton number");
   }

?>
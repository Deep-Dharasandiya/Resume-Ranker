<?php

     require("connect.php");
     $email = $_POST["A"];
     $name = $_POST["B"];
     $aboutcourse =$_POST["C"];
     $startdate=$_POST["D"];
     $enddate=$_POST["E"];
     $certificate=$_POST["F"];
     $query="SELECT COUNT(email) FROM resume_certificates where email='$email' and name='$name';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
        $query="INSERT INTO resume_certificates (email,name,aboutcourse,startdate,enddate,certificate) VALUES ('$email','$name',' $aboutcourse','$startdate','$enddate','$certificate')";
        $statement = $db->prepare($query);
        $statement->execute();
        echo json_encode(1);
     }else{
        $query="UPDATE resume_certificates SET name='$name',aboutcourse='$aboutcourse',startdate='$startdate',enddate='$enddate',certificate='$certificate' where email='$email' and name='$name'";
        $statement = $db->prepare($query);
        $statement->execute();
         echo json_encode(1);
     }
?>
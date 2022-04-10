<?php
     require("connect.php");
     $coemail = $_POST["A"];
     $post=$_POST["B"];
     //$email="pradhruvil12@gmail.com";
     $query="SELECT AVG(eduacationscore),MIN(eduacationscore),MAX(eduacationscore),AVG(skillscore),MIN(skillscore),MAX(skillscore),
     AVG(experiencescore),MIN(experiencescore),MAX(experiencescore),AVG(testscore),MIN(testscore),MAX(testscore) FROM applyingjob 
     WHERE coemail='$coemail' and post='$post'";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
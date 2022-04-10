<?php
     require("connect.php");
     $skill=$_POST["A"];
     $level=$_POST["B"];
     $query="SELECT skillname As name,type As lavel,que,A AS a,B AS b,C AS c,D AS d,Ans AS ans from Apptest where  skillname='$skill' and type='$level' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $result=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $result[]=$row;
    }
    echo json_encode($result);
?>
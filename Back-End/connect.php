<?php
  $dns='mysql:host=localhost;dbname=dbname';
  $user ='root';
  $pass='';

 try{
   $db = new PDO($dns , $user , $pass);
}
catch(PDOException $e){
$error = $e->getMessage();
echo $error;
}

?>
<?php
     require("connect.php");
     $email = $_POST["A"];
     $coemail =$_POST["B"];
     $post =$_POST["C"];
     $testscore =doubleval($_POST["D"]);
     /*$email = 'bhavya@gmail.com';
     $coemail ='tcs@gmail.com';
     $post ="Android Developer";
     $testscore =50.00;*/
    //$email="deep@gmail.com";*/

     $personaldata=array();
     $eduacationdata=array();
     $experiencedata=array();
     $skilldata=array();
     $projectdata=array();
     $certificatedata=array();
     $resume;
     

     $query="SELECT * from Resume_Person_info where email='$email'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
      $personaldata[]=$row;
    }

    $query="SELECT * from resume_eduacation where email='$email'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $eduacationdata[]=$row;
    }

    $query="SELECT * from resume_experiences where email='$email'  ";
    $statement = $db->prepare($query);
    $statement->execute();
    while($row=$statement->fetch(PDO::FETCH_ASSOC))
   {
       $experiencedata[]=$row;
   }

   $query="SELECT name,lavel from resume_technicalskills where email='$email' and live='true' ";
     $statement = $db->prepare($query);
     $statement->execute();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
        $skilldata[]=$row;
    }

   $query="SELECT * FROM resume_projects where email='$email' ";
   $statement = $db->prepare($query);
   $statement->execute();
   while($row=$statement->fetch(PDO::FETCH_ASSOC))
  {
      $projectdata[]=$row;
  }

  $query="SELECT * FROM resume_certificates where email='$email' ";
  $statement = $db->prepare($query);
  $statement->execute();
  while($row=$statement->fetch(PDO::FETCH_ASSOC))
  {
     $certificatedata[]=$row;
  }

  $object = new stdClass();
  $object->personalinfo = json_encode($personaldata);
  $object->eduacationinfo = json_encode($eduacationdata);
  $object->experienceinfo = json_encode($experiencedata);
  $object->skillinfo = json_encode($skilldata);
  $object->projectinfo = json_encode($projectdata);
  $object->certificateinfo = json_encode($certificatedata);
  

  


     //Algo.
     $educationscore=0;
     $experiencescore=0;
     $skillscore=0;
     $projectscore=0;
     $certificatescore=0;
     
     //EducationScore
     $query="SELECT program,course,collage,percentage,mode,startyear,endyear from resume_eduacation where email='$email'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     $education=array();
     while($row=$statement->fetch(PDO::FETCH_ASSOC))
    {
      $education[]=$row;
    }
    for($i=0;$i<sizeof($education);$i++){
      $local=0;
      $program=$education[$i]['program'];
      $name=$education[$i]['course'];
      $q="SELECT score,duration FROM Coursesname where program='$program' and name='$name' ";
      $statement = $db->prepare($q);
      $statement->execute();
      $course=$statement->fetch(PDO::FETCH_ASSOC);
      $per=1+(floatval($education[$i]['percentage'])/floatval($education[$i]['mode'])*0.30);
      $local=$local+($course['score'] * $per);
      //collage
     $collage=$education[$i]['collage'];
      if($collage!="No Collage"){
        $q="SELECT score FROM collage_details where name='$collage' ";
        $statement = $db->prepare($q);
        $statement->execute();
        $result=array();
        $score=$statement->fetch(PDO::FETCH_ASSOC);
        $local=$local*(1+(doubleval($score['score'])*0.20)/100);
      }
      $duration=doubleval($education[$i]['endyear'])-doubleval($education[$i]['startyear']);
      $local=$local+($duration-doubleval($course['duration']))*(-0.05);
      $educationscore=$educationscore+$local;
    }



    //skill
      $matching='false';
      $query="SELECT * from resume_technicalskills where email='$email' and live='true'";
      $statement = $db->prepare($query);
      $statement->execute();
      $skill=array();
        while($row=$statement->fetch(PDO::FETCH_ASSOC))
        {
          $skill[]=$row;
        }
      $q="SELECT requiredskill FROM vacancy where email='$coemail' and post='$post' ";
          $statement = $db->prepare($q);
          $statement->execute();
          $requiredskill=$statement->fetch(PDO::FETCH_ASSOC);
          $requiredskill=json_decode($requiredskill['requiredskill']);
          $flagcounter=0;
      $numberofrequiredskil=0;
      for($i=0;$i<sizeof($skill);$i++){
        $local=0;
        $flag=0;
        $numberofrequiredskil=0;
        for($j=0;$j<sizeof($requiredskill);$j++){
          $numberofrequiredskil=$numberofrequiredskil+1;
          if($skill[$i]['name']==$requiredskill[$j]->name){
            $flagcounter=$flagcounter+1;
            $flag=1;
                if($requiredskill[$j]->lavel=='Beginner'){
                        if($skill[$i]['lavel']=='Beginner'){
                          $local=$local+90;
                        }else if($skill[$i]['lavel']=='Intermediate'){
                          $local=$local+95;
                        }else{
                          $local=$local+100;
                        }
                }
                else if($requiredskill[$j]->lavel=='Intermediate'){
                      if($skill[$i]['lavel']=='Beginner'){
                        $local=$local+80;
                      }else if($skill[$i]['lavel']=='Intermediate'){
                        $local=$local+90;
                      }else{
                        $local=$local+95;
                      }
                }
                else{
                      if($skill[$i]['lavel']=='Beginner'){
                        $local=$local+70;
                      }else if($skill[$i]['lavel']=='Intermediate'){
                        $local=$local+80;
                      }else{
                        $local=$local+90;
                      }
                }
          }
        }
        if($flag==1){
          $local=$local+20;
        }
        $skillscore=$skillscore+$local;
          
      }
      if($numberofrequiredskil<=$flagcounter){
        $matching="true";
      }
      
      

    //Experience
      $query="SELECT * from resume_experiences where email='$email' ";
      $statement = $db->prepare($query);
      $statement->execute();
      $experience=array();
      while($row=$statement->fetch(PDO::FETCH_ASSOC))
        {
          $experience[]=$row;
        }
      for($i=0;$i<sizeof($experience);$i++){
        $local=0;
        $companyname=$experience[$i]['company'];
        $query="SELECT priority FROM registrationnumber where name='$companyname' ";
        $statement = $db->prepare($query);
        $statement->execute();
        $companypriority=$statement->fetch(PDO::FETCH_ASSOC);
        if($experience[$i]['endmonth']=="Present"){
          $startmonth=explode("-",$experience[$i]['startmonth']);
          $endmonth=explode("-",date('Y-m-d'));
          $month=(abs(intval($endmonth[0])-intval($startmonth[0]))*12)+abs(intval($endmonth[1])-intval($startmonth[1]));
        }else{
          $startmonth=explode("-",$experience[$i]['startmonth']);
          $endmonth=explode("-",$experience[$i]['endmonth']);
          $month=(abs(intval($endmonth[0])-intval($startmonth[0]))*12)+abs(intval($endmonth[1])-intval($startmonth[1]));
        }
        
        if($experience[$i]['intern']=='true'){
          $local=$local+(doubleval($companypriority['priority'])*(1+(0.01*$month)));
        }else{
          $local=$local+(doubleval($companypriority['priority'])*(1+(0.03*$month)));
        }
        $experiencescore=$experiencescore+$local;
      }
      
    //Project

     $query="SELECT COUNT(email) FROM resume_projects where email='$email' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     $projectscore=intval($count['COUNT(email)']);

     //Certificate

     $query="SELECT COUNT(email) FROM resume_certificates where email='$email' ";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     $certificatescore=intval($count['COUNT(email)']);
     
    
///company name

     $query="SELECT name from recruiter where email='$coemail'  ";
     $statement = $db->prepare($query);
     $statement->execute();
     $coompanyname=$statement->fetch(PDO::FETCH_ASSOC);

//Data insertion
     $total=$educationscore*0.20 + $skillscore*0.45 +$experiencescore*0.25 + $testscore*0.1;
     $status='Job is Cencled';
     $query="SELECT COUNT(email) FROM applyingjob  where email='$email' and coemail='$coemail' and post='$post' and status != '$status';";
     $statement = $db->prepare($query);
     $statement->execute();
     $count=$statement->fetch(PDO::FETCH_ASSOC);
     if(intval($count['COUNT(email)'])==0){
        $query="INSERT INTO applyingjob  (email, coemail, post, eduacationscore, skillscore,matching, experiencescore, projectscore, 
        certificatescore, testscore,eligible, status,personalinfo,eduacationinfo,experienceinfo,skillinfo,projectinfo,certificateinfo,total,live) VALUES 
        ('$email','$coemail','$post',$educationscore,$skillscore,'$matching',$experiencescore, $projectscore,$certificatescore,$testscore,'false','Pendding',
        '$object->personalinfo', '$object->eduacationinfo','$object->experienceinfo','$object->skillinfo','$object->projectinfo','$object->certificateinfo',$total,'true' )";
        $statement = $db->prepare($query);
        $statement->execute();
        $title="Regarding ApplyingJob";
        $body="You have sucessfuly applied in ".$coompanyname['name']." for ".$post;
        require("Mail/EmailSender.php");
        echo json_encode(1);
        
     }else{
      $query="UPDATE applyingjob SET eduacationscore ='$educationscore',skillscore='$skillscore',matching='$matching',experiencescore='$experiencescore',
      projectscore='$projectscore',certificatescore='$certificatescore',personalinfo='$object->personalinfo',eduacationinfo='$object->eduacationinfo',
      experienceinfo='$object->experienceinfo',skillinfo='$object->skillinfo',projectinfo='$object->projectinfo',
      certificateinfo='$object->certificateinfo',total=$total,live='true' where email='$email' and coemail='$coemail' and post='$post'";
      $statement = $db->prepare($query);
      $statement->execute();
      $title="Regarding ApplyingJob";
      $body="You have sucessfuly applied in ".$coompanyname['name']." for ".$post;
      require("Mail/EmailSender.php");
      echo json_encode(1);
     }
  
     

?>
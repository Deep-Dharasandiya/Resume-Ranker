<?php
     use PHPMailer\PHPMailer\PHPMailer;
     use PHPMailer\PHPMailer\Exception;
     require 'Mail/Exception.php';
     require 'Mail/PHPMailer.php';
     require 'Mail/SMTP.php';
     
    $mail = new PHPMailer;
    $mail->isSMTP(); 
    $mail->SMTPDebug = 0; 
    $mail->Host = "smtp.gmail.com";  
    $mail->Port = 587;
    $mail->SMTPSecure = 'tls';
    $mail->SMTPAuth = true;
    $mail->Username = '';
    $mail->Password = '';
    $mail->setFrom('', 'ResumeRanker');
    $mail->IsHTML(true);
    $mail->SMTPOptions = array(
                    'ssl' => array(
                        'verify_peer' => false,
                        'verify_peer_name' => false,
                        'allow_self_signed' => true
                    )
                );
                

     $mail->ClearAddresses();
     $mail->addAddress($email); 
     $mail->Subject = $title;
     $mail->msgHTML($body); 
     $mail->send();
     $mail->ClearAddresses();
?>
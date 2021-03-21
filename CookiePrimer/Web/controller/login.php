<?php
$data = array();
$data['message'] = 'works';
$data['session'] = '0123456789ABCDEF';
$data['additionalInfo'] = array();
$data['additionalInfo']['color'] = 'blue';
$data['additionalInfo']['number'] = 1;
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: http://localhost:8084');
setcookie('SESSIONCOOKIE', $data['session'], time()+12);
echo json_encode($data);
?>

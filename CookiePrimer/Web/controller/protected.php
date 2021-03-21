<?php
$data = array();
if (isset($_COOKIE['SESSIONCOOKIE'])) {
    $data['message'] = 'Great! It seems you are already logged in.';
} else {
	$data['message'] = 'Oh no! You are not logged in.';
}
header('Access-Control-Allow-Origin: http://localhost:8084');
echo json_encode($data);
?>

<?php 
	include("conndb.php");
	switch ($_POST['action']) {
		case "generate_number":
		    
		    mysqli_query($mysqli,"INSERT INTO number (id) VALUES (NULL);");
		    
			break;
			
		case "get_number":
		    
			$result = mysqli_query($mysqli,"SELECT id FROM number ORDER BY id DESC LIMIT 1");
            $array2 = array();
            
			while($row = mysqli_fetch_assoc($result)) {
				array_push($array2,array('id'=>$row['id']));
			}
			$array = array("code"=>"success", "message"=>"",'aryresultlist'=>$array2);
			echo json_encode($array);

			break;
		
		case "serving_number":
		    
			$result = mysqli_query($mysqli,"SELECT MAX(id) AS MaxId FROM number WHERE status = 'serving'");
            $array2 = array();
            
			while($row = mysqli_fetch_assoc($result)) {
				array_push($array2,array('id'=>$row['MaxId']));
			}
			$array = array("code"=>"success", "message"=>"",'aryresultlist'=>$array2);
			echo json_encode($array);

			break;
			
		case "last_number":
		    
			$result = mysqli_query($mysqli,"SELECT id FROM number ORDER BY id DESC LIMIT 1");
            $array2 = array();
            
			while($row = mysqli_fetch_assoc($result)) {
				array_push($array2,array('id'=>$row['id']));
			}
			$array = array("code"=>"success", "message"=>"",'aryresultlist'=>$array2);
			echo json_encode($array);

			break;
			
		case "counter_status":
			if(isset($_POST['cID']) && $_POST['cID'] != ""){
				$cID = $_POST['cID'];
		    
				$result = mysqli_query($mysqli,"SELECT * FROM counter_management WHERE counter = '$cID'");
				$array2 = array();
				
				while($row = mysqli_fetch_assoc($result)) {
					array_push($array2,array('status'=>$row['status'],'current_number'=>$row['current_number']));
				}
				$array = array("code"=>"success", "message"=>"",'aryresultlist'=>$array2);
				echo json_encode($array);
			}else{
				echo json_encode(array("code"=>"error", "message"=>"Counter ID can't be empty"));
			}
			
			break;
		case "count_of_counter":
			$result = mysqli_query($mysqli,"SELECT COUNT(counter) as ccounter FROM counter_management");
            $array2 = array();
            
			while($row = mysqli_fetch_assoc($result)) {
				array_push($array2,array('count'=>$row['ccounter']));
			}
			$array = array("code"=>"success", "message"=>"",'aryresultlist'=>$array2);
			echo json_encode($array);

			break;
			
		case "update_counter_status":
			if(isset($_POST['cID']) && $_POST['cID'] != "" && isset($_POST['status']) && $_POST['status'] != ""){
				$cID = $_POST['cID'];
				$status = $_POST['status'];
				if(mysqli_query($mysqli, "UPDATE counter_management SET status = '$status' WHERE counter = '$cID'")){
					echo json_encode(array("code"=>"success", "message"=>"Status update successfully"));
				}else{
					echo json_encode(array("code"=>"error", "message"=>mysqli_error($mysqli)));
				}
				
			}else{
				if(!isset($_POST['cID']) && $_POST['cID'] == ""){
					echo json_encode(array("code"=>"error", "message"=>"Counter ID can't be empty"));
				}else{
					echo json_encode(array("code"=>"error", "message"=>"Status can't be empty"));
				}
				
			}
			
			break;	
			
		case "complete_current":
			if(isset($_POST['cID']) && $_POST['cID'] != "" ){
				$cID = $_POST['cID'];
				
				
				
				if(mysqli_query($mysqli, "UPDATE counter_management SET current_number = null WHERE counter = '$cID'")){
					echo json_encode(array("code"=>"success", "message"=>"Current_number update successfully"));
				}else{
					echo json_encode(array("code"=>"error", "message"=>mysqli_error($mysqli)));
				}
				
			}else{
				echo json_encode(array("code"=>"error", "message"=>"Counter ID can't be empty"));
			}
			
			break;
		
		case "call_next":
			if(isset($_POST['cID']) && $_POST['cID'] != "" ){
				$cID = $_POST['cID'];
				
				if(mysqli_query($mysqli, "UPDATE counter_management SET current_number = 'SELECT id FROM number WHERE status = waiting ORDER BY id ASC LIMIT 1' WHERE counter = '$cID'")){
					echo json_encode(array("code"=>"success", "message"=>"Current_number update successfully"));
				}else{
					echo json_encode(array("code"=>"error", "message"=>mysqli_error($mysqli)));
				}
				
			}else{
				echo json_encode(array("code"=>"error", "message"=>"Counter ID can't be empty"));
			}
			
			break;
		
			
		default:
			echo json_encode(array("code"=>"error", "message"=>"Action not found"));
			break;
	}
?>
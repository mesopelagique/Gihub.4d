Class extends Model

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	
	If (This:C1470.assignee#Null:C1517)
		This:C1470.assignee:=cs:C1710.User.new(This:C1470.assignee)
	End if 
	// TODO assignees
	
	If (This:C1470.repository#Null:C1517)
		This:C1470.repository:=cs:C1710.Repository.new(This:C1470.repository)
	End if 
	
	If (This:C1470.pull_request#Null:C1517)
		This:C1470.pull_request:=cs:C1710.PullRequest.new(This:C1470.pull_request)
	End if 
	
	If (This:C1470.user#Null:C1517)
		This:C1470.user:=cs:C1710.User.new(This:C1470.user)
	End if 
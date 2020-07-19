Class extends Model

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	If (This:C1470.owner#Null:C1517)
		If (This:C1470.owner.type="Organization")
			This:C1470.owner:=cs:C1710.Organization.new(This:C1470.owner)
		Else 
			This:C1470.owner:=cs:C1710.User.new(This:C1470.owner)
		End if 
	End if 
	
Function createEntryPoint
	C_TEXT:C284($0)
	// https://developer.github.com/v3/repos/#create-a-repository-for-the-authenticated-user
	
	If (This:C1470.owner#Null:C1517)
		
		If (String:C10(This:C1470.owner.type)="Organization")
			// https://developer.github.com/v3/repos/#create-an-organization-repository
			$0:="orgs/"+This:C1470.owner.name+"/repos"
		Else 
			$0:="user/repos"
		End if 
		
	Else 
		$0:="user/repos"
	End if 
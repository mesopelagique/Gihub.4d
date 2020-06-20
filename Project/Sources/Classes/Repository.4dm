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
Class constructor
	
	This:C1470.baseURL:="https://api.github.com/"
	This:C1470.headers:=New object:C1471()  //"Accept";"application/vnd.github.v3+json")
	
	// MARK: API Endpoint
	
/* Return information about connected user */
Function user
	C_OBJECT:C1216($0)
	$0:=This:C1470.request("user";HTTP GET method:K71:1;cs:C1710.User)
	
Function issues
	C_OBJECT:C1216($0)
	$0:=This:C1470.request("issues";HTTP GET method:K71:1;cs:C1710.Issue)
	
Function apps
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	$0:=This:C1470.request("apps/"+$1;HTTP GET method:K71:1;cs:C1710.App)
	
Function app
	C_OBJECT:C1216($0)
	$0:=This:C1470.request("app/";HTTP GET method:K71:1;cs:C1710.App)
	
Function repositories
	C_OBJECT:C1216($0)
	$0:=This:C1470.request("repositories";HTTP GET method:K71:1;cs:C1710.Repository)
	
Function userRepositories
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	$0:=This:C1470.request("users/"+$1+"/repos";HTTP GET method:K71:1;cs:C1710.Repository)
	
Function orgRepositories
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	$0:=This:C1470.request("orgs/"+$1+"/repos";HTTP GET method:K71:1;cs:C1710.Repository)
	
	
	// MARK: Authentication: https://developer.github.com/v3/auth/
/* 
Connect with basic auth
It could be client id and secret for server-to-server scenario: https://developer.github.com/v3/#oauth2-keysecret
Or username + key
*/
Function authBasic
	C_TEXT:C284($1;$2)
	C_BLOB:C604($tmpBlob)
	
	C_TEXT:C284($toEncode)
	$toEncode:=$1+":"+$2
	TEXT TO BLOB:C554($toEncode;$tmpBlob;UTF8 text without length:K22:17)
	BASE64 ENCODE:C895($tmpBlob;$toEncode)
	
	This:C1470.headers["Authorization"]:="Basic "+$toEncode
	
/*
 Authenticate by passing a token 
*/
Function authToken
	C_TEXT:C284($1/*token*/)
	This:C1470.headers["Authorization"]:="token "+$1
	
Function authJWT
	C_OBJECT:C1216($1)  // pem file
	C_LONGINT:C283($2)  // app id
	
	// https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-a-github-app
	// https://github.com/gr2m/universal-github-app-jwt
	
	$settings:=New object:C1471(\
		"type";"PEM";\
		"pem";$1.getText())
	
	// Get CryptoKey class reference
	$key:=cs:C1710.JWT.new($settings)
	
	$options:=New object:C1471("algorithm";"RS256")
	$header:=New object:C1471("alg";$options.algorithm;"type";"JWT"/*;"kid";$1.authKeyId*/)
	
	// Get current date and time avoiding timezone issues
	
	C_TIME:C306($currentTime;$timeGMT)
	C_DATE:C307($dateGMT)
	C_LONGINT:C283($iat)
	$currentTime:=Current time:C178
	$timeGMT:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$currentTime);1;11);"Z";""))
	$dateGMT:=Date:C102(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$currentTime);12;20)+"00:00:00")
	$iat:=(($dateGMT-Add to date:C393(!00-00-00!;1970;1;1))*86400)+($timeGMT+0)
	
	$payload:=New object:C1471("iat";$iat;"expiration";$iat+60;"iss";$2)  // expire in 1 minute
	
	// Sign
	$signature:=$key.sign($header;$payload;$options)
	This:C1470.headers["Authorization"]:="Bearer "+$signature
	
	// MARK: Network request
	
/* Make the final request */
Function request
	C_TEXT:C284($1;$path)
	C_TEXT:C284($2;$method)  // opt method (default GET)
	C_OBJECT:C1216($3)  // opt class
	
	C_TEXT:C284($body)
	C_TEXT:C284($response)
	C_LONGINT:C283($code)
	C_TEXT:C284($url)
	
	$path:=$1
	If ($path[[1]]="/")  // remove first / if any, already in base url
		$path:=Substring:C12($path;2)
	End if 
	$body:=""
	
	If (Count parameters:C259>1)
		$method:=$2
	Else 
		$method:=HTTP GET method:K71:1  // default
	End if 
	
	ARRAY TEXT:C222($headerNames;0)
	ARRAY TEXT:C222($headerValues;0)
	For each ($key;This:C1470.headers)
		APPEND TO ARRAY:C911($headerNames;$key)
		APPEND TO ARRAY:C911($headerValues;This:C1470.headers[$key])
	End for each 
	
	$url:=This:C1470.baseURL+$path
	
	$code:=HTTP Request:C1158($method;$url;$body;$response;$headerNames;$headerValues)
	
	If ($code>399)
		$0:=cs:C1710.Error.new(JSON Parse:C1218($response))
		$0.code:=$code
		$0.success:=False:C215
	Else 
		$0:=New object:C1471("code";$code;"value";JSON Parse:C1218($response))
		$0.success:=True:C214
		
		If (Count parameters:C259>2)  // decode using a class
			Case of 
				: (Value type:C1509($0.value)=Is object:K8:27)
					$0.value:=$3.new($0.value)
				: (Value type:C1509($0.value)=Is collection:K8:32)
					C_COLLECTION:C1488($col)
					$col:=New collection:C1472()  // it will better have map with formula
					For each ($value;$0.value)
						$col.push($3.new($value))
					End for each 
					$0.value:=$col
				Else 
					$0.success:=False:C215  // cannot decode
			End case 
		End if 
		
	End if 
	
	
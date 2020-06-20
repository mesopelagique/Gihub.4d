//%attributes = {}

C_OBJECT:C1216($github;$result)

$github:=github.API.new()

// $github.authBasic("mesopelagique";"passwork or api key")

//$result:=$github.request("/user")
//$result:=$github.user()

//$result:=$github.request("/issues")
//$result:=$github.issues()

// GET repositories: https://developer.github.com/v3/repos

//$result:=$github.request("/repositories")
//$result:=$github.repositories()

//$result:=$github.request("/users/mesopelagique/repos")
//$result:=$github.userRepositories("mesopelagique")

//$result:=$github.request("/orgs/4D/repos")
//$result:=$github.orgRepositories("4D")

// Get topics of repository. a special header mus be added https://developer.github.com/apps/
//$github.headers["Accept"]:="application/vnd.github.mercy-preview+json"
//$result:=$github.request("/repos/mesopelagique/Tricho/topics")

// GET an app https://developer.github.com/v3/apps/#get-an-app
//$github.headers["Accept"]:="application/vnd.github.machine-man-preview+json"
//$result:=$github.apps("4DJWT")

// GET the authenticated app https://developer.github.com/v3/apps/#get-the-authenticated-app

$github.authJWT(Folder:C1567(fk resources folder:K87:11).file("app.private-key.pem");69584)

$result:=$github.app()  // must be authenticated as app
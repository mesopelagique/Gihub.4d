
# Github API with 4D

```4d
$github:=github.API.new()
```

## Authenticate

### Basic auth

- https://developer.github.com/v3/auth/#basic-authentication
- https://developer.github.com/v3/#oauth2-keysecret

```4d
$github.authBasic("username";"passwork or api key")
```

### Token

https://developer.github.com/v3/#oauth2-token-sent-in-a-header

```4d
$github.authToken("a token")
```

### 🚧 JWT

> to come

## Doing a request

Example: Getting information about current authenticated user

```4d
$result:=$github.request("/user")
```

### Cheking result

| $result attribute |Description | 
|--|-- | 
| `.success` | Will return `True` if the request was successful, `False` otherwise | 
| `.value` | The requested data decoded as object or collection | 
| `.code` | The HTTP code returned by request | 

If `$result.success`is `False` you will receive an `Error` object with basic information about the issue like `.message`.

### Endpoints

To help with request some github api endpoints are already implemented. This endpoints will decode into class instances.

#### Get information of user authenticated

https://developer.github.com/v3/users/#get-the-authenticated-user

```4d
$result:=$github.user()
```

`$result.value` will be an `User` object if success.

#### List repositories for the authenticated user

https://developer.github.com/v3/repos/#list-repositories-for-the-authenticated-user

```4d
$result:=$github.repositories()
```

`$result.value` will be a collection of `Repository` objects if success.

#### Create a repository for the authenticated used

https://developer.github.com/v3/repos/#create-a-repository-for-the-authenticated-user
 
```4d
$repo:=github.Repository.new(New object("name"; "MyRepo"))
$result:=$github.create($repo)
```

`$result.value` will be a `Repository` object if success.

##### Create an organization repository

https://developer.github.com/v3/repos/#create-an-organization-repository

```4d
$repo:=github.Repository.new(New object("name"; "MyRepo"; \
    "owner"; github.Organization.new(New object("name"; "OeOrga"))))
$result:=$github.create($repo)
```

`$result.value` will be a `Repository` object if success.

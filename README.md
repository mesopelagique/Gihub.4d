
# Github API with 4D

$github:=github()

## Authenticate

### Basic auth

```4d
$github.authBasic("username";"passwork or api key")
```

### Token

```4d
$github.authToken("a token")
```

### 🚧 JWT

> to come

## Doing request

Example: Getting information about current authenticated user

```4d
$result:=$github.request("/user")
```

### Cheking result

```4d
ASSERT($result.success)
```

If `$result.success`is `False` you will receive an `Error` object with basic information about the issue, otherwise a `$result.value` will contains the requested data.

### Endpoints

To help with request some github api endpoints are already implemented. This endpoints will decode into class instance.s

#### Get information of user authenticated

```4d
$result:=$github.user()
// $result.value is a User object.
```

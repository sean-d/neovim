# RESTful Testing

This guide covers how to test REST APIs directly in Neovim using kulala.nvim.

## Overview

Kulala provides HTTP request testing with:
- Support for `.http` and `.rest` files
- Environment variables and multiple environments
- Response viewing in horizontal split
- Request history and replay
- Import/export from cURL
- Status icons (⏳ loading, ✅ done, ❌ error)

## File Format

Create files with `.http` or `.rest` extension:

```http
# Get all users
GET https://api.example.com/users
Accept: application/json
Authorization: Bearer {{auth_token}}

###

# Create a user
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```

## Key Bindings

All REST commands use the `<leader>r` prefix:

| Key | Description |
|-----|-------------|
| `<leader>rr` | Send request under cursor |
| `<leader>ra` | Run all requests in file |
| `<leader>rp` | Replay last request |
| `<leader>rq` | Close response window |
| `<leader>rc` | Copy request as cURL |
| `<leader>ri` | Import from cURL |
| `<leader>rs` | Open REST scratchpad |
| `<leader>re` | Select environment |
| `<leader>rv` | Show request statistics |

## Environment Variables

Create `.env` files for different environments:

### `.env.local`
```env
base_url=http://localhost:3000
auth_token=local-dev-token
```

### `.env.production`
```env
base_url=https://api.example.com
auth_token=prod-token-here
```

Use variables in requests:
```http
GET {{base_url}}/users
Authorization: Bearer {{auth_token}}
```

## Request Syntax

### Basic Request
```http
GET https://api.example.com/resource
```

### With Headers
```http
GET https://api.example.com/resource
Accept: application/json
Authorization: Bearer token123
```

### With Body
```http
POST https://api.example.com/resource
Content-Type: application/json

{
  "key": "value"
}
```

### Request Separators
Use `###` to separate multiple requests:
```http
# First request
GET https://api.example.com/users

###

# Second request
GET https://api.example.com/posts
```

## Named Requests

Name requests for better organization:
```http
# @name get_all_users
GET https://api.example.com/users

###

# @name create_user
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "Test User"
}
```

Status icons appear above requests:
- ⏳ Request in progress
- ✅ Request completed successfully
- ❌ Request failed

## Response Handling

Responses appear in a horizontal split at the bottom with:
- Status code and headers
- Formatted JSON/XML bodies (body view by default)
- Response time statistics
- Press `q` in the response buffer to close
- Use `<leader>rq` to intelligently close the response window

## Configuration

Kulala is configured with:
- **Response Location**: Horizontal split at the bottom
- **Default View**: Body view (not headers)
- **Status Icons**: Above each request
- **Scratchpad**: Automatically converts to HTTP file format
- **Smart Close**: `<leader>rq` avoids closing your HTTP file

## Tips

### Testing Workflow
1. Create an `.http` file
2. Write your requests
3. `<leader>rr` to test
4. `<leader>rv` to see timing
5. Response appears in bottom split
6. Press `q` in response or `<leader>rq` to close

### Organization
- Keep API collections in `api/` directory
- Use `.env.local` for local development
- Use request names for documentation

### Debugging
- Check response headers with stats view
- Use `<leader>rc` to copy as cURL for external testing
- Import complex cURL commands with `<leader>ri`


## Examples

### REST API CRUD Operations
```http
# List all items
# @name list_items
GET {{base_url}}/api/items
Accept: application/json

###

# Get single item
# @name get_item
GET {{base_url}}/api/items/123

###

# Create item
# @name create_item
POST {{base_url}}/api/items
Content-Type: application/json

{
  "name": "New Item",
  "price": 29.99
}

###

# Update item
# @name update_item
PUT {{base_url}}/api/items/123
Content-Type: application/json

{
  "name": "Updated Item",
  "price": 39.99
}

###

# Delete item
# @name delete_item
DELETE {{base_url}}/api/items/123
```

### GraphQL Example
```http
# @name graphql_query
POST {{graphql_endpoint}}
Content-Type: application/json

{
  "query": "{ users { id name email } }"
}
```

### File Upload
```http
# @name upload_file
POST {{base_url}}/upload
Content-Type: multipart/form-data; boundary=boundary123

--boundary123
Content-Disposition: form-data; name="file"; filename="test.txt"
Content-Type: text/plain

File contents here
--boundary123--
```

---
[← Back to Markdown](markdown.md) | [Trouble - Code Issues & Navigation →](trouble.md)
# API Documentation

## Authentication

### POST /api/auth/login
Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

## Transactions

### GET /api/transactions
Returns a list of transactions.

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)
- `startDate` (string): Start date filter (ISO format)
- `endDate` (string): End date filter (ISO format)
- `category` (string): Category filter

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "amount": 100.50,
      "type": "expense",
      "category": "Food",
      "description": "Groceries",
      "date": "2024-01-01T00:00:00Z"
    }
  ],
  "total": 1,
  "page": 1,
  "limit": 10
}
```

### POST /api/transactions
Creates a new transaction.

**Request Body:**
```json
{
  "amount": 100.50,
  "type": "expense",
  "category": "Food",
  "description": "Groceries",
  "date": "2024-01-01T00:00:00Z"
}
```

**Response:**
```json
{
  "id": 1,
  "amount": 100.50,
  "type": "expense",
  "category": "Food",
  "description": "Groceries",
  "date": "2024-01-01T00:00:00Z"
}
```

## Categories

### GET /api/categories
Returns a list of categories.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Food",
      "type": "expense",
      "color": "#FF0000"
    }
  ]
}
```

### POST /api/categories
Creates a new category.

**Request Body:**
```json
{
  "name": "Food",
  "type": "expense",
  "color": "#FF0000"
}
```

**Response:**
```json
{
  "id": 1,
  "name": "Food",
  "type": "expense",
  "color": "#FF0000"
}
```

## Analytics

### GET /api/analytics/balance
Returns the current balance and summary.

**Response:**
```json
{
  "balance": 1000.50,
  "income": 2000.00,
  "expenses": 999.50,
  "period": "2024-01"
}
```

### GET /api/analytics/category-distribution
Returns the distribution of expenses by category.

**Query Parameters:**
- `startDate` (string): Start date filter (ISO format)
- `endDate` (string): End date filter (ISO format)

**Response:**
```json
{
  "data": [
    {
      "category": "Food",
      "amount": 500.00,
      "percentage": 50
    }
  ]
}
```

## Error Responses

All API endpoints may return the following error responses:

**400 Bad Request:**
```json
{
  "error": "Invalid request data",
  "details": {
    "field": "Error message"
  }
}
```

**401 Unauthorized:**
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

**404 Not Found:**
```json
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

**500 Internal Server Error:**
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
``` 
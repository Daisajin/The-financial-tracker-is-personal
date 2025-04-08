# Примеры использования API

## Аутентификация

### Вход в систему
```javascript
const login = async () => {
  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'user@example.com',
        password: 'password123',
      }),
    });

    const data = await response.json();
    localStorage.setItem('token', data.token);
  } catch (error) {
    console.error('Login failed:', error);
  }
};
```

## Транзакции

### Получение списка транзакций
```javascript
const getTransactions = async (page = 1, limit = 10) => {
  try {
    const response = await fetch(
      `/api/transactions?page=${page}&limit=${limit}`,
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('token')}`,
        },
      }
    );

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch transactions:', error);
  }
};
```

### Создание новой транзакции
```javascript
const createTransaction = async (transaction) => {
  try {
    const response = await fetch('/api/transactions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
      body: JSON.stringify(transaction),
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to create transaction:', error);
  }
};
```

## Категории

### Получение списка категорий
```javascript
const getCategories = async () => {
  try {
    const response = await fetch('/api/categories', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch categories:', error);
  }
};
```

### Создание новой категории
```javascript
const createCategory = async (category) => {
  try {
    const response = await fetch('/api/categories', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
      body: JSON.stringify(category),
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to create category:', error);
  }
};
```

## Аналитика

### Получение баланса
```javascript
const getBalance = async () => {
  try {
    const response = await fetch('/api/analytics/balance', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch balance:', error);
  }
};
```

### Получение распределения по категориям
```javascript
const getCategoryDistribution = async (startDate, endDate) => {
  try {
    const response = await fetch(
      `/api/analytics/category-distribution?startDate=${startDate}&endDate=${endDate}`,
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('token')}`,
        },
      }
    );

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch category distribution:', error);
  }
};
```

## Обработка ошибок

### Пример обработки ошибок
```javascript
const handleApiError = (error) => {
  if (error.response) {
    switch (error.response.status) {
      case 400:
        console.error('Invalid request:', error.response.data);
        break;
      case 401:
        console.error('Unauthorized:', error.response.data);
        // Перенаправление на страницу входа
        window.location.href = '/login';
        break;
      case 404:
        console.error('Resource not found:', error.response.data);
        break;
      case 500:
        console.error('Server error:', error.response.data);
        break;
      default:
        console.error('Unknown error:', error);
    }
  } else {
    console.error('Network error:', error);
  }
};
```

## Использование с React

### Пример компонента для отображения транзакций
```typescript
import React, { useEffect, useState } from 'react';
import { Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper } from '@mui/material';

interface Transaction {
  id: number;
  amount: number;
  type: string;
  category: string;
  description: string;
  date: string;
}

const TransactionsList: React.FC = () => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchTransactions = async () => {
      try {
        const response = await fetch('/api/transactions', {
          headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch transactions');
        }

        const data = await response.json();
        setTransactions(data.data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred');
      } finally {
        setLoading(false);
      }
    };

    fetchTransactions();
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <TableContainer component={Paper}>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Date</TableCell>
            <TableCell>Description</TableCell>
            <TableCell>Category</TableCell>
            <TableCell>Amount</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {transactions.map((transaction) => (
            <TableRow key={transaction.id}>
              <TableCell>{new Date(transaction.date).toLocaleDateString()}</TableCell>
              <TableCell>{transaction.description}</TableCell>
              <TableCell>{transaction.category}</TableCell>
              <TableCell>{transaction.amount}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default TransactionsList;
``` 
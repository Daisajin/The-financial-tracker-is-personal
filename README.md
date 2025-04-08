# Personal Finance Tracker

A comprehensive personal finance tracking application built with React, Flask, and SQLite.

## Features

- Transaction management (income and expenses)
- Category management
- Analytics and visualization
- Responsive design
- Error handling and user feedback
- Data persistence with SQLite

## Tech Stack

### Frontend
- React
- Material-UI
- Chart.js
- Axios
- React Router

### Backend
- Flask
- SQLite
- SQLAlchemy
- Flask-Migrate

## Project Structure

```
.
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── routes.py
│   │   └── analytics.py
│   ├── migrations/
│   ├── .env
│   ├── config.py
│   ├── requirements.txt
│   └── run.py
└── frontend/
    ├── public/
    ├── src/
    │   ├── components/
    │   ├── pages/
    │   ├── utils/
    │   ├── App.js
    │   └── index.js
    ├── .env
    └── package.json
```

## Setup Instructions

### Backend Setup

1. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Update the values as needed

4. Initialize the database:
   ```bash
   python init_db.py
   ```

5. Run the Flask server:
   ```bash
   python run.py
   ```

### Frontend Setup

1. Install dependencies:
   ```bash
   cd frontend
   npm install
   ```

2. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Update the values as needed

3. Start the development server:
   ```bash
   npm start
   ```

## API Documentation

### Transactions
- `GET /api/transactions` - Get all transactions
- `POST /api/transactions` - Create a new transaction
- `PUT /api/transactions/<id>` - Update a transaction
- `DELETE /api/transactions/<id>` - Delete a transaction

### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create a new category
- `PUT /api/categories/<id>` - Update a category
- `DELETE /api/categories/<id>` - Delete a category

### Analytics
- `GET /api/analytics/balance` - Get balance summary
- `GET /api/analytics/category-distribution` - Get category distribution
- `GET /api/analytics/monthly-trends` - Get monthly trends

## Error Handling

The application includes a comprehensive error handling system:

- Frontend error display component for user feedback
- API error interception and formatting
- Consistent error messaging across the application
- Loading states for async operations

## New Features

### Data Export
- Export transactions and analytics data to CSV or Excel format.
- Accessible via the "Export" button in the UI.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
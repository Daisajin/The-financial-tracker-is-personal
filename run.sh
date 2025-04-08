#!/bin/bash

echo "Starting Personal Finance Tracker..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install Python 3 and try again."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js and try again."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install Node.js and try again."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "backend/venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv backend/venv || { echo "Failed to create virtual environment."; exit 1; }
fi

# Activate virtual environment
echo "Activating virtual environment..."
source backend/venv/bin/activate || { echo "Failed to activate virtual environment."; exit 1; }

# Install backend dependencies if needed
if [ ! -d "backend/venv/lib/python3.*/site-packages/flask" ]; then
    echo "Installing backend dependencies..."
    pip install -r backend/requirements.txt || { echo "Failed to install backend dependencies."; exit 1; }
fi

# Initialize database if needed
if [ ! -f "backend/app.db" ]; then
    echo "Initializing database..."
    python backend/init_db.py || { echo "Failed to initialize database."; exit 1; }
fi

# Apply database migrations
echo "Applying database migrations..."
cd backend
source venv/bin/activate
flask db upgrade || { echo "Failed to apply database migrations."; exit 1; }
cd ..

# Start backend server in the background
echo "Starting backend server..."
cd backend
source venv/bin/activate
python run.py &
BACKEND_PID=$!
cd ..

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 5

# Install frontend dependencies if needed
if [ ! -d "frontend/node_modules" ]; then
    echo "Installing frontend dependencies..."
    cd frontend
    npm install || { echo "Failed to install frontend dependencies."; exit 1; }
    cd ..
fi

# Start frontend server in the background
echo "Starting frontend server..."
cd frontend
npm start &
FRONTEND_PID=$!
cd ..

echo ""
echo "Personal Finance Tracker is starting..."
echo "Backend will be available at: http://localhost:5000"
echo "Frontend will be available at: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all servers..."

# Wait for user to press Ctrl+C
trap "kill $BACKEND_PID $FRONTEND_PID; echo 'Servers stopped.'; exit 0" INT
wait
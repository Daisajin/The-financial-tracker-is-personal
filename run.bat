@echo off

set LOG_FILE=f:\резюме\Личный финансовый трекер\log.txt

echo Starting Personal Finance Tracker... > %LOG_FILE%

REM Check if Python is installed
echo Checking Python installation... >> %LOG_FILE%
python --version >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH. Please install Python and try again. >> %LOG_FILE%
    echo Python is not installed or not in PATH. Please install Python and try again.
    pause
    exit /b 1
)

echo Python is installed. >> %LOG_FILE%

REM Check if Node.js is installed
echo Checking Node.js installation... >> %LOG_FILE%
node --version >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Node.js is not installed or not in PATH. Please install Node.js and try again. >> %LOG_FILE%
    echo Node.js is not installed or not in PATH. Please install Node.js and try again.
    pause
    exit /b 1
)

echo Node.js is installed. >> %LOG_FILE%

REM Check if npm is installed
echo Checking npm installation... >> %LOG_FILE%
npm --version >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo npm is not installed or not in PATH. Please install Node.js and try again. >> %LOG_FILE%
    echo npm is not installed or not in PATH. Please install Node.js and try again.
    pause
    exit /b 1
)

echo npm is installed. >> %LOG_FILE%

REM Create virtual environment if it doesn't exist
if not exist "backend\venv" (
    echo Creating Python virtual environment... >> %LOG_FILE%
    python -m venv backend\venv >> %LOG_FILE% 2>&1
    if %errorlevel% neq 0 (
        echo Failed to create virtual environment. >> %LOG_FILE%
        echo Failed to create virtual environment.
        pause
        exit /b 1
    )
)

echo Virtual environment is ready. >> %LOG_FILE%

REM Activate virtual environment
echo Activating virtual environment... >> %LOG_FILE%
call backend\venv\Scripts\activate >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Failed to activate virtual environment. >> %LOG_FILE%
    echo Failed to activate virtual environment.
    pause
    exit /b 1
)

echo Virtual environment activated. >> %LOG_FILE%

REM Install backend dependencies if needed
echo Installing backend dependencies... >> %LOG_FILE%
pip install -r backend\requirements.txt >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Failed to install backend dependencies. >> %LOG_FILE%
    echo Failed to install backend dependencies.
    pause
    exit /b 1
)

echo Backend dependencies installed. >> %LOG_FILE%

REM Initialize database if needed
if not exist "backend\app.db" (
    echo Initializing database... >> %LOG_FILE%
    python backend\init_db.py >> %LOG_FILE% 2>&1
    if %errorlevel% neq 0 (
        echo Failed to initialize database. >> %LOG_FILE%
        echo Failed to initialize database.
        pause
        exit /b 1
    )
)

echo Database initialized. >> %LOG_FILE%

REM Start backend server in a new window
echo Starting backend server... >> %LOG_FILE%
start cmd /k "cd backend && call venv\Scripts\activate && python run.py" >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Failed to start backend server. >> %LOG_FILE%
    echo Failed to start backend server.
    pause
    exit /b 1
)

echo Backend server started. >> %LOG_FILE%

REM Wait for backend to start
echo Waiting for backend to start... >> %LOG_FILE%
timeout /t 5 /nobreak >> %LOG_FILE%

REM Install frontend dependencies if needed
if not exist "frontend\node_modules" (
    echo Installing frontend dependencies... >> %LOG_FILE%
    cd frontend
    npm install >> %LOG_FILE% 2>&1
    if %errorlevel% neq 0 (
        echo Failed to install frontend dependencies. >> %LOG_FILE%
        echo Failed to install frontend dependencies.
        pause
        exit /b 1
    )
    cd ..
)

echo Frontend dependencies installed. >> %LOG_FILE%

REM Start frontend server in a new window
echo Starting frontend server... >> %LOG_FILE%
cd frontend
start cmd /k "npm start" >> %LOG_FILE% 2>&1
if %errorlevel% neq 0 (
    echo Failed to start frontend server. >> %LOG_FILE%
    echo Failed to start frontend server.
    pause
    exit /b 1
)
cd ..

echo Frontend server started. >> %LOG_FILE%

echo. >> %LOG_FILE%
echo Personal Finance Tracker is starting... >> %LOG_FILE%
echo Backend will be available at: http://localhost:5000 >> %LOG_FILE%
echo Frontend will be available at: http://localhost:3000 >> %LOG_FILE%
echo. >> %LOG_FILE%
echo Press any key to close all servers... >> %LOG_FILE%
pause >nul

REM Kill all Python and Node processes
echo Stopping servers... >> %LOG_FILE%
taskkill /f /im python.exe >> %LOG_FILE% 2>&1
taskkill /f /im node.exe >> %LOG_FILE% 2>&1

echo Servers stopped. >> %LOG_FILE%
import axios from 'axios';

// Создаем экземпляр axios с базовой конфигурацией
const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || '/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Перехватчик для обработки ошибок
api.interceptors.response.use(
  (response) => response,
  (error) => {
    // Обработка ошибок сети
    if (!error.response) {
      console.error('Network Error:', error);
      throw new Error('Network error occurred. Please check your connection.');
    }

    // Обработка ошибок сервера
    const { status, data } = error.response;
    let errorMessage = 'An error occurred. Please try again.';

    if (data && data.message) {
      errorMessage = data.message;
    } else if (status === 404) {
      errorMessage = 'Resource not found.';
    } else if (status === 500) {
      errorMessage = 'Server error occurred. Please try again later.';
    }

    console.error(`API Error (${status}):`, errorMessage);
    throw new Error(errorMessage);
  }
);

export default api; 
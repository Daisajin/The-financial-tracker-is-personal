import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import * as Sentry from '@sentry/react';
import { BrowserTracing } from '@sentry/tracing';
import { Analytics } from '@vercel/analytics/react';

// Инициализация Sentry
Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  integrations: [new BrowserTracing()],
  tracesSampleRate: 1.0,
  environment: process.env.NODE_ENV,
});

// Типы для метрик производительности
interface PerformanceMetrics {
  pageLoadTime: number;
  apiResponseTime: number;
  renderTime: number;
}

// Утилита для логирования ошибок
export const logError = (error: Error, context?: Record<string, unknown>) => {
  console.error('Application error:', error, context);
  Sentry.captureException(error, { extra: context });
};

// Утилита для логирования метрик производительности
export const logPerformanceMetrics = (metrics: PerformanceMetrics) => {
  console.log('Performance metrics:', metrics);
  Sentry.addBreadcrumb({
    category: 'performance',
    message: 'Performance metrics recorded',
    level: 'info',
    data: metrics,
  });
};

// Хук для отслеживания навигации
export const useNavigationTracking = () => {
  const location = useLocation();

  useEffect(() => {
    // Отправляем событие в Sentry при смене страницы
    Sentry.addBreadcrumb({
      category: 'navigation',
      message: `Navigated to ${location.pathname}`,
      level: 'info',
      data: {
        path: location.pathname,
        search: location.search,
        hash: location.hash,
      },
    });
  }, [location]);
};

// Компонент для аналитики
export const AnalyticsProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <>
      <Analytics />
      {children}
    </>
  );
};

// Утилита для rate limiting
export const createRateLimiter = (limit: number, interval: number) => {
  let count = 0;
  let lastReset = Date.now();

  return () => {
    const now = Date.now();
    if (now - lastReset >= interval) {
      count = 0;
      lastReset = now;
    }

    if (count >= limit) {
      throw new Error('Rate limit exceeded');
    }

    count++;
    return true;
  };
}; 
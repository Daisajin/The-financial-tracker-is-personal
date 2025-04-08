import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import Navigation from '../Navigation';

describe('Navigation Component', () => {
  const renderNavigation = () => {
    return render(
      <BrowserRouter>
        <Navigation />
      </BrowserRouter>
    );
  };

  it('renders without crashing', () => {
    renderNavigation();
    expect(screen.getByText('Finance Tracker')).toBeInTheDocument();
  });

  it('renders all menu items', () => {
    renderNavigation();
    expect(screen.getByText('Dashboard')).toBeInTheDocument();
    expect(screen.getByText('Transactions')).toBeInTheDocument();
    expect(screen.getByText('Categories')).toBeInTheDocument();
    expect(screen.getByText('Analytics')).toBeInTheDocument();
  });

  it('toggles mobile drawer when menu button is clicked', () => {
    renderNavigation();
    const menuButton = screen.getByLabelText('open drawer');
    fireEvent.click(menuButton);
    expect(screen.getByRole('presentation')).toBeInTheDocument();
  });

  it('navigates to correct route when menu item is clicked', () => {
    renderNavigation();
    const transactionsLink = screen.getByText('Transactions');
    fireEvent.click(transactionsLink);
    expect(window.location.pathname).toBe('/transactions');
  });

  it('handles navigation errors gracefully', () => {
    const originalError = console.error;
    console.error = jest.fn();
    
    const mockNavigate = jest.fn().mockImplementation(() => {
      throw new Error('Navigation error');
    });
    jest.mock('react-router-dom', () => ({
      ...jest.requireActual('react-router-dom'),
      useNavigate: () => mockNavigate,
    }));

    renderNavigation();
    const transactionsLink = screen.getByText('Transactions');
    fireEvent.click(transactionsLink);
    
    expect(console.error).toHaveBeenCalled();
    console.error = originalError;
  });
}); 
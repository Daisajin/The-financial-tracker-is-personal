import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import ErrorDisplay from '../ErrorDisplay';

describe('ErrorDisplay', () => {
  it('renders nothing when there is no error', () => {
    const { container } = render(<ErrorDisplay error={null} onClose={() => {}} />);
    expect(container.firstChild).toBeNull();
  });

  it('renders error message when error is provided', () => {
    const errorMessage = 'Test error message';
    render(<ErrorDisplay error={errorMessage} onClose={() => {}} />);
    expect(screen.getByText(errorMessage)).toBeInTheDocument();
  });

  it('calls onClose when close button is clicked', () => {
    const onClose = jest.fn();
    render(<ErrorDisplay error="Test error" onClose={onClose} />);
    fireEvent.click(screen.getByRole('button'));
    expect(onClose).toHaveBeenCalledTimes(1);
  });
}); 
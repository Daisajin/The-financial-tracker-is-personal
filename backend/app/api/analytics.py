from flask import jsonify
from app.api import bp
from app.models import Transaction, Category
from sqlalchemy import func, extract  # Добавлено для группировки по месяцам
from datetime import datetime, timedelta
import pandas as pd

@bp.route('/analytics/balance', methods=['GET'])
def get_balance():
    total_income = db.session.query(func.sum(Transaction.amount))\
        .join(Category)\
        .filter(Category.type == 'income')\
        .scalar() or 0
    
    total_expenses = db.session.query(func.sum(Transaction.amount))\
        .join(Category)\
        .filter(Category.type == 'expense')\
        .scalar() or 0
    
    return jsonify({
        'total_income': total_income,
        'total_expenses': total_expenses,
        'balance': total_income - total_expenses
    })

@bp.route('/analytics/category-distribution', methods=['GET'])
def get_category_distribution():
    # Get transactions for the last 30 days
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    
    # Get expense distribution by category
    expenses = db.session.query(
        Category.name,
        func.sum(Transaction.amount).label('total')
    ).join(Transaction)\
     .filter(Category.type == 'expense')\
     .filter(Transaction.date >= thirty_days_ago)\
     .group_by(Category.name)\
     .all()
    
    return jsonify([{
        'category': name,
        'amount': float(total)
    } for name, total in expenses])

@bp.route('/analytics/monthly-trends', methods=['GET'])
def get_monthly_trends():
    # Get transactions for the last 12 months
    twelve_months_ago = datetime.utcnow() - timedelta(days=365)
    
    # Get monthly income and expenses
    monthly_data = db.session.query(
        func.date_trunc('month', Transaction.date).label('month'),
        Category.type,
        func.sum(Transaction.amount).label('total')
    ).join(Category)\
     .filter(Transaction.date >= twelve_months_ago)\
     .group_by('month', Category.type)\
     .order_by('month')\
     .all()
    
    # Convert to pandas DataFrame for easier manipulation
    df = pd.DataFrame(monthly_data, columns=['month', 'type', 'total'])
    df['month'] = df['month'].dt.strftime('%Y-%m')  # Преобразование даты в строку

    # Pivot the data
    pivot_df = df.pivot(index='month', columns='type', values='total').fillna(0)
    
    return jsonify({
        'months': pivot_df.index.tolist(),
        'income': pivot_df.get('income', []).tolist(),
        'expenses': pivot_df.get('expense', []).tolist()
    })
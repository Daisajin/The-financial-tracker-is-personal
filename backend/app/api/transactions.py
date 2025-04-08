from flask import jsonify, request
from app import db
from app.api import bp
from app.models import Transaction, Category
from datetime import datetime

@bp.route('/transactions', methods=['GET'])
def get_transactions():
    transactions = Transaction.query.order_by(Transaction.date.desc()).all()
    return jsonify([t.to_dict() for t in transactions])

@bp.route('/transactions', methods=['POST'])
def create_transaction():
    data = request.get_json()
    
    if not all(k in data for k in ('amount', 'category_id', 'date')):
        return jsonify({'error': 'Missing required fields'}), 400
        
    try:
        amount = float(data['amount'])
        category_id = int(data['category_id'])
        date = datetime.fromisoformat(data['date'].replace('Z', '+00:00'))
    except (ValueError, TypeError):
        return jsonify({'error': 'Invalid data format'}), 400

    category = Category.query.get(category_id)
    if not category:
        return jsonify({'error': 'Category not found'}), 404

    transaction = Transaction(
        amount=amount,
        description=data.get('description', ''),
        date=date,
        category_id=category_id
    )

    db.session.add(transaction)
    db.session.commit()

    return jsonify(transaction.to_dict()), 201

@bp.route('/transactions/<int:id>', methods=['PUT'])
def update_transaction(id):
    transaction = Transaction.query.get_or_404(id)
    data = request.get_json()

    try:
        if 'amount' in data:
            transaction.amount = float(data['amount'])
        if 'description' in data:
            transaction.description = data['description']
        if 'date' in data:
            transaction.date = datetime.fromisoformat(data['date'].replace('Z', '+00:00'))
        if 'category_id' in data:
            category = Category.query.get(data['category_id'])
            if not category:
                return jsonify({'error': 'Category not found'}), 404
            transaction.category_id = data['category_id']
    except (ValueError, TypeError):
        return jsonify({'error': 'Invalid data format'}), 400

    db.session.commit()
    return jsonify(transaction.to_dict())

@bp.route('/transactions/<int:id>', methods=['DELETE'])
def delete_transaction(id):
    transaction = Transaction.query.get_or_404(id)
    db.session.delete(transaction)
    db.session.commit()
    return '', 204 
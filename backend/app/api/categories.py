from flask import jsonify, request
from app import db
from app.api import bp
from app.models import Category

@bp.route('/categories', methods=['GET'])
def get_categories():
    categories = Category.query.all()
    return jsonify([{
        'id': c.id,
        'name': c.name,
        'type': c.type
    } for c in categories])

@bp.route('/categories', methods=['POST'])
def create_category():
    data = request.get_json()
    
    if not all(k in data for k in ('name', 'type')):
        return jsonify({'error': 'Missing required fields'}), 400
        
    if data['type'] not in ['income', 'expense']:
        return jsonify({'error': 'Invalid category type'}), 400

    if Category.query.filter_by(name=data['name']).first():
        return jsonify({'error': 'Category already exists'}), 400

    category = Category(
        name=data['name'],
        type=data['type']
    )

    db.session.add(category)
    db.session.commit()

    return jsonify({
        'id': category.id,
        'name': category.name,
        'type': category.type
    }), 201

@bp.route('/categories/<int:id>', methods=['PUT'])
def update_category(id):
    category = Category.query.get_or_404(id)
    data = request.get_json()

    if 'name' in data:
        existing = Category.query.filter_by(name=data['name']).first()
        if existing and existing.id != id:
            return jsonify({'error': 'Category name already exists'}), 400
        category.name = data['name']
    
    if 'type' in data:
        if data['type'] not in ['income', 'expense']:
            return jsonify({'error': 'Invalid category type'}), 400
        category.type = data['type']

    db.session.commit()
    return jsonify({
        'id': category.id,
        'name': category.name,
        'type': category.type
    })

@bp.route('/categories/<int:id>', methods=['DELETE'])
def delete_category(id):
    category = Category.query.get_or_404(id)
    if category.transactions.count() > 0:
        return jsonify({'error': 'Cannot delete category with existing transactions'}), 400
    db.session.delete(category)
    db.session.commit()
    return '', 204 
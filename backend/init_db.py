from app import create_app, db
from app.models import Category

def init_db():
    app = create_app()
    with app.app_context():
        # Create tables
        db.create_all()

        # Check if categories already exist
        if Category.query.first() is None:
            # Default income categories
            income_categories = [
                'Salary',
                'Freelance',
                'Investments',
                'Gifts',
                'Other Income',
            ]

            # Default expense categories
            expense_categories = [
                'Housing',
                'Transportation',
                'Food',
                'Utilities',
                'Healthcare',
                'Entertainment',
                'Shopping',
                'Education',
                'Savings',
                'Other Expenses',
            ]

            # Add income categories
            for name in income_categories:
                category = Category(name=name, type='income')
                db.session.add(category)

            # Add expense categories
            for name in expense_categories:
                category = Category(name=name, type='expense')
                db.session.add(category)

            # Commit the changes
            db.session.commit()
            print('Default categories added successfully!')
        else:
            print('Categories already exist in the database.')

if __name__ == '__main__':
    init_db() 
# Internals
from datetime import datetime

# SQLAlchemy
from sqlalchemy import (MetaData, Table, Column, Integer, Numeric, String,
                        ForeignKey, DateTime, CheckConstraint, create_engine,
                        desc, cast, and_, or_, update, delete, insert)
from sqlalchemy.sql import select, func

# MetaData is a container object storing many different features of a database
metadata = MetaData()

cookies = Table('cookies', metadata,
                Column('cookie_id', Integer(), primary_key=True),
                Column('cookie_name', String(50), index=True),
                Column('cookie_recipe_url', String(255)),
                Column('cookie_sku', String(55)),
                Column('quantity', Integer()),
                Column('unit_cost', Numeric(12, 2)),
                CheckConstraint('unit_cost >= 0.00', name='unit_cost_positive')
                )

users = Table('users', metadata,
              Column('user_id', Integer(), primary_key=True),
              Column('username', String(15), nullable=False, unique=True),
              Column('email_address', String(255), nullable=False),
              Column('phone', String(20), nullable=False),
              Column('password', String(25), nullable=False),
              Column('created_on', DateTime(), default=datetime.now),
              Column('updated_on', DateTime(), default=datetime.now,
                     onupdate=datetime.now)
              )

# one-to-many relationship
orders = Table('orders', metadata,
               Column('order_id', Integer(), primary_key=True),
               Column('user_id', ForeignKey('users.user_id')),
               )

# association table
line_items = Table('line_items', metadata,
                   Column('line_items_id', Integer(), primary_key=True),
                   Column('order_id', ForeignKey('orders.order_id')),
                   Column('cookie_id', ForeignKey('cookies.cookie_id')),
                   Column('quantity', Integer()),
                   Column('extended_cost', Numeric(12, 2))
                   )

# engine = create_engine('sqlite:///cookies.db')
engine = create_engine('sqlite:///:memory:')
connection = engine.connect()
metadata.create_all(connection)

# INSERTING DATA

# Single insert as method
ins = cookies.insert().values(
    cookie_name="chocolate chip",
    cookie_recipe_url="http://some.aweso.me/cookie/recipe.html",
    cookie_sku="CC01",
    quantity="12",
    unit_cost="0.50"
)

""" Single insert as function
from sqlalchemy import insert
ins = insert(cookies.values(
    cookie_name="chocolate chip",
    ...
    unit_cost="0.50"
)"""

# Print insert statement that will be exectued, ":params"
# print(str(ins))
# Print insert statement with actual parameters that will be sent
# print(ins.compile().params)

# Execute the insert statement
result = connection.execute(ins)

# Get ID of record inserted
# print(result.inserted_primary_key)

# Insert values via execute statement
ins = cookies.insert()
result = connection.execute(
    ins,
    cookie_name='dark chocolate chip',
    cookie_recipe_url='http://some.aweso.me/cookie/recipe_dark.html',
    cookie_sku='CC02',
    quantity='1',
    unit_cost='0.75'
)
# print(result.inserted_primary_key)

# Multiple inserts using list of dictionaries
inventory_list = [
    {
        'cookie_name': 'peanut butter',
        'cookie_recipe_url': 'http://some.aweso.me/cookie/peanut.html',
        'cookie_sku': 'PB01',
        'quantity': '24',
        'unit_cost': '0.25'
    },
    {
        'cookie_name': 'oatmeal raisin',
        'cookie_recipe_url': 'http://some.okay.me/cookie/raisin.html',
        'cookie_sku': 'EWW01',
        'quantity': '100',
        'unit_cost': '1.00'
    }
]
result = connection.execute(ins, inventory_list)

# QUERYING dATA

# Simple select function
# s = select([cookies])
# Next line creates warning as data is stored as Decimals which sqlite doesn't
# support. However, SQLAlchemy does conversions that allows code to still work.
# rp = connection.execute(s)
# results = rp.fetchall()
# print(results)

# Simple select as method
s = cookies.select()
rp = connection.execute(s)
results = rp.fetchall()

# Handling rows with a ResultProxy
""" A ResultProxy is a wrapper around a DBAPI cursor object, and its main goal
is to make it easier to use and manipulate the results of a statement. For
example, it makes it easier by allowing access using an index, name, or Column
object. """
# Get the first row of the ResultProxy from above
first_row = results[0]
# Access column by index
first_row[1]
# Access column by name.
first_row.cookie_name
# Access column by Column object.
first_row[cookies.c.cookie_name]

# Iterating over a ResultProxy
"""
rp = connection.execute(s)
for record in rp:
    print(record.cookie_name)
"""

# Select only cookie_name and quantity
s = select([cookies.c.cookie_name, cookies.c.quantity])
rp = connection.execute(s)
print(rp.keys())  # return list of columns
result = rp.first()  # return only first result
print(result)

# Order by quantity ascending
s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(cookies.c.quantity)
rp = connection.execute(s)


def print_cookie_quant():
    for cookie in rp:
        print('{} - {}'.format(cookie.quantity, cookie.cookie_name))
    print()


print_cookie_quant()

# Order by quantity descending
s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(desc(cookies.c.quantity))
rp = connection.execute(s)
print_cookie_quant()

# LIMITING

# Ex 2-12 - two smallest cookie inventories
s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(cookies.c.quantity)
s = s.limit(2)
rp = connection.execute(s)
print([result.cookie_name for result in rp])

# Built-In SQL Functions and Labels
s = select([func.sum(cookies.c.quantity)])
rp = connection.execute(s)
print(rp.scalar())  # scalar returns only leftmost column in first record

# Ex 2-15. Counting our inventory records
s = select([func.count(cookies.c.cookie_name)])
rp = connection.execute(s)
record = rp.first()
print(record.keys())  # Shows columns from rp 'ResultProxy'
print(record.count_1)  # Column name is autogenerated
print()

# Ex 2-16. Renaming our count column
# Repeats about but explicitly names first colum of results
s = select([func.count(cookies.c.cookie_name).label('inventory_count')])
# The label function is applied to the column cookie_name
rp = connection.execute(s)
record = rp.first()
print(record.keys())
print(record.inventory_count)

# Filtering
# Ex 2-17. Filtering by cookie name
s = select([cookies]).where(cookies.c.cookie_name == 'chocolate chip')
rp = connection.execute(s)
record = rp.first()
print(record.items())  # Items method lists columns and values

# Ex 2-18. Finding names with chocolate in them
s = select([cookies]).where(cookies.c.cookie_name.like("%chocolate%"))
rp = connection.execute(s)
for record in rp.fetchall():
    print(record.cookie_name)

# Operators
# Ex 2-19. String concatenation with +
s = select([cookies.c.cookie_name, 'SKU-' + cookies.c.cookie_sku])
for row in connection.execute(s):
    print(row)

# Ex 2-20. Inventory value by cookie

s = select([cookies.c.cookie_name,
            cast((cookies.c.quantity * cookies.c.unit_cost),
                 Numeric(12, 2)).label('inv_cost')])  # names column
for row in connection.execute(s):
    print(f'{row.cookie_name} - £{row.inv_cost}')

# Ex 2-21. Using the and_() conjunction

s = select([cookies]).where(
    and_(
        cookies.c.quantity > 23,
        cookies.c.unit_cost < 0.40
    )
)
for row in connection.execute(s):
    print(row.cookie_name)

# Ex 2-22. Using the or() conjunction

s = select([cookies]).where(
    or_(
        cookies.c.quantity.between(10, 50),
        cookies.c.cookie_name.contains('chip')
    )
)
print()
for row in connection.execute(s):
    print(row.cookie_name)

# Updating Data

# Ex 2-23. Updating data
u = update(cookies).where(cookies.c.cookie_name == "chocolate chip")
u = u.values(quantity=(cookies.c.quantity + 120))
result = connection.execute(u)
print(result.rowcount)  # Prints number of rows updated
s = select([cookies]).where(cookies.c.cookie_name == "chocolate chip")
result = connection.execute(s).first()
for key in result.keys():
    print('{:>20}: {}'.format(key, result[key]))

# Deleting Data

# Ex 2-24. Deleting data
u = delete(cookies).where(cookies.c.cookie_name == "dark chocolate chip")
result = connection.execute(u)
print(result.rowcount)

s = select([cookies]).where(cookies.c.cookie_name == "dark chocolate chip")
result = connection.execute(s).fetchall()
print(len(result))

# Adding more data

customer_list = [
    {
        'username': 'cookiemon',
        'email_address': 'mon@cookie.com',
        'phone': '111-111-1111',
        'password': 'password'
    },
    {
        'username': 'cakeeater',
        'email_address': 'cakeeater@cake.com',
        'phone': '222-222-2222',
        'password': 'password'
    },
    {
        'username': 'pieguy',
        'email_address': 'guy@pie.com',
        'phone': '333-333-3333',
        'password': 'password'
    }
]
ins = users.insert()
result = connection.execute(ins, customer_list)

ins = insert(orders).values(user_id=1, order_id=1)
result = connection.execute(ins)
ins = insert(line_items)
order_items = [
    {
        'order_id': 1,
        'cookie_id': 1,
        'quantity': 2,
        'extended_cost': 1.00
    },
    {
        'order_id': 1,
        'cookie_id': 3,
        'quantity': 12,
        'extended_cost': 3.00
    }
]
result = connection.execute(ins, order_items)
ins = insert(orders).values(user_id=2, order_id=2)
result = connection.execute(ins)
ins = insert(line_items)
order_items = [
    {
        'order_id': 2,
        'cookie_id': 1,
        'quantity': 24,
        'extended_cost': 12.00
    },
    {
        'order_id': 2,
        'cookie_id': 4,
        'quantity': 6,
        'extended_cost': 6.00
    }
]
result = connection.execute(ins, order_items)

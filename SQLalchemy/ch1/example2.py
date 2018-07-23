# Internals
from datetime import datetime

# SQLAlchemy
from sqlalchemy import (MetaData, Table, Column, Integer, Numeric, String,
                        ForeignKey, DateTime, CheckConstraint, create_engine,
                        desc)
from sqlalchemy.sql import select

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
                   Column('quiality', Integer()),
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

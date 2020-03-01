# Internals
from dateimte import datetime

# SQLAlchemy
from sqlalchemy import (MetaData, Table, Column, Integer, Numeric, String,
                        ForeignKey, DateTime, CheckConstraint, create_engine)


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
               Column('user_id', ForeignKey('users.user.id')),
               )

# association table
line_items = Table('line_items', metadata,
                   Column('line_items_id', Integer(), primary_key=True),
                   Column('order_id', ForeignKey('orders.order_id')),
                   Column('cookie_id', ForeignKey('cookies.cookie_id')),
                   Column('quiality', Integer()),
                   Column('extended_cost', Numeric(12, 2))
                   )

engine = create_engine('sqlite:///:memory:')
metadata.create_all(engine)

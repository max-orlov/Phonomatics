from threading import _MainThread
from unicodedata import name
from cloudify_rest_client import client
from sqlalchemy.dialects.mysql import mysqldb

__author__ = 'maayan'

#imports
import sqlalchemy
import pymysql
import json
import csv
import datetime
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Sequence
from sqlalchemy import Column, Integer, String, Time, DateTime
from pprint import pprint

Base = declarative_base()
class Label(Base):

    __tablename__ = 'labels'
    id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
    label_id = Column(Integer)
    start_time = Column(Time)
    end_time  = Column(Time)
    label_id = Column(Integer)
    play_id = Column(Integer)
    actor_id = Column(Integer)
    created_at = Column(DateTime)
    created_by = Column(String)
    comments = Column(String)

    @staticmethod
    def selectall():
      for label in session.query(Label).all():
         pprint (vars(label))
    @staticmethod
    def add(start_time,end_time,label_id,play_id,actor_id,created_by,comments):
        l=Label(start_time=start_time,end_time=end_time,label_id=label_id,play_id=play_id,actor_id=actor_id,
        created_by=created_by,comments=comments,created_at=datetime.datetime.now())
        session.add(l)
        session.commit()

    @staticmethod
    def add_csv(csv_path):
        with open(csv_path) as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                Label.add(row['start_time'],row['end_time'],row['label_id'],row['play_id'],row['actor_id'],row['created_by'],row['comments'])


if __name__ == "__main__":
    engine = create_engine('mysql+pymysql://root:admin@127.0.0.1:3306/VOICE', echo=True)
    Session = sessionmaker(bind=engine)
    Session.configure(bind=engine)
    session = Session()
    #initialize db

    # #select
    # for label in session.query(Label).all():
    #     pprint (vars(label))
    # l=Label(id=3,start_time='05:55:55',end_time='05:55:59',label_id=1,play_id=1,actor_id=1,created_at='2015-12-08 15:41:04',
    #         created_by='om',comments='add from python')
    # session.add(l)
    # session.commit()

    Label.add_csv('C:\Users\maayan\Documents\\labelformat.csv')


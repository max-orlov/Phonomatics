__author__ = 'maayan'

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
    episode_id = Column(Integer)
    start_time = Column(Time)
    end_time  = Column(Time)
    speaker_id = Column(Integer)
    listener_id = Column(Integer)
    created_at = Column(DateTime)
    created_by = Column(String)
    comments = Column(String)

    @staticmethod
    def selectall():
      for label in session.query(Label).all():
         pprint (vars(label))
    @staticmethod
    def add(episode_id,start_time,end_time,speaker_id,listener_id,created_by,comments):
        l=Label(episode_id=episode_id,start_time=start_time,end_time=end_time,speaker_id=speaker_id,
        listener_id=listener_id,created_by=created_by,comments=comments,created_at=datetime.datetime.now())
        session.add(l)
        session.commit()

    @staticmethod
    def add_csv(csv_path):
        with open(csv_path) as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                Label.add(row['episode_id'],row['start_time'],row['end_time'],row['speaker_id'],row['listener_id'], row['created_by'],row['comments'])


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


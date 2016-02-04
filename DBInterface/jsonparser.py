import yaml
import os
from featuresdb import Session
import datetime


def insert_episodes(data):
    if isinstance(data, basestring) and os.path.isfile(data):
        with open(data) as data_file:
            data = yaml.load(data_file)

    for episode, segments in data.iteritems():
        session = Session()
        for i in range(1, len(segments)):
            currdata = segments[str(i)]
            start = datetime.timedelta(seconds=0.5*(i-1))
            end = start + datetime.timedelta(seconds=0.5*i)
            session.add(start, end, int(episode[:episode.index('-')]), i-1, **currdata)
        session.commit()

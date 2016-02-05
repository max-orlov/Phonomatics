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
            s_s, s_ms = (i-1) / 2, ((i-1) % 2) * 50
            e_s, e_ms = i / 2, (i % 2) * 50
            start = datetime.timedelta(minutes=s_s, seconds=s_ms)
            end = datetime.timedelta(minutes=e_s, seconds=e_ms)
            session.add(start, end, int(episode[:episode.index('-')]), i-1, **currdata)
        session.commit()

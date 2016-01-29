import yaml
import os
from featuresdb import Feature
import datetime


def insert_episode(data):
    if isinstance(data, basestring) and os.path.isfile(data):
        with open(data) as data_file:
            data = yaml.load(data_file)

    for episode, segment in data.iteritems():
        for i in range(1, len(segment)):
            currdata = segment[str(i)]
            start = datetime.timedelta(seconds=0.5*(i-1))
            end = start + datetime.timedelta(seconds=0.5*i)
            Feature.add(start, end, 1, i-1, **currdata)

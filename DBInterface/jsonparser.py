import json
from featuresdb import Feature
import datetime

with open('C:\Users\Maxim\PycharmProjects\VoiceLearning\\res.json') as data_file:
    data = json.load(data_file)

for i in range(1, 65):
    currdata = data['sample-pf.Tab'][str(i)]
    start = datetime.timedelta(seconds=0.5*(i-1))
    end = start + datetime.timedelta(seconds=0.5*i)
    Feature.add(start.time(), end.time(), 1, i-1, **currdata)

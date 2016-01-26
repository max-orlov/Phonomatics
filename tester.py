import json
from os import path, environ
from PraatPlugin import VoiceAnalyzer

v = VoiceAnalyzer()
l = v.analyze(path.abspath(environ['SAMPLES_PATH']))

with open('res.json', 'wb+') as f:
    f.write(json.dumps(l, indent=2))


from os import path, environ
from json import dumps
from PraatPlugin import VoiceAnalyzer

v = VoiceAnalyzer()
l = v.analyze(path.abspath(environ['SAMPLES_PATH']))

print dumps(l, indent=2)


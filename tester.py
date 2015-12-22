from os import path
from json import dumps
from PraatPlugin.analyze_wave import VoiceAnalyzer

v = VoiceAnalyzer()
l = v.analyze(path.abspath('praat-prosody_v0.1.1\demo\samples\sample.wav'))

print dumps(l, indent=2)


from PraatPlugin import VoiceAnalyzer
from DBInterface import insert_episode

output_file = 'res.json'

v = VoiceAnalyzer()
l = v.process_output()

insert_episode(l)


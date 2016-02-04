import os

from PraatPlugin import VoiceAnalyzer
from DBInterface import insert_episodes

v = VoiceAnalyzer()
l = v.full_file_process(os.environ['SAMPLES_PATH'])
# l = v.process_output()

insert_episodes(l)


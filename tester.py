import os
from PraatPlugin import VoiceAnalyzer
from DBInterface import insert_episodes

v = VoiceAnalyzer()

# This method is a shortcut to use the both of the following methods
# v.full_file_process(os.environ['SAMPLES_PATH'])

# This method processes the wavefiles, created a textgrid files and launches praat to analyze those files.
# v.praat_file_process(os.environ['SAMPLES_PATH'])

# This method processes the output from the work_dir/pf_files
l = v.process_output()

# This method inserts the processed dictionary into the db, one episode at a time.
insert_episodes(l)


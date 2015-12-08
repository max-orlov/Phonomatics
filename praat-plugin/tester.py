from os import path
import json
from praat_plugin import PraatPlugin

PRAAT_EXE = path.abspath(path.normpath('..\Praat.exe'))
PRAAT_PROSODY_PATH = path.abspath(path.normpath('..\praat-prosody_v0.1.1'))
USE_EXISTING_PARAMS_FILE = 1
praat_plugin = PraatPlugin(PRAAT_EXE)


stats_script = '{0}\stats\stats_batch.praat'.format(PRAAT_PROSODY_PATH)
args = ['{0}\demo-wavinfo_list.txt'.format(PRAAT_PROSODY_PATH),
        '{0}\demo\work_dir'.format(PRAAT_PROSODY_PATH),
        USE_EXISTING_PARAMS_FILE]


main_script = '{0}\code\main_batch.praat'.format(PRAAT_PROSODY_PATH)
args2 = ['{0}\demo-wavinfo_list.txt'.format(PRAAT_PROSODY_PATH),
        'user_pf_name_table.Tab',
        '{0}\demo\work_dir\stats_files'.format(PRAAT_PROSODY_PATH),
        '{0}\demo\work_dir'.format(PRAAT_PROSODY_PATH), USE_EXISTING_PARAMS_FILE]

praat_plugin.execute_script(stats_script, *args)
praat_plugin.execute_script(main_script, *args2)

l = praat_plugin.process_output('{0}\demo\work_dir\pf_files'.format(PRAAT_PROSODY_PATH))
print json.dumps(l, sort_keys=True, indent=4, separators=(',', ':'))

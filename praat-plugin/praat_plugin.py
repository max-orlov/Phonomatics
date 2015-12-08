from os import path, listdir
import subprocess
import json
from praatinterface import PraatLoader

PRAAT_EXE = path.abspath(path.normpath('..\Praat.exe'))



class PraatPlugin(object):

    def __init__(self, praat_path):
        self.praat_path = praat_path

    def execute_script(self, script, *args):
        cmd = [self.praat_path, '--run', script]
        cmd.extend([str(i) for i in args])
        cmd = ' '.join(cmd)
        out = subprocess.check_output(cmd, shell=True)
        return out

    @staticmethod
    def process_output(work_dir):
        lst = {}
        atts = None
        for output_file in listdir(work_dir):
            with open(path.join(work_dir, output_file)) as f:
                lst[output_file] = {}
                for line in f:
                    values = line.split('\t')
                    if not atts:
                        atts = values
                    else:
                        lst[output_file][values[0]] = {atts[i]: values[i] for i in range(1, len(values))}
            atts = None
        return lst

praat_plugin = PraatPlugin(PRAAT_EXE)


stats_script = 'c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\stats\stats_batch.praat'
args = ['c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\demo-wavinfo_list.txt',
        'c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\demo\work_dir', 1]


main_script = 'c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\code\main_batch.praat'
args2 = ['c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\demo-wavinfo_list.txt',
        'user_pf_name_table.Tab',
        '..\demo\work_dir\stats_files',
        'c:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\demo\work_dir', 1]

# praat_plugin.execute_script(stats_script, *args)
# praat_plugin.execute_script(main_script, *args2)

l = praat_plugin.process_output('C:\Users\Maxim\PycharmProjects\VoiceLearning\praat-prosody_v0.1.1\demo\work_dir\pf_files')
print json.dumps(l, sort_keys=True, indent=4, separators=(',', ':'))
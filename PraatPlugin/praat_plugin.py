from os import path, listdir, makedirs
import subprocess

PARAM_FILES_REL_PATH = 'demo/work_dir/param_files'
PF_FILES_REL_PATH = 'demo/work_dir/pf_files'
STATS_FILES = 'demo/work_dir/stats_files'


class PraatPlugin(object):

    def __init__(self, praat_path, praat_prosody_path):
        self.praat_path = praat_path
        dirs_to_create = [path.join(praat_prosody_path, working_dirs_path)
                          for working_dirs_path in [PARAM_FILES_REL_PATH, PF_FILES_REL_PATH, STATS_FILES]]
        for dir in dirs_to_create:
            if not path.isdir(dir):
                makedirs(dir)

    def execute_script(self, script, *args):
        """
        If you use some path in the args (or script) please use absolute path.

        :param script: absolute path of the script to run.
        :param args: any args needed by the script.
        :return:
        """
        cmd = ['Praat.exe', '--run', script]
        cmd.extend([str(i) for i in args])
        cmd = ' '.join(cmd)
        out = subprocess.check_output(cmd, env={'PATH': path.dirname(self.praat_path)})
        return out

    @staticmethod
    def process_output(work_dir):
        lst = {}
        attributes = None
        for output_file in listdir(work_dir):
            with open(path.join(work_dir, output_file)) as f:
                lst[output_file] = {}
                for line in f:
                    values = line.split('\t')
                    if not attributes:
                        attributes = values
                    else:
                        lst[output_file][values[0]] = {attributes[i]: values[i] for i in range(1, len(values))}
            attributes = None
        return lst

from os import path, listdir
import subprocess


class PraatPlugin(object):

    def __init__(self, praat_path):
        self.praat_path = praat_path

    def execute_script(self, script, *args):
        """
        If you use some path in the args (or script) please use absolute path.

        :param script: absolute path of the script to run.
        :param args: any args needed by the script.
        :return:
        """
        cmd = [self.praat_path, '--run', script]
        cmd.extend([str(i) for i in args])
        cmd = ' '.join(cmd)
        out = subprocess.check_output(cmd, shell=True)
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
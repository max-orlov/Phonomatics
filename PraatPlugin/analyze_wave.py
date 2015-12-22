import wave
import contextlib
from os import path
from praat_plugin import PraatPlugin
from text_grid import create_textgrid_files


class VoiceAnalyzer(object):

    def __init__(self, praat_exe=path.abspath(path.normpath('../Praat.exe')),
                 praat_prosody_path=path.abspath(path.normpath('praat-prosody_v0.1.1')),
                 use_existing_params=0):
        self.praat_bin = praat_exe
        self.praat_prosody = praat_prosody_path
        self.praat = PraatPlugin(self.praat_bin, self.praat_prosody)
        self.use_existing_params = use_existing_params

    @property
    def _stats_script(self):
        return '{0}\stats\stats_batch.praat'.format(self.praat_prosody)

    @property
    def _stat_args(self):
        return ['{0}\demo-wavinfo_list.txt'.format(self.praat_prosody),
                '{0}\demo\work_dir'.format(self.praat_prosody),
                self.use_existing_params]

    @property
    def _main_script(self):
        return '{0}\code\main_batch.praat'.format(self.praat_prosody)

    @property
    def _main_args(self):
        return ['{0}\demo-wavinfo_list.txt'.format(self.praat_prosody),
                'user_pf_name_table.Tab',
                '{0}\demo\work_dir\stats_files'.format(self.praat_prosody),
                '{0}\demo\work_dir'.format(self.praat_prosody), self.use_existing_params]

    def analyze_wave_file(self, wave_file, text_grid_dir):
        wave_length = self._get_wave_length(wave_file)
        file_name = path.basename(wave_file)
        file_name = file_name[:file_name.rfind('.')]
        create_textgrid_files(text_grid_dir, wave_length, file_name)
        self.praat.execute_script(self._stats_script, *self._stat_args)
        self.praat.execute_script(self._main_script, *self._main_args)

        return self.praat.process_output('{0}\demo\work_dir\pf_files'.format(self.praat_prosody))

    @staticmethod
    def _get_wave_length(wave_file):
        with contextlib.closing(wave.open(wave_file)) as f:
            frames = f.getnframes()
            rate = f.getframerate()
            return int(frames/rate)

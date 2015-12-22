import wave
import contextlib
import os
from praat_plugin import PraatPlugin
from text_grid import create_textgrid_files


class VoiceAnalyzer(object):

    def __init__(self, praat_exe=os.path.abspath(os.path.normpath('../Praat.exe')),
                 praat_prosody_path=os.path.abspath(os.path.normpath('praat-prosody_v0.1.1')),
                 use_existing_params=0):
        self._praat_bin = praat_exe
        self._praat_prosody = praat_prosody_path
        self._praat = PraatPlugin(self._praat_bin, self._praat_prosody)
        self._use_existing_params = use_existing_params

    @property
    def _work_dir(self):
        return '{0}\demo\work_dir'.format(self._praat_prosody)

    @property
    def _wavinfo_list(self):
        return '{0}\demo-wavinfo_list.txt'.format(self._praat_prosody)

    @property
    def _stats_script(self):
        return '{0}\stats\stats_batch.praat'.format(self._praat_prosody)

    @property
    def _stat_args(self):
        return [self._wavinfo_list, self._work_dir, self._use_existing_params]

    @property
    def _main_script(self):
        return '{0}\code\main_batch.praat'.format(self._praat_prosody)

    @property
    def _main_args(self):
        return [self._wavinfo_list,
                'user_pf_name_table.Tab',
                '{0}\demo\work_dir\stats_files'.format(self._praat_prosody),
                self._work_dir, self._use_existing_params]

    @property
    def _output_files(self):
        return '{0}\demo\work_dir\pf_files'.format(self._praat_prosody)

    def analyze(self, waves):
        """
        Analyzes wav file or a directory with wav files. each wav file would receive a text grid file, which
        would be used by praat to analyze the audio.
        :param waves: a dir with wavs or a single wav file path.
        :return: A dictionary based on the attributes derived by praat per file.
        """
        if os.path.isdir(waves):
            analyzed_files = self._analyze_wave_files(waves)
        elif os.path.isfile(waves):
            analyzed_files = [self._analyze_wave_file(waves)]
        else:
            raise Exception("This isn't a dir nor a file")

        self._create_wav_info_list(analyzed_files)

        self._praat.execute_script(self._stats_script, *self._stat_args)
        self._praat.execute_script(self._main_script, *self._main_args)

        return self._praat.process_output(self._output_files, clean_word_and_phones=True)

    def _analyze_wave_files(self, wave_dir):
        analyzed_files = []
        if os.path.isdir(wave_dir):
            for wave_file in filter(lambda f: f.endswith('.wav'), os.listdir(wave_dir)):
                wav_full_path = os.path.join(wave_dir, wave_file)
                self._analyze_wave_file(wav_full_path)
                analyzed_files.append(self._analyze_wave_file(wav_full_path))
        return analyzed_files

    def _analyze_wave_file(self, wave_file):
        print "Analyzing {0} file".format(wave_file)

        wave_length = self._get_wave_length(wave_file)
        dir_path = os.path.dirname(wave_file)
        file_name = os.path.basename(wave_file)
        file_name = file_name[:file_name.rfind('.')]
        create_textgrid_files(dir_path, wave_length, file_name)
        print "Text Grid created for {0}".format(wave_file)

        return wave_file

    def _create_wav_info_list(self, analyzed_files):
        with open(self._wavinfo_list, 'wb') as f:
            f.write('{0}{1}'.format('\t'.join(['SESSION', 'SPEAKER', 'GENDER', 'WAVEFORM']), os.linesep))
            for analyzed_file in analyzed_files:
                f.write('{0}{1}'.format('\t'.join([os.path.basename(analyzed_file), 'A', 'male', analyzed_file]),
                                        os.linesep))

    @staticmethod
    def _get_wave_length(wave_file):
        with contextlib.closing(wave.open(wave_file)) as f:
            frames = f.getnframes()
            rate = f.getframerate()
            return int(frames/rate)


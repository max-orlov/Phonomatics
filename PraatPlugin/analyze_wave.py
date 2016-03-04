import wave
import contextlib
import os
from praat_plugin import PraatPlugin
from text_grid import create_textgrid_files


class VoiceAnalyzer(object):
    """
    This class uses the build in praat module in order to run praat script
    and analyze its output
    """
    def __init__(self, praat_exe=os.path.abspath(os.path.normpath('../Praat.exe')),
                 praat_prosody_path=os.path.abspath(os.path.normpath('praat-prosody_v0.1.1')),
                 use_existing_params=0):
        self._praat_bin = praat_exe
        self._praat_prosody = praat_prosody_path
        self._praat = PraatPlugin(self._praat_bin, self._praat_prosody)
        self._use_existing_params = use_existing_params
        self._work_dir = '{0}\demo\work_dir'.format(self._praat_prosody)
        self._wavinfo_list = \
            '{0}\demo-wavinfo_list.txt'.format(self._praat_prosody)
        self._stats_script = \
            '{0}\stats\stats_batch.praat'.format(self._praat_prosody)
        self._stat_args = \
            [self._wavinfo_list, self._work_dir, self._use_existing_params]
        self._main_script = \
            '{0}\code\main_batch.praat'.format(self._praat_prosody)
        self._main_args = \
            [self._wavinfo_list, 'user_pf_name_table.Tab',
             '{0}\demo\work_dir\stats_files'.format(self._praat_prosody),
             self._work_dir, self._use_existing_params]
        self._output_files = \
            '{0}\demo\work_dir\pf_files'.format(self._praat_prosody)

    def full_file_process(self, waves):
        """
        Analyzes wav file or a directory with wav files.
        each wav file would receive a text grid file, which
        would be used by praat to analyze the audio.
        :param waves: a dir with wavs or a single wav file path.
        :return: A dictionary based on the attributes derived by praat per file.
        """
        self.praat_file_process(waves)
        return self.process_output()

    def praat_file_process(self, waves):
        """
        Runs Praat on a dir of files (or a single file).
        :param waves: a dir containing wav files, or a single file.
        :return: None
        """
        if os.path.isdir(waves):
            analyzed_files = self._create_praat_grids(waves)
        elif os.path.isfile(waves):
            analyzed_files = [self._create_praat_grid(waves)]
        else:
            raise Exception("This isn't a dir nor a file")

        self._create_wav_info_list(analyzed_files)

        self._praat.execute_script(self._stats_script, *self._stat_args)
        self._praat.execute_script(self._main_script, *self._main_args)

    def process_output(self):
        """
        Used in case where the sample files already ran once,
        and you only need to parse the Praat output files.
        Relies on the output dir for the Praat script.
        :return: a dict representing the Praat output.
        """
        return self._praat.process_output(self._output_files,
                                          clean_word_and_phones=True)

    def _create_praat_grids(self, wave_dir):
        """
        analyzes and entire dir and creates grid files to each wave file.
        :param wave_dir: the dir to analyze.
        :return: a list of analyzed files.
        """
        analyzed_files = []
        if os.path.isdir(wave_dir):
            for wave_file in filter(lambda f: f.endswith('.wav'), os.listdir(wave_dir)):
                wav_full_path = os.path.join(wave_dir, wave_file)
                analyzed_files.append(self._create_praat_grid(wav_full_path))
        return analyzed_files

    def _create_praat_grid(self, wave_file):
        """
        Create a praat grid file according to the specified wave file.
        :param wave_file: the wave file to create grid for.
        :return: the processed wave file path.
        """
        print "Analyzing {0} file".format(wave_file)

        wave_length = self._get_wave_length(wave_file)
        dir_path = os.path.dirname(wave_file)
        file_name = os.path.basename(wave_file)
        file_name = file_name[:file_name.rfind('.')]
        create_textgrid_files(dir_path, wave_length, file_name)
        print "Text Grid created for {0}".format(wave_file)

        return wave_file

    def _create_wav_info_list(self, analyzed_files):
        """
        Creates a basic list of files for praat to analyze.
        :param analyzed_files: the analyzed files for praat to process.
        :return: None
        """
        with open(self._wavinfo_list, 'wb') as f:
            f.write('{0}{1}'.format('\t'.join(['SESSION', 'SPEAKER', 'GENDER', 'WAVEFORM']), os.linesep))
            for analyzed_file in analyzed_files:
                f.write('{0}{1}'.format('\t'.join([os.path.basename(analyzed_file), 'A', 'male', analyzed_file]),
                                        os.linesep))

    @staticmethod
    def _get_wave_length(wave_file):
        """
        returns the wave file length.
        :param wave_file: the wave file to claculate.
        :return: the length of the wave (in seconds).
        """
        with contextlib.closing(wave.open(wave_file)) as f:
            frames = f.getnframes()
            rate = f.getframerate()
            return int(frames/rate)


import os

from math import ceil

PHONE_FILE_NAME = "phone.TextGrid"
WORD_FILE_NAME = "word.TextGrid"

base_conf = """File type = "ooTextFile"
Object class = "TextGrid"
xmin = 0
xmax = {0}
tiers? <exists>
size = 1
item []:
    item [1]:
        class = "IntervalTier"
        name = ""
        xmin = 0
        xmax = {0}
        intervals: size = {1}
"""

interval_conf = """
        intervals[{0}]:
            xmin = {1}
            xmax = {2}
            text = "{3}"
"""


def create_textgrid_files(dest_dir, length, file_name, resolution=0.5):
    """
    Creates textgrid file for praat to use when analyzing waves.
    :param dest_dir: the destination dir for the textgrid files.
    :param length: the length of the file.
    :param file_name: the name of the file.
    :param resolution: the resolution of the analysis. the segmentation of
    the entire wave file.
    :return:
    """
    if not os.path.isdir(dest_dir):
        os.makedirs(dest_dir)

    phone_file_path = os.path.join(dest_dir, '{0}-{1}'.format(file_name, PHONE_FILE_NAME))
    word_file_path = os.path.join(dest_dir, '{0}-{1}'.format(file_name, WORD_FILE_NAME))

    _create_phone_file(phone_file_path, length)
    _create_word_file(word_file_path, length, float(resolution))


def _create_phone_file(file_path, length):
    """
    Create a phone file required by Praat
    :param file_path: the file path.
    :param length: the wave length.
    :return: None
    """
    with open(file_path, 'wb') as f:
        f.write(base_conf.format(length, 1, length))
        f.write(interval_conf.format(1, 0, length, ""))


def _create_word_file(file_path, length, resolution):
    """
    Create a word file required by Praat.
    :param file_path: the file path
    :param length: the length of the wave.
    :param resolution: the resolution for segmentation of the file.
    :return:
    """
    intervals = int(ceil(length / resolution))
    with open(file_path, 'wb') as f:
        f.write(base_conf.format(length, intervals))
        for num, interval in enumerate([i * resolution for i in range(intervals)], 1):
            f.write(interval_conf.format(num, interval, min(interval + resolution, length), num))


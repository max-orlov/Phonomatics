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


def create_textgrid_files(dest_dir, xmax, resolution=0.5):
    if not os.path.isdir(dest_dir):
        os.makedirs(dest_dir)

    phone_file_path = os.path.join(dest_dir, PHONE_FILE_NAME)
    word_file_path = os.path.join(dest_dir, WORD_FILE_NAME)

    _create_phone_file(phone_file_path, xmax)
    _create_word_file(word_file_path, xmax, float(resolution))


def _create_phone_file(file_path, xmax):
    with open(file_path, 'wb') as f:
        f.write(base_conf.format(xmax, 1, xmax))
        f.write(interval_conf.format(1, 0, xmax, ""))


def _create_word_file(file_path, xmax, resolution):
    intervals = int(ceil(xmax / resolution))
    with open(file_path, 'wb') as f:
        f.write(base_conf.format(xmax, intervals))
        for num, interval in enumerate([i * resolution for i in range(intervals)], 1):
            f.write(interval_conf.format(num, interval, min(interval + resolution, xmax), num))

aaa
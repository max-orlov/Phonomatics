import os
import datetime
import yaml
from pprint import pprint

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Sequence
from sqlalchemy import Column, Integer, String, Time

Base = declarative_base()


class Feature(Base):

    __tablename__ = 'features'
    id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
    episode_id = Column(Integer)
    start_time = Column(Time)
    end_time = Column(Time)
    created_at = Column(Time)
    feature_id = Column(Integer)
    MEAN_F0_NEXT = Column(String)
    FIRST_STYLFIT_F0_WIN = Column(String)
    MEAN_STYLFIT_ENERGY_NEXT_WIN = Column(String)
    MEAN_ENERGY_NEXT_WIN = Column(String)
    F0K_WIN_DIFF_MNMN_N = Column(String)
    PAUSE_START = Column(String)
    MAX_F0 = Column(String)
    LAST_SLOPE = Column(String)
    ENERGY_MAXK_MODE_Z = Column(String)
    F0K_ZRANGE_MEANNEXT_KTOPLN = Column(String)
    FLAG = Column(String)
    MAX_STYLFIT_F0 = Column(String)
    ENERGY_PATTERN_SLOPE_WIN = Column(String)
    F0K_WIN_DIFF_MNMN_NG = Column(String)
    MAX_STYLFIT_F0_NEXT_WIN = Column(String)
    NO_FRAMES_LS_WE_NEXT_WIN = Column(String)
    PAUSE_END = Column(String)
    NO_FRAMES_WS_FS_NEXT_WIN = Column(String)
    ENERGY_LAST_SLOPE = Column(String)
    F0K_WIN_DIFF_LOLO_NG = Column(String)
    MIN_ENERGY_NEXT = Column(String)
    ENERGY_LR_MAXNEXT_KTOPLN = Column(String)
    ENERGY_PATTERN_BOUNDARY = Column(String)
    F0K_ZRANGE_MEAN_KTOPLN = Column(String)
    F0K_LR_WINMAXNEXT_KTOPLN = Column(String)
    MEAN_STYLFIT_ENERGY_NEXT = Column(String)
    ENERGY_LR_MEAN_KBASELN = Column(String)
    F0K_WIN_DIFF_LOHI_N = Column(String)
    ENERGY_DIFF_LAST_KBASELN = Column(String)
    FIRST_STYLFIT_ENERGY_NEXT_WIN = Column(String)
    NO_FRAMES_LS_WE = Column(String)
    ENERGY_PATTERN_SLOPE_NEXT_WIN = Column(String)
    MEAN_ENERGY_WIN = Column(String)
    ENERGY_WIN_DIFF_MNMN_N = Column(String)
    F0K_LR_LAST_KBASELN = Column(String)
    ENERGY_MAXK_NEXT_MODE_N = Column(String)
    ENERGY_ZRANGE_MEAN_KTOPLN = Column(String)
    FIRST_STYLFIT_F0_NEXT = Column(String)
    PATTERN_SLOPE = Column(String)
    MIN_F0_NEXT = Column(String)
    MAX_F0_WIN = Column(String)
    ENERGY_WIN_DIFF_LOLO_N = Column(String)
    F0K_DIFF_MEAN_KBASELN = Column(String)
    F0K_LR_MAXNEXT_KTOPLN = Column(String)
    FIRST_STYLFIT_ENERGY_NEXT = Column(String)
    F0K_DIFF_LAST_KBASELN = Column(String)
    ENERGY_MAXK_NEXT_MODE_Z = Column(String)
    MAX_STYLFIT_ENERGY_NEXT_WIN = Column(String)
    LAST_STYLFIT_ENERGY_NEXT = Column(String)
    NO_PREVIOUS_VF_WIN = Column(String)
    ENERGY_DIFF_WINMIN_KBASELN = Column(String)
    NO_FRAMES_LS_WE_WIN = Column(String)
    ENERGY_LAST_SLOPE_N = Column(String)
    F0K_WIN_DIFF_LOHI_NG = Column(String)
    MIN_F0 = Column(String)
    LAST_SLOPE_N = Column(String)
    MIN_F0_WIN = Column(String)
    NO_PREVIOUS_SSF_WIN = Column(String)
    NO_PREVIOUS_SSF_NEXT_WIN = Column(String)
    MEAN_STYLFIT_F0 = Column(String)
    LAST_STYLFIT_ENERGY = Column(String)
    MAX_ENERGY = Column(String)
    F0K_WIN_DIFF_HIHI_N = Column(String)
    MIN_STYLFIT_F0_NEXT_WIN = Column(String)
    NO_PREVIOUS_VF_NEXT_WIN = Column(String)
    ENERGY_PATTERN_SLOPE = Column(String)
    WAV = Column(String)
    FIRST_STYLFIT_F0_NEXT_WIN = Column(String)
    MAX_F0_NEXT = Column(String)
    MAX_STYLFIT_F0_WIN = Column(String)
    NO_PREVIOUS_SSF = Column(String)
    MAX_STYLFIT_ENERGY_NEXT = Column(String)
    ENERGY_LR_WINMIN_KBASELN = Column(String)
    MIN_STYLFIT_F0_NEXT = Column(String)
    ENERGY_DIFF_MAXNEXT_KTOPLN = Column(String)
    ENERGY_PATTERN_SLOPE_NEXT = Column(String)
    MIN_F0_NEXT_WIN = Column(String)
    MAX_ENERGY_NEXT = Column(String)
    MIN_STYLFIT_ENERGY = Column(String)
    LAST_STYLFIT_ENERGY_NEXT_WIN = Column(String)
    MEAN_ENERGY_NEXT = Column(String)
    PATTERN_SLOPE_WIN = Column(String)
    NO_SUCCESSOR_SSF = Column(String)
    NO_SUCCESSOR_VF_NEXT_WIN = Column(String)
    ENERGY_WIN_DIFF_HILO_NG = Column(String)
    LAST_STYLFIT_F0_NEXT = Column(String)
    ENERGY_WIN_DIFF_LOLO_NG = Column(String)
    ENERGY_WIN_DIFF_LOHI_NG = Column(String)
    SLOPE_DIFF_N = Column(String)
    MEAN_F0_NEXT_WIN = Column(String)
    PATTERN_SLOPE_NEXT_WIN = Column(String)
    MAX_STYLFIT_ENERGY = Column(String)
    MIN_STYLFIT_F0_WIN = Column(String)
    LAST_STYLFIT_F0 = Column(String)
    NO_SUCCESSOR_VF_WIN = Column(String)
    ENERGY_DIFF_MEANNEXT_KTOPLN = Column(String)
    MIN_STYLFIT_ENERGY_WIN = Column(String)
    MIN_ENERGY_WIN = Column(String)
    F0K_ZRANGE_MEAN_KBASELN = Column(String)
    LAST_STYLFIT_ENERGY_WIN = Column(String)
    SLOPE_DIFF = Column(String)
    ENERGY_ZRANGE_MEANNEXT_KTOPLN = Column(String)
    NO_PREVIOUS_SSF_NEXT = Column(String)
    MEAN_STYLFIT_F0_NEXT_WIN = Column(String)
    ENERGY_LR_MEANNEXT_KTOPLN = Column(String)
    MAX_STYLFIT_F0_NEXT = Column(String)
    MEAN_STYLFIT_ENERGY_WIN = Column(String)
    ENERGY_MAXK_MODE_N = Column(String)
    ENERGY_SLOPE_DIFF = Column(String)
    MEAN_F0_WIN = Column(String)
    ENERGY_WIN_DIFF_HIHI_N = Column(String)
    ENERGY_WIN_DIFF_MNMN_NG = Column(String)
    F0K_LR_MEANNEXT_KTOPLN = Column(String)
    ENERGY_ZRANGE_MEANNEXT_KBASELN = Column(String)
    F0K_MAXK_MODE_Z = Column(String)
    LAST_STYLFIT_F0_WIN = Column(String)
    NO_SUCCESSOR_VF_NEXT = Column(String)
    F0K_DIFF_MEANNEXT_KTOPLN = Column(String)
    MAX_ENERGY_WIN = Column(String)
    ENERGY_WIN_DIFF_LOHI_N = Column(String)
    NO_FRAMES_WS_FS_WIN = Column(String)
    MEAN_STYLFIT_ENERGY = Column(String)
    MEAN_F0 = Column(String)
    F0K_DIFF_WINMAXNEXT_KTOPLN = Column(String)
    F0K_LR_MEAN_KBASELN = Column(String)
    ENERGY_WIN_DIFF_HIHI_NG = Column(String)
    ENERGY_FIRST_SLOPE_NEXT = Column(String)
    ENERGY_DIFF_MEAN_KBASELN = Column(String)
    MIN_STYLFIT_ENERGY_NEXT = Column(String)
    ENERGY_DIFF_WINMAXNEXT_KTOPLN = Column(String)
    FIRST_STYLFIT_ENERGY = Column(String)
    PATTERN_BOUNDARY = Column(String)
    F0K_MAXK_NEXT_MODE_N = Column(String)
    MIN_ENERGY_NEXT_WIN = Column(String)
    F0K_WIN_DIFF_LOLO_N = Column(String)
    FIRST_SLOPE_NEXT = Column(String)
    NO_FRAMES_WS_FS_NEXT = Column(String)
    MAX_F0_NEXT_WIN = Column(String)
    F0K_MAXK_NEXT_MODE_Z = Column(String)
    MEAN_STYLFIT_F0_NEXT = Column(String)
    F0K_WIN_DIFF_HILO_NG = Column(String)
    PATTERN_SLOPE_NEXT = Column(String)
    MAX_STYLFIT_ENERGY_WIN = Column(String)
    F0K_MAXK_MODE_N = Column(String)
    F0K_WIN_DIFF_HILO_N = Column(String)
    GEN = Column(String)
    NO_PREVIOUS_VF = Column(String)
    NO_FRAMES_WS_FS = Column(String)
    MIN_ENERGY = Column(String)
    SPKR_ID = Column(String)
    NO_SUCCESSOR_SSF_NEXT_WIN = Column(String)
    PAUSE_DUR_N = Column(String)
    PAUSE_DUR = Column(String)
    FIRST_STYLFIT_ENERGY_WIN = Column(String)
    MIN_STYLFIT_ENERGY_NEXT_WIN = Column(String)
    NO_SUCCESSOR_SSF_NEXT = Column(String)
    NO_PREVIOUS_VF_NEXT = Column(String)
    NO_SUCCESSOR_VF = Column(String)
    ENERGY_LR_LAST_KBASELN = Column(String)
    F0K_WIN_DIFF_HIHI_NG = Column(String)
    MIN_STYLFIT_F0 = Column(String)
    FIRST_STYLFIT_F0 = Column(String)
    ENERGY_LR_WINMAXNEXT_KTOPLN = Column(String)
    F0K_LR_WINMIN_KBASELN = Column(String)
    F0K_DIFF_MAXNEXT_KTOPLN = Column(String)
    F0K_DIFF_WINMIN_KBASELN = Column(String)
    ENERGY_ZRANGE_MEAN_KBASELN = Column(String)
    F0K_ZRANGE_MEANNEXT_KBASELN = Column(String)
    MEAN_ENERGY = Column(String)
    ENERGY_SLOPE_DIFF_N = Column(String)
    NO_FRAMES_LS_WE_NEXT = Column(String)
    LAST_STYLFIT_F0_NEXT_WIN = Column(String)
    ENERGY_WIN_DIFF_HILO_N = Column(String)
    NO_SUCCESSOR_SSF_WIN = Column(String)
    MAX_ENERGY_NEXT_WIN = Column(String)
    MEAN_STYLFIT_F0_WIN = Column(String)


class Session(object):
    """
    A session object which enables negotiation with the db.
    """
    def __init__(self):
        self.engine = create_engine('mysql+pymysql://root:admin@127.0.0.1:3306/VOICE', echo=True)
        session = sessionmaker(bind=self.engine)
        session.configure(bind=self.engine)
        self.session = session()

    def add(self, start_time, end_time, episode_id, feature_id, commit=False,
            **kwargs):
        """
        Adds an episode into the features db.
        :param start_time: the start time of the feature.
        :param end_time: the end time of the feature.
        :param episode_id:
        :param feature_id:
        :param commit: should commit right after the add.
        :param kwargs: any feature attribute as specified in the feature class.
        :return: None
        """
        f = Feature(start_time=start_time, end_time=end_time,
                    episode_id=episode_id, feature_id=feature_id,
                    created_at=datetime.datetime.now(), **kwargs)
        self.session.add(f)
        if commit:
            self.commit()

    def delete(self, commit=False, **kwargs):
        """
        This wasn't checked.

        :param commit: whether been checked.
        :param kwargs: kwargs for the feature.
        :return:
        """
        f = Feature(created_at=datetime.datetime.now(), **kwargs)
        self.session.delete(f)
        if commit:
            self.commit()

    def commit(self):
        """
        Commits the changes onto the db.
        :return:
        """
        self.session.commit()

    def print_all(self):
        """
        Prints out all of the records from the db.
        :return:
        """
        for feature in self.session.query(Feature).all():
            pprint(vars(feature))


def insert_episodes_into_db(data):
    """
    Inserts the data (in a file or dict) into the db.
    :param data: a file or a dictionary to insert into the db.
    :return: None
    """
    if isinstance(data, basestring) and os.path.isfile(data):
        with open(data) as data_file:
            data = yaml.load(data_file)

    for episode, segments in data.iteritems():
        session = Session()
        for i in range(1, len(segments)):
            currdata = segments[str(i)]
            s_s, s_ms = (i-1) / 2, ((i-1) % 2) * 50
            e_s, e_ms = i / 2, (i % 2) * 50
            start = datetime.timedelta(minutes=s_s, seconds=s_ms)
            end = datetime.timedelta(minutes=e_s, seconds=e_ms)
            session.add(start, end, int(episode[:episode.index('-')]), i-1, **currdata)
        session.commit()

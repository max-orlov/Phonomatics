import datetime
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Sequence
from sqlalchemy import Column, Integer, String, Time
from pprint import pprint

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

    def __init__(self):
        self.engine = create_engine('mysql+pymysql://root:admin@127.0.0.1:3306/VOICE', echo=True)
        session = sessionmaker(bind=self.engine)
        session.configure(bind=self.engine)
        self.session = session()

    def add(self, start_time, end_time, episode_id, feature_id, commit=False, **kwargs):
        f = Feature(start_time=start_time, end_time=end_time, episode_id=episode_id, feature_id=feature_id,
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
        self.session.commit()

    def select_all(self):
        for feature in self.session.query(Feature).all():
            pprint(vars(feature))

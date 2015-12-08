# config.praat
#
# store all configuration parameters
# used in prosody model
#
#
#
#----------------------------------------
tk_DEBUG = 1

# default values
gc_frame_size = 0.01
gc_win_size = 0.2
gc_pause_min = 5
gc_min_frame_length = 3
gc_epslon = 0.002
gc_pos_infinit = 10000000000000
gc_neg_infinit = - 10000000000000
gc_min_spkr_sample = 3


# default directory names
gc_param_dir$ = "param_files"
gc_pf_dir$ = "pf_files"
gc_stats_dir$ = "stats_files"
gc_pf_list_dir$ = "pf_list_files"

# default file names
gc_global_phone_table$ = "phone_dur.stats"
gc_spkr_feat_table$ = "spkr_feat.stats"
gc_last_rhyme_table$ = "last_rhyme_dur.stats"
gc_last_rhyme_phone_table$ = "last_rhyme_phone_dur.stats"
gc_norm_last_rhyme_table$ = "norm_last_rhyme_phone_dur.stats"
gc_pause_table$ = "pause_dur.stats"

gc_feature_name_table$ = "feature_name_table.Tab"
gc_basic_feature_name_table$ = "basic_feature_name_table.Tab"
gc_basic_base_feature_name_table$ = "basic_base_feature_name_table.Tab"
gc_basic_dur_feature_name_table$ = "basic_dur_feature_name_table.Tab"
gc_basic_f0_feature_name_table$ = "basic_f0_feature_name_table.Tab"
gc_derive_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_normalized_word_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_pattern_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_normalized_pause_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_normalized_vowel_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_normalized_rhyme_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_f0_feature_name_table$ = "derive_feature_name_table.Tab"
gc_derive_average_phone_feature_name_table$ = "derive_feature_name_table.Tab"

# default postfix for spkr files
gc_word_postfix$ = "-word.TextGrid"
gc_phone_postfix$ = "-phone.TextGrid"
gc_vowel_postfix$ = "-vowel.TextGrid"
gc_rhyme_postfix$ = "-rhyme.TextGrid"
gc_vuv_postfix$ = "-vuv.TextGrid"
gc_slope_postfix$ = "-slope.TextGrid"
gc_wavPitch_postfix$ = ".Pitch"
gc_rawPitch_postfix$ = "-raw.PitchTier"
gc_stylPitch_postfix$ = "-styl.PitchTier"
gc_wavEnergy_postfix$ = ".Intensity"
gc_rawEnergy_postfix$ = "-rawEnergy.PitchTier"
gc_stylEnergy_postfix$ = "-stylEnergy.PitchTier"
gc_slopeEnergy_postfix$ = "-slopeEnergy.TextGrid"

gc_spkr_phone_postfix$ = "-phone_dur.stats"

gc_pf_postfix$ = "-pf.Tab"

# new defining
gc_TRUE = 1
gc_FALSE = 0


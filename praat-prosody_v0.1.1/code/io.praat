# io.praat
# procedures related to file read
# and write operations
#


# included procedures
# - construct_global_filenames
# - display_input_summary
# - create_working_dirs
# - load_global_files
# - construct_spkr_filenames
# - load_spkr_stats_files
# - load_create_spkr_param_files
# - save_spkr_files
# - remove_spkr_objs
# - save_global_files
# - remove_global_objs
# - cleanup

procedure construct_global_filenames
	if tk_DEBUG >= 3
		printline [proceed in construct_global_filenames]
	endif
	# working directories
	gv_param_dir$ = gv_work_dir$ + gv_path_delimit$ + gc_param_dir$
	gv_pf_dir$ = gv_work_dir$ + gv_path_delimit$ + gc_pf_dir$
	gv_local_stats_dir$ = gv_work_dir$ + gv_path_delimit$ + gc_stats_dir$
	# global statistic files
	gv_global_phone_table$ = gv_global_stats_dir$ + gv_path_delimit$ + gc_global_phone_table$
	gv_spkr_feat_table$ = gv_global_stats_dir$ + gv_path_delimit$ + gc_spkr_feat_table$
	gv_last_rhyme_table$ = gv_local_stats_dir$ + gv_path_delimit$ + gc_last_rhyme_table$
	gv_last_rhyme_phone_table$ = gv_local_stats_dir$ + gv_path_delimit$ + gc_last_rhyme_phone_table$
	gv_norm_last_rhyme_table$ = gv_local_stats_dir$ + gv_path_delimit$ + gc_norm_last_rhyme_table$
	gv_pause_table$ = gv_local_stats_dir$ + gv_path_delimit$ + gc_pause_table$	
	
	gv_pf_list_dir$ = "." + gv_path_delimit$ + gc_pf_list_dir$
	gv_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_feature_name_table$ 
	gv_basic_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_basic_feature_name_table$
	gv_basic_base_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_basic_base_feature_name_table$
	gv_basic_dur_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_basic_dur_feature_name_table$
	gv_basic_f0_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_basic_f0_feature_name_table$
	gv_derive_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_feature_name_table$
	gv_derive_normalized_word_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_normalized_word_feature_name_table$ 
	gv_derive_pattern_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_pattern_feature_name_table$
	gv_derive_normalized_pause_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_normalized_pause_feature_name_table$
	gv_derive_normalized_vowel_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_normalized_vowel_feature_name_table$
	gv_derive_normalized_rhyme_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_normalized_rhyme_feature_name_table$
	gv_derive_f0_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_f0_feature_name_table$
	gv_derive_average_phone_feature_name_table$ = gv_pf_list_dir$ + gv_path_delimit$ + gc_derive_average_phone_feature_name_table$
endproc

procedure display_input_summary
	if tk_DEBUG >= 3
		printline [proceed in display_input_summary]
	endif
	printline Summary of the System Working Mode
	printline
	printline Your inputs
	printline wav_info_list: 'gv_wav_info_table$'
	printline global_statistic_directory: 'gv_global_stats_dir$'
	printline
	printline You choose to
	if gv_use_existing_param_files = gc_TRUE
		printline use existing param files
	else
		printline not use existing param files
	endif
	if gv_keep_param_files = gc_TRUE
		printline keep param files
	else
		printline not keep param files
	endif
	if gv_calculate_derived_features = gc_TRUE
		printline calculate derived features
	else
		printline not calculate derived features		
	endif	
	printline
	printline The Toolkit will store outputs in
	printline parameter_files_directory: 'gv_param_dir$'
	printline prosodic_feature_files_directory: 'gv_pf_dir$'
	printline local_statistic_files_direcotry: 'gv_local_stats_dir$'
	printline
endproc

procedure create_working_dirs
	if tk_DEBUG >= 3
		printline [proceed in create_working_dirs]
	endif
	call make_dir 'gv_param_dir$'
	call make_dir 'gv_pf_dir$'
	call make_dir 'gv_local_stats_dir$'
endproc

procedure load_global_files
	if tk_DEBUG >= 3
		printline [proceed in load_global_files]
	endif
	Read Table from table file... 'gv_wav_info_table$'
	wavInfoTableID = selected("Table", -1)
	gv_wav_no = Get number of rows

	Read Table from table file... 'gv_global_phone_table$'
	globalPhoneTableID = selected("Table", -1)
	Read Table from table file... 'gv_spkr_feat_table$'
	spkrFeatTableID = selected("Table", -1)
endproc

procedure construct_spkr_filenames
	if tk_DEBUG >= 3
		printline [proceed in construct_spkr_filenames]
	endif
	call fname_parts 'gv_spkr_wav$'
	# now str_result2$ and str_result4$ contain the
	# basename and file path respectively
	wav_dir$ = str_result4$
	prefix$ = str_result2$
	gv_word_textgrid$ = wav_dir$ + gv_path_delimit$ + prefix$ + gc_word_postfix$
	gv_phone_textgrid$ = wav_dir$ + gv_path_delimit$ + prefix$ + gc_phone_postfix$
	gv_vowel_textgrid$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_vowel_postfix$
	gv_rhyme_textgrid$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_rhyme_postfix$
	gv_vuv_textgrid$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_vuv_postfix$
	gv_slope_textgrid$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_slope_postfix$
	gv_wav_pitch$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_wavPitch_postfix$
	gv_raw_pitchtier$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_rawPitch_postfix$
	gv_styl_pitchtier$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_stylPitch_postfix$
	gv_wav_energy$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_wavEnergy_postfix$
	gv_rawEnergy_pitchtier$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_rawEnergy_postfix$
	gv_stylEnergy_pitchtier$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_stylEnergy_postfix$
   	gv_slopeEnergy_textgrid$ = gv_param_dir$ + gv_path_delimit$ + prefix$ + gc_slopeEnergy_postfix$
 		
	gv_spkr_phone_table$ = gv_global_stats_dir$ + gv_path_delimit$ + pf_SPKR_ID$ + gc_spkr_phone_postfix$
	
	gv_pf_tab$ = gv_pf_dir$ + gv_path_delimit$ + prefix$ + gc_pf_postfix$
endproc

procedure load_spkr_stats_files
	if tk_DEBUG >= 3
		printline [proceed in load_spkr_stats_files]
	endif
	Read Table from table file... 'gv_spkr_phone_table$'
	spkrPhoneTableID = selected("Table", -1)
	select spkrFeatTableID
	gv_spkr_index = Search column... SPKR_ID 'pf_SPKR_ID$'
endproc

procedure load_create_spkr_param_files
	if tk_DEBUG >= 3
		printline [proceed in load_create_spkr_param_files]
	endif
    	Read from file... 'gv_word_textgrid$'
	wordTextGridID = selected("TextGrid", -1)
	gv_finishing_time = Get finishing time
	Read from file... 'gv_phone_textgrid$'
	phoneTextGridID = selected("TextGrid", -1)
	if (gv_use_existing_param_files = gc_FALSE or not fileReadable(gv_vowel_textgrid$)) or (not fileReadable(gv_rhyme_textgrid$))
		call gen_dur_files
	else
		Read from file... 'gv_vowel_textgrid$'
		vowelTextGridID = selected("TextGrid", -1)
		Read from file... 'gv_rhyme_textgrid$'
		rhymeTextGridID = selected("TextGrid", -1)
	endif
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_raw_pitchtier$)) or (not fileReadable(gv_styl_pitchtier$)) or (not fileReadable(gv_slope_textgrid$)) or (not fileReadable(gv_vuv_textgrid$)))
		call gen_pitch_files
	else
		Read from file... 'gv_raw_pitchtier$'
		rawPitchTierID = selected("PitchTier", -1)
		Read from file... 'gv_styl_pitchtier$'
		stylPitchTierID = selected("PitchTier", -1)
		Read from file... 'gv_slope_textgrid$'
		slopeTextGridID = selected("TextGrid", -1)
		Read from file... 'gv_vuv_textgrid$'
		vuvTextGridID = selected("TextGrid", -1)
	endif
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_rawEnergy_pitchtier$)) or (not fileReadable(gv_stylEnergy_pitchtier$)) or (not fileReadable(gv_slopeEnergy_textgrid$)))
		call gen_energy_files
	else
	    Read from file... 'gv_slopeEnergy_textgrid$'
	    slopeEnergyTextGridID = selected("TextGrid", -1)
		Read from file... 'gv_rawEnergy_pitchtier$'
		rawEnergyPitchTierID = selected("PitchTier", -1)
		Read from file... 'gv_stylEnergy_pitchtier$'
		stylEnergyPitchTierID = selected("PitchTier", -1)
	endif
	if (gv_use_existing_param_files = gc_FALSE or not fileReadable(gv_vowel_textgrid$)) or (not fileReadable(gv_rhyme_textgrid$))
		select 'vowelTextGridID'
		Write to text file... 'gv_vowel_textgrid$'
		select 'rhymeTextGridID'
		Write to text file... 'gv_rhyme_textgrid$'
	endif
	if (gv_use_existing_param_files = gc_FALSE or not fileReadable(gv_raw_pitchtier$)) or (not fileReadable(gv_styl_pitchtier$)) or (not fileReadable(gv_slope_textgrid$) or (not fileReadable(gv_vuv_textgrid$)))
		select 'rawPitchTierID'
		Write to text file... 'gv_raw_pitchtier$'
		select 'stylPitchTierID'
		Write to text file... 'gv_styl_pitchtier$'
		select 'slopeTextGridID'
		Write to text file... 'gv_slope_textgrid$'
		select 'vuvTextGridID'
		Write to text file... 'gv_vuv_textgrid$'
	endif
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_rawEnergy_pitchtier$)) or (not fileReadable(gv_stylEnergy_pitchtier$)) or (not fileReadable(gv_slopeEnergy_textgrid$)))
		select 'slopeEnergyTextGridID'
		Write to text file... 'gv_slopeEnergy_textgrid$'
		select 'rawEnergyPitchTierID'
		Write to text file... 'gv_rawEnergy_pitchtier$'
		select 'stylEnergyPitchTierID'
		Write to text file... 'gv_stylEnergy_pitchtier$'
	endif		
endproc

procedure save_spkr_files
	if tk_DEBUG >= 3
		printline [proceed in save_spkr_files]
	endif
	select 'outputPfTableID'
	Write to table file... 'gv_pf_tab$'
endproc

procedure remove_spkr_objs
	if tk_DEBUG >= 3
		printline [proceed in remove_spkr_objs]
    endif
    select wordTextGridID
	plus phoneTextGridID
	plus vowelTextGridID
	plus rhymeTextGridID
	plus slopeTextGridID
	plus rawPitchTierID
	plus stylPitchTierID
	plus vuvTextGridID
	plus spkrPhoneTableID
	plus pfTableID
	plus outputPfTableID
	plus wordTableID
	plus slopeEnergyTextGridID
	plus rawEnergyPitchTierID
	plus stylEnergyPitchTierID
	Remove
endproc

procedure save_global_files
	if tk_DEBUG >= 3
		printline [proceed in save_global_files]
	endif
	select lastRhymeTableID
	Write to table file... 'gv_last_rhyme_table$'
	select lastRhymePhoneTableID
	Write to table file... 'gv_last_rhyme_phone_table$'
	select normLastRhymeTableID
	Write to table file... 'gv_norm_last_rhyme_table$'
	select pauseTableID
	Write to table file... 'gv_pause_table$'
endproc

procedure remove_global_objs
	if tk_DEBUG >= 3
		printline [proceed in remove_global_objs]
	endif
	select wavInfoTableID
    plus globalPhoneTableID
	plus spkrFeatTableID
	plus lastRhymeTableID
	plus lastRhymePhoneTableID
	plus normLastRhymeTableID
	plus pauseTableID
	plus phoneLookupTableID
    Remove
endproc

procedure cleanup
	if tk_DEBUG >= 3
		printline [proceed in cleanup]
	endif
	if gv_keep_param_files = gc_FALSE
		call remove_dir 'gv_param_files$'
	endif
endproc

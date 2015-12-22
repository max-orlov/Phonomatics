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
# - load_create_spkr_param_files
# - save_first_pass_spkr_files
# - save_second_pass_spkr_files
# - remove_first_pass_spkr_objs
# - remove_second_pass_spkr_objs
# - save_global_files
# - remove_global_objs
# - cleanup

procedure construct_global_filenames
	if tk_DEBUG > -1
		printline [proceed construct_global_filenames]
	endif
	# working directories
	gv_param_dir$ = gv_work_dir$ + gv_path_delimit$ + gc_param_dir$
	gv_stats_dir$ = gv_work_dir$ + gv_path_delimit$ + gc_stats_dir$
	# global statistic files
	gv_global_phone_table$ = gv_stats_dir$ + gv_path_delimit$ + gc_global_phone_table$
	gv_spkr_feat_table$ = gv_stats_dir$ + gv_path_delimit$ + gc_spkr_feat_table$
endproc

procedure display_input_summary
	if tk_DEBUG > -1
		printline [proceed display_input_summary]
	endif
	printline Summary of the System Working Mode
	printline
	printline Your inputs
	printline wav_info_list: 'gv_wav_info_table$'
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

	printline
	printline The Toolkit will store outputs in
	printline parameter_files_directory: 'gv_param_dir$'
	printline statistic_files_direcotry: 'gv_stats_dir$'
	printline
endproc

procedure create_working_dirs
	if tk_DEBUG > -1
		printline [proceed create_working_dirs]
	endif
	call make_dir 'gv_param_dir$'
	call make_dir 'gv_stats_dir$'
	call remove_dir 'gv_stats_dir$'
	call make_dir 'gv_stats_dir$'
endproc

procedure load_global_files
	if tk_DEBUG > -1
		printline [proceed load_global_files]
	endif
	Read Table from table file... 'gv_wav_info_table$'
	wavInfoTableID = selected("Table", -1)
	gv_wav_no = Get number of rows

#	Read Table from table file... 'gv_global_phone_table$'
#	globalPhoneTableID = selected("Table", -1)
#	Read Table from table file... 'gv_spkr_feat_table$'
#	spkrFeatTableID = selected("Table", -1)
endproc

procedure construct_spkr_filenames
	if tk_DEBUG > -1
		printline [proceed construct_spkr_filenames]
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
	
	gv_spkr_phone_table$ = gv_stats_dir$ + gv_path_delimit$ + gv_spkr_id$ + gc_spkr_phone_postfix$
	gv_spkr_phone_table_name$ = gv_spkr_id$ + "_phone_table"
endproc

procedure load_create_spkr_param_files
	if tk_DEBUG > -1
		printline [proceed load_create_spkr_param_files]
	endif
    	Read from file... 'gv_word_textgrid$'
	wordTextGridID = selected("TextGrid", -1)
	gv_finishing_time = Get finishing time
	Read from file... 'gv_phone_textgrid$'
	phoneTextGridID = selected("TextGrid", -1)
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_vowel_textgrid$)) or (not fileReadable(gv_rhyme_textgrid$)))
		call gen_dur_files
	else
		Read from file... 'gv_vowel_textgrid$'
		vowelTextGridID = selected("TextGrid", -1)
		Read from file... 'gv_rhyme_textgrid$'
		rhymeTextGridID = selected("TextGrid", -1)
	endif
	
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_raw_pitchtier$)) or (not fileReadable(gv_styl_pitchtier$)) or (not fileReadable(gv_slope_textgrid$) or (not fileReadable(gv_vuv_textgrid$))))
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
	if (gv_use_existing_param_files = gc_FALSE or (not fileReadable(gv_raw_pitchtier$)) or (not fileReadable(gv_styl_pitchtier$)) or (not fileReadable(gv_slope_textgrid$)) or (not fileReadable(gv_vuv_textgrid$)))
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
		select 'rawEnergyPitchTierID'
		Write to text file... 'gv_rawEnergy_pitchtier$'
		select 'stylEnergyPitchTierID'
		Write to text file... 'gv_stylEnergy_pitchtier$'
		select 'slopeEnergyTextGridID'
		Write to text file... 'gv_slopeEnergy_textgrid$'
	endif
	
	# load in or create spkr_phone_table 
	if fileReadable(gv_spkr_phone_table$)
		Read Table from table file... 'gv_spkr_phone_table$'
	else 
		call create_phone_table 'gv_spkr_phone_table_name$'
	endif
	spkrPhoneTableID = selected("Table", -1);	
endproc


procedure load_second_pass_spkr_param_files
	if tk_DEBUG > -1
		printline [proceed load_create_spkr_param_files]
	endif
	Read from file... 'gv_phone_textgrid$'
	phoneTextGridID = selected("TextGrid", -1)
	gv_finishing_time = Get finishing time
	Read Table from table file... 'gv_spkr_phone_table$'
	spkrPhoneTableID = selected("Table", -1);
endproc


procedure save_first_pass_spkr_files
	if tk_DEBUG > -1
		printline [proceed save_first_pass_spkr_files]
	endif
	select spkrPhoneTableID
	Write to table file... 'gv_spkr_phone_table$'
endproc
procedure save_second_pass_spkr_files
	if tk_DEBUG > -1
		printline [proceed save_second_pass_spkr_files]
	endif
	select 'spkrPhoneTableID'
	Write to table file... 'gv_spkr_phone_table$'
endproc

procedure remove_first_pass_spkr_objs
	if tk_DEBUG > -1
		printline [proceed remove_first_pass_spkr_objs]
    endif
    select 'wordTextGridID'
	plus 'phoneTextGridID'
	plus 'vowelTextGridID'
	plus 'rhymeTextGridID'
	plus 'slopeTextGridID'
	plus 'rawPitchTierID'
	plus 'stylPitchTierID'
	plus 'vuvTextGridID'
	plus 'rawEnergyPitchTierID'
	plus 'stylEnergyPitchTierID'
	plus 'slopeEnergyTextGridID'
	plus 'spkrPhoneTableID'
	Remove
endproc

procedure remove_second_pass_spkr_objs
	if tk_DEBUG > -1
		printline [proceed remove_second_pass_spkr_objs]
    	endif
	select 'phoneTextGridID'
	plus 'spkrPhoneTableID'
	Remove
endproc


procedure save_global_files
	if tk_DEBUG > -1
		printline [proceed save_global_files]
	endif
	select globalPhoneTableID
	Write to table file... 'gv_global_phone_table$'
	select spkrFeatTableID
	Write to table file... 'gv_spkr_feat_table$'
endproc

procedure remove_global_objs
	if tk_DEBUG > -1
		printline [proceed remove_global_objs]
	endif
	select wavInfoTableID
	plus globalPhoneTableID
	plus spkrFeatTableID
	plus phoneLookupTableID
	plus spkrRegistrationTableID
    Remove
endproc

procedure cleanup
	if tk_DEBUG > -1
		printline [proceed cleanup]
	endif
	if gv_keep_param_files = gc_FALSE
		call remove_dir 'gv_param_files$'
	endif
endproc


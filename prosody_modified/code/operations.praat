# operations.praat
#
include util.praat
include io.praat
include table.praat
include config.praat
include fetch.praat
include derive.praat


# - init_toolkit
# - extract_feats
#   - init_spkr
#   - pre_process_spkr
#   - extract_spkr_feats
#   - compute_spkr_stats
#   - derive_spkr_feats
#   - post_spkr
# - post_toolkit


procedure init_toolkit
	clearinfo
	if tk_DEBUG >= 1
		printline init_toolkit
		printline
	endif
	if tk_DEBUG >=2
		printline [proceed in init_toolkit]
	endif
	# assign to global variables from input
	gv_wav_info_table$ = wav_info_table$
	gv_global_stats_dir$ = stats_dir$
	gv_work_dir$ = work_dir$
	gv_user_pf_name_table$ = user_pf_name_table$
	if use_existing_param_files = 1
		gv_use_existing_param_files = gc_TRUE
	else
		gv_use_existing_param_files = gc_FALSE
	endif
	gv_keep_param_files = gc_TRUE
	gv_calculate_derived_features = gc_TRUE

	# check system type: linux/unix or window, and assign
	# "/" or "\" to gv_path_delimit$
    	call check_system 'shellDirectory$'
	# assign global file names
	call construct_global_filenames
	# send back user input
	call display_input_summary
	# create param_dir, pf_dir, stats_dir
	call create_working_dirs
	# load wav_info_table, phone_dur_table, speaker_feature_table
	call load_global_files
	# create last_rhyme_table, last_rhyme_phone_table, and pause_table
	call create_global_stats_tables
endproc

procedure extract_feats
	if tk_DEBUG >= 2
		printline [proceed in extract_feats]
	endif
	for gv_wav_index from 1 to gv_wav_no
		select wavInfoTableID
		pf_SPKR_ID$ = Get value... 'gv_wav_index' SPEAKER
		pf_SESS_ID$ = Get value... 'gv_wav_index' SESSION
		pf_GEN$ = Get value... 'gv_wav_index' GENDER
		pf_WAV$ = Get value... 'gv_wav_index' WAVEFORM
		gv_spkr_wav$ = pf_WAV$
		if tk_DEBUG >= 1
			printline start processing 'gv_spkr_wav$'
		endif
		call init_spkr
		call pre_process_spkr
		call save_spkr_files
		call extract_spkr_feats
		call compute_spkr_stats
		call derive_spkr_feats
		call post_spkr
		if tk_DEBUG >= 1
			printline finish processing 'gv_spkr_wav$'
			printline 
		endif
	endfor
endproc	

procedure init_spkr
	if tk_DEBUG >= 1
		printline init_spkr
	endif
	if tk_DEBUG >= 2
		printline [proceed in init_spkr]
	endif
	call construct_spkr_filenames
	call load_spkr_stats_files
endproc

procedure pre_process_spkr
	if tk_DEBUG >= 1
		printline pre_process_spkr
	endif
	if tk_DEBUG >= 2
		printline [proceed in pre_process_spkr]
	endif
	call load_create_spkr_param_files
	call create_word_table
	call create_pf_table
	call create_output_pf_table
endproc

procedure extract_spkr_feats
	if tk_DEBUG >=1
		printline extract_spkr_feats
	endif
	if tk_DEBUG >= 2
		printline [proceed in extract_spkr_feats]
	endif
    for gv_pf_index from 1 to gv_pf_no
       	call clear_validity_flag 'gv_basic_feature_name_table$'
       	vf_SPKR_ID = 1
        vf_GEN = 1 
        vf_WAV = 1
		call fetch_pf
		call set_pf_table
	endfor
endproc

procedure compute_spkr_stats
	if tk_DEBUG >= 1
		printline compute_spkr_stats
	endif
	if tk_DEBUG >= 2
		printline [proceed in compute_spkr_stats]
	endif
	call fetch_spkr_stats
	call set_spkr_stats_tables
endproc

procedure derive_spkr_feats
	if tk_DEBUG >= 1
		printline derive_spkr_feats
	endif
	if tk_DEBUG >= 2
		printline [proceed in derive_spkr_feats]
	endif
	for gv_pf_index from 1 to gv_pf_no
		call clear_validity_flag 'gv_feature_name_table$'
		vf_SPKR_ID = 1
        vf_GEN = 1 
        vf_WAV = 1
		call lookup_basic_pf_table
		call derive_pf
		call set_output_pf_table
	endfor
endproc

procedure post_spkr
	if tk_DEBUG >= 1
		printline post_spkr
	endif
	if tk_DEBUG >= 2
		printline [proceed in post_spkr]
	endif
	call save_spkr_files
	call remove_spkr_objs
endproc

procedure post_toolkit
	if tk_DEBUG >= 1
		printline post_toolkit
	endif
	if tk_DEBUG >= 2
		printline [proceed in post_toolkit]
	endif
	call save_global_files
	call remove_global_objs
	call cleanup
endproc

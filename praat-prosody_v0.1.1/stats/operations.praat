# operations.praat
#
include util.praat
include io.praat
include table.praat
include config.praat
include stats.praat


# - init_toolkit
# - extract_stats
#   - init_first_pass_spkr
#   - pre_process_spkr
#   - compute_first_pass_stats
#   - post_first_pass_spkr
#   - init_second_pass_spkr
#   - load_second_pass_spkr
#   - compute_second_pass_stats
#   - post_second_pass_spkr
# - post_toolkit

procedure init_toolkit
	clearinfo
	if tk_DEBUG >= -5
		printline init_toolkit
		printline
	endif
	# assign to global variables from input
	gv_wav_info_table$ = wav_info_table$
	gv_work_dir$ = work_dir$
	if use_existing_param_files = 1
		gv_use_existing_param_files = gc_TRUE
	else
		gv_use_existing_param_files = gc_FALSE
	endif
	gv_keep_param_files = gc_TRUE

	# check system type: linux/unix or window, and assign
	# "/" or "\" to gv_path_delimit$
    	call check_system 'shellDirectory$'
	# assign global file names
	call construct_global_filenames
	# send back user input
	call display_input_summary
	# create param_dir, pf_dir, stats_dir
	call create_working_dirs
	# load wav_info_table
	call load_global_files
	# create last_rhyme_table, last_rhyme_phone_table, and pause_table
	call create_global_stats_tables
endproc

procedure extract_stats
	if tk_DEBUG > 0
		printline [proceed extract_stats]
	endif
	if tk_DEBUG >= -5
		printline starting the first pass of calculating statistics
		printline
	endif
	for gv_wav_index from 1 to gv_wav_no
		select wavInfoTableID
		gv_spkr_id$ = Get value... 'gv_wav_index' SPEAKER
		gv_sess_id$ = Get value... 'gv_wav_index' SESSION
		pf_GEN$ = Get value... 'gv_wav_index' GENDER
		gv_spkr_wav$ = Get value... 'gv_wav_index' WAVEFORM
		if tk_DEBUG >= -5
			printline start processing 'gv_spkr_wav$'
		endif
		call init_spkr
		call pre_process_first_pass_spkr
		call compute_first_pass_spkr_stats
		call post_first_pass_spkr
		if tk_DEBUG >= -5
			printline finish processing 'gv_spkr_wav$'
			printline 
		endif
	endfor
	call clear_spkr_registration_table
## updating the spkr phone and stats tables
	for gv_wav_index from 1 to gv_wav_no
		select wavInfoTableID
		gv_spkr_id$ = Get value... 'gv_wav_index' SPEAKER
		gv_sess_id$ = Get value... 'gv_wav_index' SESSION
		gv_spkr_wav$ = Get value... 'gv_wav_index' WAVEFORM
		call query_status_in_spkr_registration_table 'gv_spkr_id$'
		if num_resutl1 = 0
			gv_spkr_phone_table$ = gv_stats_dir$ + gv_path_delimit$ + gv_spkr_id$ + gc_spkr_phone_postfix$
			Read Table from table file... 'gv_spkr_phone_table$'
			spkrPhoneTableID = selected("Table", -1);
			call set_phone_table 'spkrPhoneTableID'
			call reset_phone_table 'spkrPhoneTableID'
			select spkrPhoneTableID
			Write to table file... 'gv_spkr_phone_table$'
			Remove
			call set_status_in_spkr_registration_table 'gv_spkr_id$'
		endif
	endfor
	call set_spkr_feat_table
	call set_phone_table 'globalPhoneTableID'
	call reset_phone_table 'globalPhoneTableID'
	if tk_DEBUG >= -5
		printline finish the first pass of calculating statistics
		printline
	endif
	if tk_DEBUG >= -5
		printline starting the second pass of calculating statistics
		printline
	endif
	for gv_wav_index from 1 to gv_wav_no
		select wavInfoTableID
		gv_spkr_id$ = Get value... 'gv_wav_index' SPEAKER
		gv_spkr_wav$ = Get value... 'gv_wav_index' WAVEFORM
		gv_sess_id$ = Get value... 'gv_wav_index' SESSION
		if tk_DEBUG >= -5
			printline start processing 'gv_spkr_wav$'
		endif
		call init_spkr
		call pre_process_second_pass_spkr
		call compute_second_pass_spkr_stats
		call post_second_pass_spkr
		if tk_DEBUG >= -5
			printline finish processing 'gv_spkr_wav$'
			printline 
		endif
	endfor
	call set_phone_table 'globalPhoneTableID'
	call clear_spkr_registration_table
	for gv_wav_index from 1 to gv_wav_no
		select wavInfoTableID
		gv_spkr_id$ = Get value... 'gv_wav_index' SPEAKER
		gv_sess_id$ = Get value... 'gv_wav_index' SESSION
		gv_spkr_wav$ = Get value... 'gv_wav_index' WAVEFORM
		call query_status_in_spkr_registration_table 'gv_spkr_id$'
		if num_resutl1 = 0			
			gv_spkr_phone_table$ = gv_stats_dir$ + gv_path_delimit$ + gv_spkr_id$ + gc_spkr_phone_postfix$
			Read Table from table file... 'gv_spkr_phone_table$'
			spkrPhoneTableID = selected("Table", -1);
			call set_phone_table 'spkrPhoneTableID'
			select spkrPhoneTableID
			Write to table file... 'gv_spkr_phone_table$'
			Remove
			call set_status_in_spkr_registration_table 'gv_spkr_id$'
		endif
	endfor
	
	if tk_DEBUG >= -5
		printline finish the second pass of calculating statistics
		printline
	endif
endproc	

procedure init_spkr
	if tk_DEBUG >= -5
		printline init_spkr
	endif
	call construct_spkr_filenames
	call locate_spkr_in_registration_table 'gv_spkr_id$'
endproc

procedure pre_process_first_pass_spkr
	if tk_DEBUG >= -5
		printline pre_process_first_pass_spkr
	endif
	call load_create_spkr_param_files
endproc

procedure pre_process_second_pass_spkr
	if tk_DEBUG >= -5
		printline pre_process_second_pass_spkr
	endif
	call load_second_pass_spkr_param_files
endproc

procedure compute_first_pass_spkr_stats
	if tk_DEBUG >= -5
		printline compute_first_pass_spkr_stats
	endif
	call accum_spkr_feat_stats
	call accum_spkr_phone_stats
#	call set_spkr_feat_table
#	call set_phone_table 'spkrPhoneTableID'
endproc

procedure compute_second_pass_spkr_stats
	if tk_DEBUG >= -5
		printline compute_second_pass_spkr_stats
	endif
	call accum_spkr_phone_stats
#	call set_phone_table 'spkrPhoneTableID'
endproc

procedure post_first_pass_spkr
	if tk_DEBUG >= -5
		printline post_first_pass_spkr
	endif
	call save_first_pass_spkr_files
	call remove_first_pass_spkr_objs
endproc

procedure post_second_pass_spkr
	if tk_DEBUG >= -5
		printline post_second_pass_spkr
	endif
	call save_second_pass_spkr_files
	call remove_second_pass_spkr_objs
endproc

procedure post_toolkit
	if tk_DEBUG >= -5
		printline post_toolkit
	endif
	call save_global_files
	call remove_global_objs
	call cleanup
endproc


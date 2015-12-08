# table.praat
# contains various table creation procedures
#
#
# - create_global_stats_tables
#   - create_last_rhyme_table
#   - create_last_rhyme_phone_table
#   - create_pause_table
#   - create_phone_lookup_tabe
# - create_word_table
# - create_pf_table
# - create_output_pf_table
#   - clear_table_flag
#   - set_table_flag
#   - add_to_output_pf_table

# - update_last_rhyme_table
# - update_last_rhyme_phone_table
# - update_norm_last_rhyme_table
# - update_pause_table

# - set_pf_table
# - set_output_pf_table
# - set_spkr_stats_tables
#   - set_last_rhyme_table
#   - set_last_rhyme_phone_table
#   - set_norm_last_rhyme_table
#   - set_pause_table

# - clear_table

# - create_phone_lookup_table
# - search_phone_lookup_table

# - lookup_phone_table
# - lookup_spkr_feat_table
# - lookup_spkr_sess_table
# - lookup_basic_pf_table

include util.praat

procedure create_global_stats_tables
	if tk_DEBUG >= 4
		printline [proceed in create_global_stats_tables]
	endif
	call create_last_rhyme_table
	call create_last_rhyme_phone_table
	call create_norm_last_rhyme_table
	call create_pause_table
	call create_phone_lookup_table
endproc

procedure create_last_rhyme_table
	if tk_DEBUG >= 4
		printline [proceed in create_last_rhyme_table]
	endif
	Create Table... last_rhyme_table 'gv_wav_no' 4
	lastRhymeTableID = selected("Table", -1)
	Set column label (index)... 1 SPKR_ID
	Set column label (index)... 2 MEAN
	Set column label (index)... 3 STDEV
	Set column label (index)... 4 COUNT_RHYME

	call clear_table 'lastRhymeTableID'
endproc

procedure create_last_rhyme_phone_table
	if tk_DEBUG >= 4
		printline [proceed in create_last_rhyme_phone_table]
	endif
	Create Table... last_rhyme_phone_table 'gv_wav_no' 4
    lastRhymePhoneTableID = selected("Table", -1)
	Set column label (index)... 1 SPKR_ID
	Set column label (index)... 2 MEAN
	Set column label (index)... 3 STDEV
	# COUNT_RHYME is first used to countS last_rhyme_phone
	Set column label (index)... 4 COUNT_RHYME

	call clear_table 'lastRhymePhoneTableID'
endproc

procedure create_norm_last_rhyme_table
	if tk_DEBUG >= 4
		printline [proceed in create_norm_last_rhyme_table]
	endif
	Create Table... norm_last_rhyme_table 'gv_wav_no' 4
    normLastRhymeTableID = selected("Table", -1)
	Set column label (index)... 1 SPKR_ID
	Set column label (index)... 2 MEAN
	Set column label (index)... 3 STDEV
	Set column label (index)... 4 COUNT_RHYME

	call clear_table 'normLastRhymeTableID'
endproc	

procedure create_pause_table
	if tk_DEBUG >= 4
		printline [proceed in create_pause_table]
	endif
	Create Table... pause_table 'gv_wav_no' 6
	pauseTableID = selected("Table", -1)
	Set column label (index)... 1 SPKR_ID
	Set column label (index)... 2 MEAN
	Set column label (index)... 3 STDEV
	Set column label (index)... 4 MEAN_LOG
	Set column label (index)... 5 STDEV_LOG
	Set column label (index)... 6 COUNT_PAUSE

	call clear_table 'pauseTableID'
endproc

procedure create_word_table
	if tk_DEBUG >= 4
		printline [proceed in create_word_table]
	endif
	select wordTextGridID
	intrvl_cnt = Get number of intervals... 1

	# table for only words
	Create Table... word_table 1 4
	wordTableID = selected("Table", -1)
	Set column label (index)... 1 word
	Set column label (index)... 2 intrvl_id
	Set column label (index)... 3 xmin
	Set column label (index)... 4 xmax

	wd_rowi = 0
	# convert all intervals (word/pause) to word-only table
	for i from 1 to intrvl_cnt
		select wordTextGridID
		word$ = Get label of interval... 1 i
		if word$ <> ""
			word_start = Get starting point... 1 i
			word_end = Get end point... 1 i
			wd_rowi = wd_rowi + 1
			select wordTableID
			Append row
			Set string value...  wd_rowi word 'word$'
			Set numeric value... wd_rowi intrvl_id i
			Set numeric value... wd_rowi xmin word_start
			Set numeric value... wd_rowi xmax word_end
		endif
	endfor
	select wordTableID
##last_word: 
	gv_pf_no = wd_rowi
endproc

procedure create_pf_table
	if tk_DEBUG >= 4
		printline [proceed in create_pf_table]
	endif
	Create Table... pf_table 'gv_pf_no' 1
	pfTableID = selected("Table", -1)
	feature_name_no = 0
	column_no = 1
	Read Table from table file... 'gv_basic_feature_name_table$'
	featureNameTableID = selected("Table", -1)
	row_no = Get number of rows
	for i from 1 to row_no
		select featureNameTableID
		feature_name$ = Get value... 'i' FEATURE_NAME
		select pfTableID
		feature_name_no = feature_name_no + 1
        if feature_name_no <= column_no
            Set column label (index)... 'feature_name_no' 'feature_name$'
		else
			Append column... 'feature_name$'
			column_no = column_no + 1
		endif
	endfor
	select featureNameTableID
	Remove
endproc

procedure update_last_rhyme_table rhyme_dur
	if tk_DEBUG >= 4
		printline [proceed in update_last_rhyme_table 'rhyme_dur']
	endif
	select lastRhymeTableID
	mean_sum_value = Get value... 'gv_wav_index' MEAN
	square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	mean_sum_value = mean_sum_value + rhyme_dur
	square_sum_value = square_sum_value + rhyme_dur * rhyme_dur
	no_count_value = no_count_value + 1
	Set numeric value... 'gv_wav_index' MEAN 'mean_sum_value'
	Set numeric value... 'gv_wav_index' STDEV 'square_sum_value'
	Set numeric value... 'gv_wav_index' COUNT_RHYME 'no_count_value'
endproc

procedure update_last_rhyme_phone_table phone_dur
	if tk_DEBUG >= 4
		printline [proceed in update_last_rhyme_phone_table 'rhyme_dur']
	endif
	select lastRhymePhoneTableID
	mean_sum_value = Get value... 'gv_wav_index' MEAN
	square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	mean_sum_value = mean_sum_value + phone_dur
	square_sum_value = square_sum_value + phone_dur * phone_dur
	no_count_value = no_count_value + 1
	Set numeric value... 'gv_wav_index' MEAN 'mean_sum_value'
	Set numeric value... 'gv_wav_index' STDEV 'square_sum_value'
	Set numeric value... 'gv_wav_index' COUNT_RHYME 'no_count_value'
endproc

procedure update_norm_last_rhyme_table phone_dur
	if tk_DEBUG >= 4
		printline [proceed in update_norm_last_rhyme_table 'phone_dur']
	endif
	select normLastRhymeTableID
	mean_sum_value = Get value... 'gv_wav_index' MEAN
	square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	mean_sum_value = mean_sum_value + rhyme_dur
	square_sum_value = square_sum_value + rhyme_dur * rhyme_dur
	no_count_value = no_count_value + 1
	Set numeric value... 'gv_wav_index' MEAN 'mean_sum_value'
	Set numeric value... 'gv_wav_index' STDEV 'square_sum_value'
	Set numeric value... 'gv_wav_index' COUNT_RHYME 'no_count_value'
endproc	

procedure update_pause_table pause_dur
	if tk_DEBUG >= 4
		printline [proceed in update_pause_table 'pause_dur']
	endif
	if pause_dur > gc_pause_min
		select pauseTableID
		mean_sum_value = Get value... 'gv_wav_index' MEAN
		square_sum_value = Get value... 'gv_wav_index' STDEV
		no_count_value = Get value... 'gv_wav_index' COUNT_PAUSE
		mean_sum_value = mean_sum_value + pause_dur
		square_sum_value = square_sum_value + pause_dur * pause_dur
		no_count_value = no_count_value + 1
		Set numeric value... 'gv_wav_index' MEAN 'mean_sum_value'
		Set numeric value... 'gv_wav_index' STDEV 'square_sum_value'
		Set numeric value... 'gv_wav_index' COUNT_PAUSE 'no_count_value'
	endif
endproc

procedure set_pf_table
	if tk_DEBUG >= 4
		printline [proceed in set_pf_table]
	endif
	select pfTableID
	column_no = Get number of columns
	for i from 1 to column_no
		feature_name$ = Get column label... 'i'
		dollar_pos = index(feature_name$, "$")
		if dollar_pos = 0
			vf_num_value = vf_'feature_name$'
			if vf_num_value = 1
			    num_value = pf_'feature_name$'
    			Set numeric value... 'gv_pf_index' 'feature_name$' 'num_value'
    	    endif
		else
		    temp_feature_name$ = left$(feature_name$, dollar_pos - 1)
		    vf_str_value = vf_'temp_feature_name$'			
			if vf_str_value = 1
			    str_value$ = pf_'feature_name$'
				Set string value... 'gv_pf_index' 'feature_name$' 'str_value$'
    	    endif
		endif
	endfor
endproc


procedure set_spkr_stats_tables
	if tk_DEBUG >= 4
		printline [proceed in set_spkr_stats_tables]
	endif
	call set_last_rhyme_table
	call set_last_rhyme_phone_table
	call set_norm_last_rhyme_table
	call set_pause_table
endproc

procedure set_last_rhyme_table
	if tk_DEBUG >= 4
		printline [proceed in set_last_rhyme_table]
	endif
	select lastRhymeTableID
	Set string value... 'gv_wav_index' SPKR_ID 'pf_SPKR_ID$'
    mean_sum_value = Get value... 'gv_wav_index' MEAN
    square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
	mean_value = num_result1
	stdev_value = num_result2
	Set numeric value... 'gv_wav_index' MEAN 'mean_value'
	Set numeric value... 'gv_wav_index' STDEV 'stdev_value'
endproc

procedure set_last_rhyme_phone_table
	if tk_DEBUG >= 4
		printline [proceed in set_last_rhyme_phone_table]
	endif
    select lastRhymePhoneTableID
 	Set string value... 'gv_wav_index' SPKR_ID 'pf_SPKR_ID$'
	mean_sum_value = Get value... 'gv_wav_index' MEAN
	square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
	mean_value = num_result1
	stdev_value = num_result2
	Set numeric value... 'gv_wav_index' MEAN 'mean_value'
	Set numeric value... 'gv_wav_index' STDEV 'stdev_value'
    select lastRhymeTableID
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	select lastRhymePhoneTableID
	Set numeric value... 'gv_wav_index' COUNT_RHYME 'no_count_value'
endproc

procedure set_norm_last_rhyme_table
	if tk_DEBUG >= 4
		printline [proceed in set_norm_last_rhyme_table]
	endif
	select normLastRhymeTableID
	Set string value... 'gv_wav_index' SPKR_ID 'pf_SPKR_ID$'
    mean_sum_value = Get value... 'gv_wav_index' MEAN
    square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_RHYME
	call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
	mean_value = num_result1
	stdev_value = num_result2
	Set numeric value... 'gv_wav_index' MEAN 'mean_value'
	Set numeric value... 'gv_wav_index' STDEV 'stdev_value'
endproc


procedure set_pause_table
	if tk_DEBUG >= 4
		printline [proceed in set_pause_table
	endif
	select pauseTableID
	Set string value... 'gv_wav_index' SPKR_ID 'pf_SPKR_ID$'
	mean_sum_value = Get value... 'gv_wav_index' MEAN
	square_sum_value = Get value... 'gv_wav_index' STDEV
	no_count_value = Get value... 'gv_wav_index' COUNT_PAUSE
	call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
	mean_value = num_result1
	stdev_value = num_result2
	if stdev_value = -1
	     mean_log_value = -1
	     stdev_log_value = -1
	else
	   mean_log_value = ln(mean_value)
	   stdev_log_value = ln(mean_value)
    endif
	Set numeric value... 'gv_wav_index' MEAN 'mean_value'
	Set numeric value... 'gv_wav_index' STDEV 'stdev_value'
	Set numeric value... 'gv_wav_index' MEAN_LOG 'mean_log_value'
	Set numeric value... 'gv_wav_index' STDEV_LOG 'stdev_log_value'
endproc
	
procedure clear_table inputTableID
	if tk_DEBUG >= 4
		printline [proceed in clear_table 'inputTableID']
	endif
	select 'inputTableID'
	row_no = Get number of rows
	column_no = Get number of columns
	for column_id from 1 to column_no
		column_label$ = Get column label... 'column_id'
		for row_id from 1 to row_no
			Set numeric value... 'row_id' 'column_label$' 0
		endfor
	endfor
endproc

procedure create_phone_lookup_table
	if tk_DEBUG >= 4
		printline [proceed in create_phone_lookup_table]
	endif
	gNumOfPhones = 57
	Create Table... phone_lookup_table 1 'gNumOfPhones'
	phoneLookupTableID = selected("Table", -1)
	Set column label (index)... 1 AA
	Set column label (index)... 2 AE
	Set column label (index)... 3 AH
	Set column label (index)... 4 AO
	Set column label (index)... 5 AW
	Set column label (index)... 6 AX
	Set column label (index)... 7 AY
	Set column label (index)... 8 B
	Set column label (index)... 9 CH
	Set column label (index)... 10 D
	Set column label (index)... 11 DH
	Set column label (index)... 12 EH
	Set column label (index)... 13 EL
	Set column label (index)... 14 EN
	Set column label (index)... 15 ER
	Set column label (index)... 16 EY
	Set column label (index)... 17 F
	Set column label (index)... 18 G
	Set column label (index)... 19 HH
	Set column label (index)... 20 IH
	Set column label (index)... 21 IY
	Set column label (index)... 22 JH
	Set column label (index)... 23 K
	Set column label (index)... 24 L
	Set column label (index)... 25 M
	Set column label (index)... 26 N
	Set column label (index)... 27 NG
	Set column label (index)... 28 OW
	Set column label (index)... 29 OY
	Set column label (index)... 30 P
	Set column label (index)... 31 R
	Set column label (index)... 32 S
	Set column label (index)... 33 SH
	Set column label (index)... 34 T
	Set column label (index)... 35 TH
	Set column label (index)... 36 UH
	Set column label (index)... 37 UW
	Set column label (index)... 38 V
	Set column label (index)... 39 W
	Set column label (index)... 40 Y
	Set column label (index)... 41 Z
	Set column label (index)... 42 ZH
	Set column label (index)... 43 AXR
	Set column label (index)... 44 BD
	Set column label (index)... 45 DD
	Set column label (index)... 46 DX
	Set column label (index)... 47 ER
	Set column label (index)... 48 GD
	Set column label (index)... 49 IX
	Set column label (index)... 50 KD
	Set column label (index)... 51 PD
	Set column label (index)... 52 TD
	Set column label (index)... 53 TS
	Set column label (index)... 54 BR
	Set column label (index)... 55 GA
	Set column label (index)... 56 LS
	Set column label (index)... 57 LG
endproc

procedure search_phone_lookup_table phone_label$
# return in num_result1 the column index for phone_label$
# in the phone_lookup_table
	if tk_DEBUG >= 4
		printline [proceed in search_phone_lookup_table 'phone_label$']
	endif
	select 'phoneLookupTableID'
	num_result1 = Get column index... 'phone_label$'
endproc
	
procedure lookup_phone_table phoneTableID phone_label$ column_label$
# return in num_result1 the value in row: phone_label$
# and column: column_label$ in the phoneTableID
	if tk_DEBUG >= 4
		printline [proceed in lookup_phone_table 'phoneTableID' 'phone_label$' 'column_label$']
	endif
	call search_phone_lookup_table 'phone_label$'
	row_index = num_result1
	select 'phoneTableID'
	if not row_index > 0
	    printline [proceed lookup_phone_table 'phoneTableID' 'phone_label$' 'column_label$']
	endif
	
	num_result1 = Get value... 'row_index' 'column_label$'
endproc

procedure lookup_spkr_feat_table column_label$
# return in num_result1 the value in row: sess_id$ and
# column: column_label$ in the spkrSessTableID
	if tk_DEBUG >= 4
		printline [proceed in lookup_spkr_feat_table 'column_label$']
	endif
	select spkrFeatTableID
	num_result1 = Get value... 'gv_spkr_index' 'column_label$'
endproc

procedure lookup_spkr_sess_table spkrSessTableID column_label$
	if tk_DEBUG >= 4
		printline [proceed lookup_spkr_sess_table 'spkrSessTableID' 'column_label$']
	endif
	select 'spkrSessTableID'
	num_result1 = Get value... 'gv_wav_index' 'column_label$'
endproc

procedure lookup_basic_pf_table
	if tk_DEBUG >= 4
		printline [proceed in lookup_basic_pf_table]
	endif
	select 'pfTableID'
	column_no = Get number of columns
	for i from 1 to column_no
		feature_name$ = Get column label... 'i'
		pf_'feature_name$' = Get value... 'gv_pf_index' 'feature_name$'
		table_value$ = Get value... 'gv_pf_index' 'feature_name$'
		dollar_pos = index(feature_name$, "$")
		if dollar_pos = 0
		    temp_feature_name$ = feature_name$
        else
            temp_feature_name$ = left$(feature_name$, dollar_pos - 1)
        endif
        if table_value$ = ""
            vf_'temp_feature_name$' = 0
        else
            vf_'temp_feature_name$' = 1
        endif
    endfor
endproc

procedure set_table_flag feature_name_table$
	if tk_DEBUG >= 4
		printline [proceed in set_table_flag 'feature_name_table$']
	endif
	Read Table from table file... 'feature_name_table$'
	featureNameTableID = selected("Table", -1)
	flag_table_row_no = Get number of rows
	for j from 1 to flag_table_row_no
		feature_name$ = Get value... 'j' FEATURE_NAME
		dollar_pos = index(feature_name$, "$")
		if dollar_pos <> 0
			feature_name$ = left$(feature_name$, dollar_pos - 1)
		endif
		tf_'feature_name$' = 1
	endfor
	Remove
endproc


procedure clear_table_flag feature_name_table$
	if tk_DEBUG >= 4
		printline [proceed in clear_table_flag 'feature_name_table$']
	endif
	Read Table from table file... 'feature_name_table$'
	featureNameTableID = selected("Table", -1)
	row_no = Get number of rows
	for i from 1 to row_no
		feature_name$ = Get value... 'i' FEATURE_NAME
		dollar_pos = index(feature_name$, "$")
		if dollar_pos <> 0
			feature_name$ = left$(feature_name$, dollar_pos - 1)
		endif
		tf_'feature_name$' = 0
	endfor
	Remove
endproc

procedure clear_validity_flag feature_name_table$
    if tk_DEBUG >= 4
        printline [proceed in clear_validity_flag 'feature_name_table$']
    endif
    Read Table from table file... 'feature_name_table$'
    featureNameTableID = selected("Table", -1)
    row_no = Get number of rows
    for i from 1 to row_no
        feature_name$ = Get value... 'i' FEATURE_NAME
        dollar_pos = index(feature_name$, "$")
        if dollar_pos <> 0
            feature_name$ = left$(feature_name$, dollar_pos - 1)
        endif
        vf_'feature_name$' = 0
    endfor
    Remove
endproc

procedure create_output_pf_table
	if tk_DEBUG >= 4
		printline [proceed in create_output_pf_table]
	endif
	# clear flag

	call clear_table_flag 'gv_feature_name_table$'
	
	# set flag
	Read Table from table file... 'gv_user_pf_name_table$'
	userParamTableID = selected("Table", -1)
	row_no = Get number of rows
	for i from 1 to row_no
	    select userParamTableID
		feature_name$ = Get value... 'i' FEATURE_NAME
		dollar_pos = index(feature_name$, "$")
		if dollar_pos <> 0
			feature_name$ = left$(feature_name$, dollar_pos - 1)
		endif
		if feature_name$ = "FULL_FEATURE"
		    call set_table_flag 'gv_feature_name_table$'
		elsif feature_name$ = "BASIC_FEATURE"
			call set_table_flag 'gv_basic_feature_name_table$'
		elsif feature_name$ = "BASIC_BASE_FEATURE"
			call set_table_flag 'gv_basic_base_feature_name_table$'
		elsif feature_name$ = "BASIC_DUR_FEATURE"
			call set_table_flag 'gv_basic_dur_feature_name_table$'
		elsif feature_name$ = "BASIC_F0_FEATURE"
			call set_table_flag 'gv_basic_f0_feature_name_table$'
		elsif feature_name$ = "BASIC_ENERGY_FEATURE"
			call set_table_flag 'gv_basic_energy_feature_name_table$'
		elsif feature_name$ = "DERIVE_FEATURE"
			call set_table_flag 'gv_derive_feature_name_table$'
		elsif feature_name$ = "DERIVE_NORMALIZED_WORD"
			call set_table_flag 'gv_derive_normalized_word_feature_name_table$'
		elsif feature_name$ = "DERIVE_NORMALIZED_PAUSE"
			call set_table_flag 'gv_derive_normalized_pause_feature_name_table$'
		elsif feature_name$ = "DERIVE_NORMALIZED_VOWEL"
			call set_table_flag 'gv_derive_normalized_vowel_feature_name_table$'
		elsif feature_name$ = "DERIVE_NORMALIZED_RHYME"
			call set_table_flag 'gv_derive_normalized_rhyme_feature_name_table$'
		elsif feature_name$ = "DERIVE_F0_FEATURE"
			call set_table_flag 'gv_derive_f0_feature_name_table$'
		elsif feature_name$ = "DERIVE_ENERGY_FEATURE"
			call set_table_flag 'gv_derive_energy_feature_name_table$'
		elsif feature_name$ = "DERIVE_AVERAGE_PHONE"
			call set_table_flag 'gv_derive_average_phone_feature_name_table$'
		else
			tf_'feature_name$' = 1
		endif
	endfor
	select userParamTableID
	Remove
	# add to table
	Create Table... output_pf_table 'gv_pf_no' 1
	outputPfTableID = selected("Table", -1)
	gv_output_pf_name_no = 0
	call add_to_output_pf_table 'gv_feature_name_table$'
endproc	

procedure add_to_output_pf_table feature_name_table$
	if tk_DEBUG >= 4
		printline [proceed in add_to_output_pf_table 'feature_name_table$']
	endif
	select outputPfTableID
	column_no = Get number of columns
	Read Table from table file... 'feature_name_table$'
	featureNameTableID = selected("Table", -1)
	row_no = Get number of rows
	for i from 1 to row_no
		select featureNameTableID
		feature_name$ = Get value... 'i' FEATURE_NAME
		tmp_feature_name$ = feature_name$
		dollar_pos = index(feature_name$, "$")
		if dollar_pos <> 0
			tmp_feature_name$ = left$(feature_name$, dollar_pos - 1)
		endif
		select outputPfTableID
		if tf_'tmp_feature_name$' = 1
			gv_output_pf_name_no = gv_output_pf_name_no + 1
			if gv_output_pf_name_no <= column_no
				Set column label (index)... 'gv_output_pf_name_no' 'feature_name$'
			else
				Append column... 'feature_name$'
				column_no = column_no + 1
			endif
		endif
	endfor
	select featureNameTableID
	Remove
endproc

procedure set_output_pf_table
	if tk_DEBUG >= 4
		printline [proceed in set_output_pf_table]
	endif
	select outputPfTableID
	for i from 1 to gv_output_pf_name_no
		feature_name$ = Get column label... 'i'
		dollar_pos = index(feature_name$, "$")
		if dollar_pos = 0
			vf_num_value = vf_'feature_name$'
			if vf_num_value = 1
			    num_value = pf_'feature_name$'
#	printline [gv_pf_index = 'gv_pf_index']	    
#	printline [feature_name = 'feature_name$']
#	printline [num_value = 'num_value']

				Set numeric value... 'gv_pf_index' 'feature_name$' 'num_value'
    	    endif
		else
		    temp_feature_name$ = left$(feature_name$, dollar_pos - 1)
		    vf_str_value = vf_'temp_feature_name$'
			if vf_str_value = 1
			    str_value$ = pf_'feature_name$'
    			Set string value... 'gv_pf_index' 'feature_name$' 'str_value$'
    	    endif
		endif
	endfor
endproc

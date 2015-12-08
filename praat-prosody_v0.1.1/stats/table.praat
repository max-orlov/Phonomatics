# table.praat
# contains various table creation procedures
#
#

# - create_phone_lookup_table
# - create_spkr_registration_table
# - create_phone_table
# - create_spkr_feat_table

# - update_phone_table
# - update_spkr_feat_table

# - set_phone_table
# - set_spkr_feat_table

# - locate_spkr_in_registration_table
# - search_phone_lookup_table

# - clear_table
# - reset_phone_table

# - create_global_stats_tables
# - create_spkr_stats_tables

# - set_global_stats_tables
# - set_spkr_stats_tables

include util.praat

procedure create_phone_lookup_table
	if tk_DEBUG > 0
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

procedure create_spkr_registration_table
	if tk_DEBUG > -1
		printline [proceed create_spkr_registration_table]
	endif
	Create Table... spkr_registration_table 1 1
	spkrRegistrationTableID = selected("Table", -1)
	gv_spkr_registration_index = 0
	gv_registered_spkr_no = 0
endproc

procedure create_phone_table phone_table_name$
	if tk_DEBUG > 0
		printline [proceed create_phone_table]
	endif
	Create Table... 'phone_table_name$' 'gNumOfPhones' 5
	phoneTableID = selected("Table", -1)
	Set column label (index)... 1 PHONE
	Set column label (index)... 2 MEAN
	Set column label (index)... 3 STDEV
	Set column label (index)... 4 COUNT
	Set column label (index)... 5 THRESHOLD
	
	call clear_table 'phoneTableID'
	call initialize_phone_table 'phoneTableID'

	Set string value... 1 PHONE AA
	Set string value... 2 PHONE AE
	Set string value... 3 PHONE AH
	Set string value... 4 PHONE AO
	Set string value... 5 PHONE AW
	Set string value... 6 PHONE AX
	Set string value... 7 PHONE AY
	Set string value... 8 PHONE B
	Set string value... 9 PHONE CH
	Set string value... 10 PHONE D
	Set string value... 11 PHONE DH
	Set string value... 12 PHONE EH
	Set string value... 13 PHONE EL
	Set string value... 14 PHONE EN
	Set string value... 15 PHONE ER
	Set string value... 16 PHONE EY
	Set string value... 17 PHONE F
	Set string value... 18 PHONE G
	Set string value... 19 PHONE HH
	Set string value... 20 PHONE IH
	Set string value... 21 PHONE IY
	Set string value... 22 PHONE JH
	Set string value... 23 PHONE K
	Set string value... 24 PHONE L
	Set string value... 25 PHONE M
	Set string value... 26 PHONE N
	Set string value... 27 PHONE NG
	Set string value... 28 PHONE OW
	Set string value... 29 PHONE OY
	Set string value... 30 PHONE P
	Set string value... 31 PHONE R
	Set string value... 32 PHONE S
	Set string value... 33 PHONE SH
	Set string value... 34 PHONE T
	Set string value... 35 PHONE TH
	Set string value... 36 PHONE UH
	Set string value... 37 PHONE UW
	Set string value... 38 PHONE V
	Set string value... 39 PHONE W
	Set string value... 40 PHONE Y
	Set string value... 41 PHONE Z
	Set string value... 42 PHONE ZH
	Set string value... 43 PHONE AXR
	Set string value... 44 PHONE BD
	Set string value... 45 PHONE DD
	Set string value... 46 PHONE DX
	Set string value... 47 PHONE ER
	Set string value... 48 PHONE GD
	Set string value... 49 PHONE IX
	Set string value... 50 PHONE KD
	Set string value... 51 PHONE PD
	Set string value... 52 PHONE TD
	Set string value... 53 PHONE TS
	Set string value... 54 PHONE BR
	Set string value... 55 PHONE GA
	Set string value... 56 PHONE LS
	Set string value... 57 PHONE LG		
	
	num_result1 = phoneTableID
endproc

procedure create_spkr_feat_table
	if tk_DEBUG > -1
		printline [proceed create_spkr_feat_table]
	endif
	Create Table... spkr_feature_table 1 19
    	spkrFeatTableID = selected("Table", -1)
	Set column label (index)... 1 SPKR_ID
	Set column label (index)... 2 MEAN_SLOPE
	Set column label (index)... 3 STDEV_SLOPE
	Set column label (index)... 4 COUNT_SLOPE
	Set column label (index)... 5 MEAN_UNVOICED
	Set column label (index)... 6 STDEV_UNVOICED
	Set column label (index)... 7 COUNT_UNVOICED
	Set column label (index)... 8 MEAN_VOICED
	Set column label (index)... 9 STDEV_VOICED
	Set column label (index)... 10 COUNT_VOICED
	Set column label (index)... 11 MEAN_PITCH
	Set column label (index)... 12 STDEV_PITCH
	Set column label (index)... 13 COUNT_PITCH
	Set column label (index)... 14 MEAN_ENERGY_SLOPE
	Set column label (index)... 15 STDEV_ENERGY_SLOPE
	Set column label (index)... 16 COUNT_ENERGY_SLOPE
	Set column label (index)... 17 MEAN_ENERGY
	Set column label (index)... 18 STDEV_ENERGY
	Set column label (index)... 19 COUNT_ENERGY
	call clear_table 'spkrFeatTableID'
endproc

procedure update_phone_table phoneTableID phone_label$ phone_dur
#	if tk_DEBUG > -1
#		printline [proceed update_phone_table]
#	endif
	call search_phone_lookup_table 'phone_label$'
	row_index = num_result1
	select 'phoneTableID'
	mean_sum_value = Get value... 'row_index' MEAN
	square_sum_value = Get value... 'row_index' STDEV
	no_count_value = Get value... 'row_index' COUNT
	threshold_value = Get value... 'row_index' THRESHOLD
	if phone_dur < threshold_value
		mean_sum_value = mean_sum_value + phone_dur
		square_sum_value = square_sum_value + phone_dur * phone_dur
		no_count_value = no_count_value + 1
		Set numeric value... 'row_index' MEAN 'mean_sum_value'
		Set numeric value... 'row_index' STDEV 'square_sum_value'
		Set numeric value... 'row_index' COUNT 'no_count_value'
	endif
endproc

procedure update_spkr_feat_table type$ dur
	if tk_DEBUG > -1
		printline [proceed update_spkr_feat_table]
	endif
	select spkrFeatTableID
	mean_label$ = "MEAN_" + type$
	stdev_label$ = "STDEV_" + type$
	count_label$ = "COUNT_" + type$
	mean_sum_value = Get value... 'gv_spkr_registration_index' 'mean_label$'
	square_sum_value = Get value... 'gv_spkr_registration_index' 'stdev_label$'
	no_count_value = Get value... 'gv_spkr_registration_index' 'count_label$'
	mean_sum_value = mean_sum_value + dur
	square_sum_value = square_sum_value + dur * dur
	no_count_value = no_count_value + 1
#	if gv_spkr_id$ = "D"  
#	   printline [mean_label = 'mean_label$']
#	   printline [gv_spkr_registration_index = 'gv_spkr_registration_index']
#	   printline [mean_sum_value = 'mean_sum_value']
#	endif

	Set numeric value... 'gv_spkr_registration_index' 'mean_label$' 'mean_sum_value'
	Set numeric value... 'gv_spkr_registration_index' 'stdev_label$' 'square_sum_value'
	Set numeric value... 'gv_spkr_registration_index' 'count_label$' 'no_count_value'
endproc


procedure set_phone_table phoneTableID
    	if tk_DEBUG > -1
		printline [proceed set_phone_table]
	endif
	select 'phoneTableID'

	for row_id from 1 to 'gNumOfPhones'
		phone_label$ = Get value... 'row_id' PHONE
		mean_sum_value = Get value... 'row_id' MEAN
		square_sum_value = Get value... 'row_id' STDEV
		no_count_value = Get value... 'row_id' COUNT

		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		threshold_value = mean_value + 10 * stdev_value
		Set numeric value... 'row_id' MEAN 'mean_value'
		Set numeric value... 'row_id' STDEV 'stdev_value'
		Set numeric value... 'row_id' THRESHOLD 'threshold_value'
	endfor
endproc

procedure set_spkr_feat_table
	if tk_DEBUG > -1
		printline [proceed set_spkr_feat_table]
	endif
	select spkrFeatTableID
	spkr_no = Get number of rows
	for i from 1 to spkr_no
		mean_sum_value = Get value... 'i' MEAN_SLOPE
		square_sum_value = Get value... 'i' STDEV_SLOPE
		no_count_value = Get value... 'i' COUNT_SLOPE
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_SLOPE 'mean_value'
		Set numeric value... 'i' STDEV_SLOPE 'stdev_value'	
	
		mean_sum_value = Get value... 'i' MEAN_UNVOICED
		square_sum_value = Get value... 'i' STDEV_UNVOICED
		no_count_value = Get value... 'i' COUNT_UNVOICED
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_UNVOICED 'mean_value'
		Set numeric value... 'i' STDEV_UNVOICED 'stdev_value'	

		mean_sum_value = Get value... 'i' MEAN_VOICED
		square_sum_value = Get value... 'i' STDEV_VOICED
		no_count_value = Get value... 'i' COUNT_VOICED
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_VOICED 'mean_value'
		Set numeric value... 'i' STDEV_VOICED 'stdev_value'
		
		mean_sum_value = Get value... 'i' MEAN_PITCH
		square_sum_value = Get value... 'i' STDEV_PITCH
		no_count_value = Get value... 'i' COUNT_PITCH
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_PITCH 'mean_value'
		Set numeric value... 'i' STDEV_PITCH 'stdev_value'	
		
		mean_sum_value = Get value... 'i' MEAN_ENERGY_SLOPE
		square_sum_value = Get value... 'i' STDEV_ENERGY_SLOPE
		no_count_value = Get value... 'i' COUNT_ENERGY_SLOPE
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_ENERGY_SLOPE 'mean_value'
		Set numeric value... 'i' STDEV_ENERGY_SLOPE 'stdev_value'
		
		mean_sum_value = Get value... 'i' MEAN_ENERGY
		square_sum_value = Get value... 'i' STDEV_ENERGY
		no_count_value = Get value... 'i' COUNT_ENERGY
		call compute_stats 'mean_sum_value' 'square_sum_value' 'no_count_value'
		mean_value = num_result1
		stdev_value = num_result2
		Set numeric value... 'i' MEAN_ENERGY 'mean_value'
		Set numeric value... 'i' STDEV_ENERGY 'stdev_value'
	endfor
endproc

procedure locate_spkr_in_registration_table spkr_id$
# locate the index of the spkr_id$ in the spkr_id_table
# if there is no column for this spkr_id, then add it to the
# right of the table, this procedure also returns the 
# object ID of the speaker table
	if tk_DEBUG > -1
		printline [proceed locate_spkr_in_registration_table]
	endif
	select spkrRegistrationTableID
	column_no = Get number of columns
	column_index = Get column index... 'spkr_id$'
	if column_index = 0
		# register spkr
		gv_registered_spkr_no = gv_registered_spkr_no + 1
		if column_no >= gv_registered_spkr_no
			# modify the spker_registration_table
			select spkrRegistrationTableID
			Set column label (index)... 'gv_registered_spkr_no' 'spkr_id$'
			# modify the spkr_feat_talbe
			select spkrFeatTableID
			Set string value... 'gv_registered_spkr_no' SPKR_ID 'spkr_id$'			
		else
			# append one column to spker_registration_table
			select spkrRegistrationTableID
			Append column... 'spkr_id$'
			# append one row to spkr_feat_table
			select spkrFeatTableID
			Append row
			spkrFeatTable_column_no = Get number of columns
			for column_id from 1 to spkrFeatTable_column_no
			    column_label$ = Get column label... 'column_id'
			    Set numeric value... 'gv_registered_spkr_no' 'column_label$' 0
			endfor
			Set string value... 'gv_registered_spkr_no' SPKR_ID 'spkr_id$'
		endif
		gv_spkr_registration_index = gv_registered_spkr_no
		# create the spkr_phone_table for that speaker
	else
		gv_spkr_registration_index = column_index
	endif
endproc


procedure clear_spkr_registration_table
	if tk_DEBUG > -1
		printline [proceed in clear_spkr_registration_table]
	endif
	select spkrRegistrationTableID
	column_no = Get number of columns
	for i from 1 to column_no
		spkr_id$ = Get column label... 'i'
		Set numeric value... 1 'spkr_id$' 0
	endfor
endproc


procedure clear_status_in_spkr_registration_table spkr_id$
	if tk_DEBUG > -1
		printline [proceed in clear_status_in_spkr_registration_table 'spkr_id$']
	endif
	select spkrRegistrationTableID
	Set numeric value... 1 'spkr_id$' 0
endproc

procedure set_status_in_spkr_registration_table spkr_id$
	if tk_DEBUG > -1
		printline [proceed in set_status_spkr_registration_table]
	endif
	select spkrRegistrationTableID
	Set numeric value... 1 'spkr_id$' 1
endproc


procedure query_status_in_spkr_registration_table spkr_id$
	if tk_DEBUG > -1
		printline [proceed in query_status_in_spkr_registration_table spkr_id$]
	endif
	select spkrRegistrationTableID
	num_resutl1 = Get value... 1 'spkr_id$'
endproc

procedure search_phone_lookup_table phone_label$
# return in num_result1 the column index for phone_label$
# in the phone_lookup_table
	if tk_DEBUG > -1
#		printline [proceed search_phone_lookup_table]
	endif
	select 'phoneLookupTableID'
	num_result1 = Get column index... 'phone_label$'
endproc

procedure clear_table inputTableID
	if tk_DEBUG > 0
		printline [proceed in clear_table]
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

procedure initialize_phone_table phoneTableID
	if tk_DEBUG > 0
		printline [proceed initialize_phone_table]
	endif
	select phoneTableID
	row_no = Get number of rows
	for i from 1 to row_no
		Set numeric value... 'i' THRESHOLD gc_pos_infinit
	endfor
endproc

procedure reset_phone_table phoneTableID
	if tk_DEBUG > -1
		printline [proceed reset_phone_table]
	endif
	select 'phoneTableID'
	for i from 1 to 'gNumOfPhones'
		Set numeric value... 'i' MEAN 0
		Set numeric value... 'i' STDEV 0
		Set numeric value... 'i' COUNT 0
	endfor
endproc

procedure create_global_stats_tables
	if tk_DEBUG > -1
		printline [proceed create_global_stats_tables]
	endif
	call create_phone_lookup_table
	call create_spkr_registration_table
	call create_phone_table global_phone_table
	globalPhoneTableID = num_result1
	call create_spkr_feat_table
endproc

procedure set_global_stats_tables
	if tk_DEBUG > -1
		printline [proceed set_global_stats_tables]
	endif
	call set_phone_table 'globalPhoneTableID'
endproc

procedure set_spkr_stats_tables
	if tk_DEBUG > -1
		printline [proceed set_spkr_stats_tables]
	endif
	call set_spkr_feat_table
	call set_phone_table 'spkrPhoneTableID'
endproc






















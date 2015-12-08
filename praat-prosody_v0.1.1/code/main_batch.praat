# main_batch.praat
#
# control file of whole
#
#----------------------------------------
include operations.praat

form Varuables
	sentence wav_info_table
	text user_pf_name_table
	text stats_dir
	sentence work_dir
	integer use_existing_param_files
endform

call init_toolkit
call extract_feats
call post_toolkit

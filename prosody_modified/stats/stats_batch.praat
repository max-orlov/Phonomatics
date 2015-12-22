# stats_batch.praat
#
# control file of whole
#
#----------------------------------------
include operations.praat

form Varuables
	sentence wav_info_table
	sentence work_dir
	integer use_existing_param_files
endform

call init_toolkit
call extract_stats
call post_toolkit

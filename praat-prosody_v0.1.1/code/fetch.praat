# fetch.praat
#
# routines to fetch features and stats
# - fetch_pf
# 	- fetch_base_feature
# 	- fetch_dur_feature
# 	- fetch_f0_feature
#

include routines.praat
include table.praat
include config.praat

procedure fetch_pf
	call fetch_base_feature
	call fetch_dur_feature
	call fetch_f0_feature
	call fetch_energy_feature
endproc

procedure fetch_base_feature
	if tk_DEBUG >= 5
		printline [proceed in fetch_base_feature]
	endif
	wd_index = gv_pf_index
	select wordTableID
	pf_WORD$ = Get value... wd_index word
	vf_WORD = 1
  	word_start = Get value... wd_index xmin
  	pf_WORD_START = round(word_start / gc_frame_size)
  	vf_WORD_START = 1
  	word_end = Get value... wd_index xmax
  	pf_WORD_END = round(word_end / gc_frame_size)
  	vf_WORD_END = 1
##last_word:
	if gv_pf_index < gv_pf_no
		pf_FWORD$ = Get value... wd_index+1 word
  		vf_FWORD = 1
  		fword_start = Get value... wd_index+1 xmin
  		pf_FWORD_START = round(fword_start / gc_frame_size)
  		vf_FWORD_START = 1
  		fword_end = Get value... wd_index+1 xmax
  		pf_FWORD_END = round(fword_end / gc_frame_size)
  		vf_FWORD_END = 1
  		pf_PAUSE_START = pf_WORD_END
  		vf_PAUSE_START = 1
  		pf_PAUSE_END = pf_FWORD_START
  		vf_PAUSE_END = 1
  		pf_PAUSE_DUR = pf_PAUSE_END - pf_PAUSE_START
  		vf_PAUSE_DUR = 1
	else
  		vf_FWORD = 0
  		vf_FWORD_START = 0
  		vf_FWORD_END = 0
		pf_PAUSE_START = pf_WORD_END
  		vf_PAUSE_START = 1
		pf_PAUSE_END = round(gv_finishing_time / gc_frame_size)
  		vf_PAUSE_END = 1
		pf_PAUSE_DUR = pf_PAUSE_END - pf_PAUSE_START
  		vf_PAUSE_DUR = 1
	endif

	call fetch_WORD_PHONES_and_FLAG phoneTextGridID word_start word_end
endproc
procedure fetch_WORD_PHONES_and_FLAG phoneTextGridID startingTime endTime
	if tk_DEBUG >= 5
		printline [proceed in fetch_WORD_PHONES_and_FLAG 'phoneTextGridID' 'startingTime' 'endTime']
	endif
	call fn_WORD_PHONES_and_FLAG phoneTextGridID startingTime endTime
	pf_WORD_PHONES$ = str_result1$
	vf_WORD_PHONES = 1
	pf_FLAG$ = str_result2$
	vf_FLAG = 1
endproc

#
procedure fetch_dur_feature
	if tk_DEBUG >= 5
		printline [proceed in fetch_dur_feature]
	endif
	wd_index = gv_pf_index
	select wordTableID
 	wd_start = Get value... wd_index xmin
  wd_end = Get value... wd_index xmax

  call find_last_interval 'vowelTextGridID' 'wd_start' 'wd_end'
  last_interval = num_result1
  if last_interval > 0
  	select vowelTextGridID
	  vowel_start =  Get starting point... 1 last_interval
		pf_LAST_VOWEL_START = round(vowel_start / gc_frame_size)
		vf_LAST_VOWEL_START = 1
  	vowel_end =  Get end point... 1 last_interval
		pf_LAST_VOWEL_END = round(vowel_end / gc_frame_size)
		vf_LAST_VOWEL_END = 1
		select phoneTextGridID
		mid_vowel = (pf_LAST_VOWEL_START + pf_LAST_VOWEL_END) * gc_frame_size / 2
		inter_index = Get interval at time... 1 'mid_vowel'
		pf_LAST_VOWEL$ = Get label of interval... 1 'inter_index'
		vf_LAST_VOWEL = 1
		pf_LAST_VOWEL_DUR = pf_LAST_VOWEL_END - pf_LAST_VOWEL_START
		vf_LAST_VOWEL_DUR = 1
	else
  	vf_LAST_VOWEL_START =  0
   	vf_LAST_VOWEL_END   =  0
		vf_LAST_VOWEL = 0
		vf_LAST_VOWEL_DUR = 0
  endif
	
	call find_last_interval 'rhymeTextGridID' 'wd_start' 'wd_end'
  last_interval = num_result1
	if last_interval > 0
  	select rhymeTextGridID
		rhyme_start =  Get starting point... 1 last_interval
		pf_LAST_RHYME_START = round(rhyme_start / gc_frame_size)
		vf_LAST_RHYME_START = 1
	  rhyme_end =  Get end point... 1 last_interval
		pf_LAST_RHYME_END = round(rhyme_end / gc_frame_size)
		vf_LAST_RHYME_END = 1
		pf_LAST_RHYME_DUR = pf_LAST_RHYME_END - pf_LAST_RHYME_START
		vf_LAST_RHYME_DUR = 1
		call find_interval_range 'phoneTextGridID' 'rhyme_start' 'rhyme_end'
		startingInterval = num_result1
		endInterval = num_result2		
		select phoneTextGridID
		pf_PHONES_IN_LAST_RHYME = 0
		vf_PHONES_IN_LAST_RHYME = 1
		pf_NORM_LAST_RHYME_DUR = 0
		vf_NORM_LAST_RHYME_DUR = 1
		for i from startingInterval to endInterval
			select phoneTextGridID
			label$ = Get label of interval... 1 'i'
			if label$ <> ""
				pf_PHONES_IN_LAST_RHYME = pf_PHONES_IN_LAST_RHYME + 1
				call lookup_phone_table 'globalPhoneTableID' 'label$' MEAN
				phone_mean = num_result1
				call lookup_phone_table 'globalPhoneTableID' 'label$' STDEV
				phone_stdev = num_result1
				if phone_mean = -1 or phone_stdev = -1
			    vf_NORM_LAST_RHYME_DUR = 0
				else
			    select 'phoneTextGridID'
			    start = Get starting point... 1 'i'
			    end = Get end point... 1 'i'
			    dur = round((end - start) / gc_frame_size)
			    pf_NORM_LAST_RHYME_DUR = pf_NORM_LAST_RHYME_DUR + ((dur - phone_mean) / phone_stdev)
				endif
 			endif
		endfor
  else
  	vf_LAST_RHYME_START = 0
  	vf_LAST_RHYME_END = 0
    vf_LAST_RHYME_DUR = 0
    vf_PHONES_IN_LAST_RHYME = 0
    vf_NORM_LAST_RHYME_DUR = 0
	endif
endproc



# fetch f0 features 
# by Zhongqiang
# 6/29/2005
procedure fetch_f0_feature
	wd_index = gv_pf_index
	if tk_DEBUG >= 5
		printline [proceed in fetch_f0_feature]
	endif
	select wordTableID
	word_start = Get value... wd_index xmin
	word_end = Get value... wd_index xmax

	call fetch_f0_feature_in_range 'word_start' 'word_end'
	pf_MIN_F0 = num_MIN_F0
	vf_MIN_F0 = vf_num_MIN_F0
	pf_MIN_STYLFIT_F0 = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_F0 = vf_num_MIN_STYLFIT_F0
	pf_MAX_F0 = num_MAX_F0
	vf_MAX_F0 = vf_num_MAX_F0
	pf_MAX_STYLFIT_F0 = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_F0 = vf_num_MAX_STYLFIT_F0
	pf_MEAN_F0 = num_MEAN_F0
	vf_MEAN_F0 = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_F0 = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_F0 = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_F0 = num_FIRST_F0
	vf_FIRST_STYLFIT_F0 = vf_num_FIRST_F0
	pf_LAST_STYLFIT_F0 = num_LAST_F0
	vf_LAST_STYLFIT_F0 = vf_num_LAST_F0
	pf_PATTERN_WORD$ = str_PATTERN_WORD$
	vf_PATTERN_WORD = vf_str_PATTERN_WORD
	pf_PATTERN_WORD_COLLAPSED$ = str_PATTERN_WORD_COLLAPSED$
	vf_PATTERN_WORD_COLLAPSED = vf_str_PATTERN_WORD_COLLAPSED
	pf_PATTERN_SLOPE$ = str_PATTERN_SLOPE$
	vf_PATTERN_SLOPE = vf_str_PATTERN_SLOPE
	pf_NO_PREVIOUS_SSF = num_NO_PREVIOUS_SSF
	vf_NO_PREVIOUS_SSF = vf_num_NO_PREVIOUS_SSF
	pf_NO_PREVIOUS_VF = num_NO_PREVIOUS_VF
	vf_NO_PREVIOUS_VF = vf_num_NO_PREVIOUS_VF
	pf_NO_FRAMES_LS_WE = num_NO_FRAMES_LS_WE
	vf_NO_FRAMES_LS_WE = vf_num_NO_FRAMES_LS_WE
	pf_NO_SUCCESSOR_SSF = num_NO_SUCCESSOR_SSF
	vf_NO_SUCCESSOR_SSF = vf_num_NO_SUCCESSOR_SSF
	pf_NO_SUCCESSOR_VF = num_NO_SUCCESSOR_VF
	vf_NO_SUCCESSOR_VF = vf_num_NO_SUCCESSOR_VF
	pf_NO_FRAMES_WS_FS = num_NO_FRAMES_WS_FS
	vf_NO_FRAMES_WS_FS = vf_num_NO_FRAMES_WS_FS

	
	win_end = word_end
	win_start = word_end - gc_win_size
	if win_start < 0
		win_start = 0
	endif
	call fetch_f0_feature_in_range 'win_start' 'win_end'
	pf_MIN_F0_WIN = num_MIN_F0
	vf_MIN_F0_WIN = vf_num_MIN_F0
	pf_MIN_STYLFIT_F0_WIN = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_F0_WIN = vf_num_MIN_STYLFIT_F0
	pf_MAX_F0_WIN = num_MAX_F0
	vf_MAX_F0_WIN = vf_num_MAX_F0
	pf_MAX_STYLFIT_F0_WIN = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_F0_WIN = vf_num_MAX_STYLFIT_F0
	pf_MEAN_F0_WIN = num_MEAN_F0
	vf_MEAN_F0_WIN = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_F0_WIN = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_F0_WIN = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_F0_WIN = num_FIRST_F0
	vf_FIRST_STYLFIT_F0_WIN = vf_num_FIRST_F0
	pf_LAST_STYLFIT_F0_WIN = num_LAST_F0
	vf_LAST_STYLFIT_F0_WIN = vf_num_LAST_F0
	pf_PATTERN_WORD_WIN$ = str_PATTERN_WORD$
	vf_PATTERN_WORD_WIN = vf_str_PATTERN_WORD
	pf_PATTERN_WORD_COLLAPSED_WIN$ = str_PATTERN_WORD_COLLAPSED$
	vf_PATTERN_WORD_COLLAPSED_WIN = vf_str_PATTERN_WORD_COLLAPSED
	pf_PATTERN_SLOPE_WIN$ = str_PATTERN_SLOPE$
	vf_PATTERN_SLOPE_WIN = vf_str_PATTERN_SLOPE
	pf_NO_PREVIOUS_SSF_WIN = num_NO_PREVIOUS_SSF
	vf_NO_PREVIOUS_SSF_WIN = vf_num_NO_PREVIOUS_SSF
	pf_NO_PREVIOUS_VF_WIN = num_NO_PREVIOUS_VF
	vf_NO_PREVIOUS_VF_WIN = vf_num_NO_PREVIOUS_VF
	pf_NO_FRAMES_LS_WE_WIN = num_NO_FRAMES_LS_WE
	vf_NO_FRAMES_LS_WE_WIN = vf_num_NO_FRAMES_LS_WE
	pf_NO_SUCCESSOR_SSF_WIN = num_NO_SUCCESSOR_SSF
	vf_NO_SUCCESSOR_SSF_WIN = vf_num_NO_SUCCESSOR_SSF
	pf_NO_SUCCESSOR_VF_WIN = num_NO_SUCCESSOR_VF
	vf_NO_SUCCESSOR_VF_WIN = vf_num_NO_SUCCESSOR_VF
	pf_NO_FRAMES_WS_FS_WIN = num_NO_FRAMES_WS_FS
	vf_NO_FRAMES_WS_FS_WIN = vf_num_NO_FRAMES_WS_FS


	if wd_index = gv_pf_no
		vf_MIN_F0_NEXT = 0
		vf_MIN_STYLFIT_F0_NEXT = 0
		vf_MAX_F0_NEXT = 0
		vf_MAX_STYLFIT_F0_NEXT = 0
		vf_MEAN_F0_NEXT = 0
		vf_MEAN_STYLFIT_F0_NEXT = 0
		vf_FIRST_STYLFIT_F0_NEXT = 0
		vf_LAST_STYLFIT_F0_NEXT = 0
		vf_PATTERN_WORD_NEXT = 0
		vf_PATTERN_WORD_COLLAPSED_NEXT = 0
		vf_PATTERN_SLOPE_NEXT = 0
		vf_NO_PREVIOUS_SSF_NEXT = 0
		vf_NO_PREVIOUS_VF_NEXT = 0
		vf_NO_FRAMES_LS_WE_NEXT = 0
		vf_NO_SUCCESSOR_SSF_NEXT = 0
		vf_NO_SUCCESSOR_VF_NEXT = 0
		vf_NO_FRAMES_WS_FS_NEXT = 0
		vf_MIN_F0_NEXT_WIN = 0
		vf_MIN_STYLFIT_F0_NEXT_WIN = 0
		vf_MAX_F0_NEXT_WIN = 0
		vf_MAX_STYLFIT_F0_NEXT_WIN = 0
		vf_MEAN_F0_NEXT_WIN = 0
		vf_MEAN_STYLFIT_F0_NEXT_WIN = 0
		vf_FIRST_STYLFIT_F0_NEXT_WIN = 0
		vf_LAST_STYLFIT_F0_NEXT_WIN = 0
		vf_PATTERN_WORD_NEXT_WIN = 0
		vf_PATTERN_WORD_COLLAPSED_NEXT_WIN = 0
		vf_PATTERN_SLOPE_NEXT_WIN = 0
		vf_NO_PREVIOUS_SSF_NEXT_WIN = 0
		vf_NO_PREVIOUS_VF_NEXT_WIN = 0
		vf_NO_FRAMES_LS_WE_NEXT_WIN = 0
		vf_NO_SUCCESSOR_SSF_NEXT_WIN = 0
		vf_NO_SUCCESSOR_VF_NEXT_WIN = 0
		vf_NO_FRAMES_WS_FS_NEXT_WIN = 0
		
		pf_PATTERN_WORD_NEXT$ = ""
		pf_PATTERN_SLOPE_NEXT$ = ""

	else
	select Table word_table
	wd_index_next = wd_index + 1
	word_start = Get value... wd_index_next xmin
	word_end = Get value... wd_index_next xmax
	call fetch_f0_feature_in_range 'word_start' 'word_end'
	pf_MIN_F0_NEXT = num_MIN_F0
	vf_MIN_F0_NEXT = vf_num_MIN_F0
	pf_MIN_STYLFIT_F0_NEXT = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_F0_NEXT = vf_num_MIN_STYLFIT_F0
	pf_MAX_F0_NEXT = num_MAX_F0
	vf_MAX_F0_NEXT = vf_num_MAX_F0
	pf_MAX_STYLFIT_F0_NEXT = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_F0_NEXT = vf_num_MAX_STYLFIT_F0
	pf_MEAN_F0_NEXT = num_MEAN_F0
	vf_MEAN_F0_NEXT = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_F0_NEXT = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_F0_NEXT = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_F0_NEXT = num_FIRST_F0
	vf_FIRST_STYLFIT_F0_NEXT = vf_num_FIRST_F0
	pf_LAST_STYLFIT_F0_NEXT = num_LAST_F0
	vf_LAST_STYLFIT_F0_NEXT = vf_num_LAST_F0
	pf_PATTERN_WORD_NEXT$ = str_PATTERN_WORD$
	vf_PATTERN_WORD_NEXT = vf_str_PATTERN_WORD
	pf_PATTERN_WORD_COLLAPSED_NEXT$ = str_PATTERN_WORD_COLLAPSED$
	vf_PATTERN_WORD_COLLAPSED_NEXT = vf_str_PATTERN_WORD_COLLAPSED
	pf_PATTERN_SLOPE_NEXT$ = str_PATTERN_SLOPE$
	vf_PATTERN_SLOPE_NEXT = vf_str_PATTERN_SLOPE
	pf_NO_PREVIOUS_SSF_NEXT = num_NO_PREVIOUS_SSF
	vf_NO_PREVIOUS_SSF_NEXT = vf_num_NO_PREVIOUS_SSF
	pf_NO_PREVIOUS_VF_NEXT = num_NO_PREVIOUS_VF
	vf_NO_PREVIOUS_VF_NEXT = vf_num_NO_PREVIOUS_VF
	pf_NO_FRAMES_LS_WE_NEXT = num_NO_FRAMES_LS_WE
	vf_NO_FRAMES_LS_WE_NEXT = vf_num_NO_FRAMES_LS_WE
	pf_NO_SUCCESSOR_SSF_NEXT = num_NO_SUCCESSOR_SSF
	vf_NO_SUCCESSOR_SSF_NEXT = vf_num_NO_SUCCESSOR_SSF
	pf_NO_SUCCESSOR_VF_NEXT = num_NO_SUCCESSOR_VF
	vf_NO_SUCCESSOR_VF_NEXT = vf_num_NO_SUCCESSOR_VF
	pf_NO_FRAMES_WS_FS_NEXT = num_NO_FRAMES_WS_FS
	vf_NO_FRAMES_WS_FS_NEXT = vf_num_NO_FRAMES_WS_FS

	win_start = word_start
	win_end = win_start + gc_win_size
	if win_end > gv_finishing_time
		win_end = gv_finishing_time
	endif
	call fetch_f0_feature_in_range 'win_start' 'win_end'
	pf_MIN_F0_NEXT_WIN = num_MIN_F0
	vf_MIN_F0_NEXT_WIN = vf_num_MIN_F0
	pf_MIN_STYLFIT_F0_NEXT_WIN = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_F0_NEXT_WIN = vf_num_MIN_STYLFIT_F0
	pf_MAX_F0_NEXT_WIN = num_MAX_F0
	vf_MAX_F0_NEXT_WIN = vf_num_MAX_F0
	pf_MAX_STYLFIT_F0_NEXT_WIN = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_F0_NEXT_WIN = vf_num_MAX_STYLFIT_F0
	pf_MEAN_F0_NEXT_WIN = num_MEAN_F0
	vf_MEAN_F0_NEXT_WIN = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_F0_NEXT_WIN = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_F0_NEXT_WIN = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_F0_NEXT_WIN = num_FIRST_F0
	vf_FIRST_STYLFIT_F0_NEXT_WIN = vf_num_FIRST_F0
	pf_LAST_STYLFIT_F0_NEXT_WIN = num_LAST_F0
	vf_LAST_STYLFIT_F0_NEXT_WIN = vf_num_LAST_F0
	pf_PATTERN_WORD_NEXT_WIN$ = str_PATTERN_WORD$
	vf_PATTERN_WORD_NEXT_WIN = vf_str_PATTERN_WORD
	pf_PATTERN_WORD_COLLAPSED_NEXT_WIN$ = str_PATTERN_WORD_COLLAPSED$
	vf_PATTERN_WORD_COLLAPSED_NEXT_WIN = vf_str_PATTERN_WORD_COLLAPSED
	pf_PATTERN_SLOPE_NEXT_WIN$ = str_PATTERN_SLOPE$
	vf_PATTERN_SLOPE_NEXT_WIN = vf_str_PATTERN_SLOPE
	pf_NO_PREVIOUS_SSF_NEXT_WIN = num_NO_PREVIOUS_SSF
	vf_NO_PREVIOUS_SSF_NEXT_WIN = vf_num_NO_PREVIOUS_SSF
	pf_NO_PREVIOUS_VF_NEXT_WIN = num_NO_PREVIOUS_VF
	vf_NO_PREVIOUS_VF_NEXT_WIN = vf_num_NO_PREVIOUS_VF
	pf_NO_FRAMES_LS_WE_NEXT_WIN = num_NO_FRAMES_LS_WE
	vf_NO_FRAMES_LS_WE_NEXT_WIN = vf_num_NO_FRAMES_LS_WE
	pf_NO_SUCCESSOR_SSF_NEXT_WIN = num_NO_SUCCESSOR_SSF
	vf_NO_SUCCESSOR_SSF_NEXT_WIN = vf_num_NO_SUCCESSOR_SSF
	pf_NO_SUCCESSOR_VF_NEXT_WIN = num_NO_SUCCESSOR_VF
	vf_NO_SUCCESSOR_VF_NEXT_WIN = vf_num_NO_SUCCESSOR_VF
	pf_NO_FRAMES_WS_FS_NEXT_WIN = num_NO_FRAMES_WS_FS
	vf_NO_FRAMES_WS_FS_NEXT_WIN = vf_num_NO_FRAMES_WS_FS

	endif 
	if pf_PATTERN_WORD$ <> "" and pf_PATTERN_WORD_NEXT$ <> ""
	   call fetch_PATTERN_BOUNDARY 'pf_PATTERN_WORD$' 'pf_PATTERN_WORD_NEXT$'
	else
	   vf_PATTERN_BOUNDARY = 0
	endif
	if pf_PATTERN_SLOPE$ <> "" and pf_PATTERN_SLOPE_NEXT$ <> ""
	   call fetch_SLOPE_DIFF 'pf_PATTERN_SLOPE$' 'pf_PATTERN_SLOPE_NEXT$'
	else
	   vf_SLOPE_DIFF = 0
	endif
	
endproc

procedure fetch_f0_feature_in_range start_time end_time
	if tk_DEBUG >= 5
		printline [proceed in fetch_f0_feature_in_range 'start_time' 'end_time']
	endif
	call fn_MIN_F0 'rawPitchTierID' 'start_time' 'end_time'
	num_MIN_F0 = num_result1
	vf_num_MIN_F0 = vf_num_result1
	call fn_MIN_F0 'stylPitchTierID' 'start_time' 'end_time'
	num_MIN_STYLFIT_F0 = num_result1
	vf_num_MIN_STYLFIT_F0 = vf_num_result1
	call fn_MAX_F0 'rawPitchTierID' 'start_time' 'end_time'
	num_MAX_F0 = num_result1
	vf_num_MAX_F0 = vf_num_result1
	call fn_MAX_F0 'stylPitchTierID' 'start_time' 'end_time'
	num_MAX_STYLFIT_F0 = num_result1
	vf_num_MAX_STYLFIT_F0 = vf_num_result1
	call fn_MEAN_F0 'rawPitchTierID' 'start_time' 'end_time'
	num_MEAN_F0 = num_result1
	vf_num_MEAN_F0 = vf_num_result1
	call fn_MEAN_F0 'stylPitchTierID' 'start_time' 'end_time'
	num_MEAN_STYLFIT_F0 = num_result1	
	vf_num_MEAN_STYLFIT_F0 = vf_num_result1
	call fn_FIRST_F0 stylPitchTierID start_time end_time
	num_FIRST_F0 = num_result1
	vf_num_FIRST_F0 = vf_num_result1
	call fn_LAST_F0 stylPitchTierID start_time end_time
	num_LAST_F0 = num_result1
	vf_num_LAST_F0 = vf_num_result1
	call fn_PATTERN_WORD 'slopeTextGridID' 'start_time' 'end_time'
	str_PATTERN_WORD$ = str_result1$
	vf_str_PATTERN_WORD = vf_str_result1
	call fn_PATTERN_WORD_COLLAPSED 'slopeTextGridID' 'start_time' 'end_time'
	str_PATTERN_WORD_COLLAPSED$ = str_result1$
	vf_str_PATTERN_WORD_COLLAPSED = vf_str_result1
	call fn_PATTERN_SLOPE 'slopeTextGridID' 'start_time' 'end_time'
	str_PATTERN_SLOPE$ = str_result1$
	vf_str_PATTERN_SLOPE = vf_str_result1
	call fn_NO_PREVIOUS_SSF 'slopeTextGridID' 'start_time' 'end_time'
	num_NO_PREVIOUS_SSF = num_result1
	vf_num_NO_PREVIOUS_SSF = vf_num_result1
	call fn_NO_PREVIOUS_VF 'vuvTextGridID' 'start_time' 'end_time'
	num_NO_PREVIOUS_VF = num_result1
	vf_num_NO_PREVIOUS_VF = vf_num_result1
	call fn_NO_FRAMES_LS_WE 'vuvTextGridID' 'start_time' 'end_time'
	num_NO_FRAMES_LS_WE = num_result1
	vf_num_NO_FRAMES_LS_WE = vf_num_result1
	call fn_NO_SUCCESSOR_SSF 'slopeTextGridID' 'start_time' 'end_time'
	num_NO_SUCCESSOR_SSF = num_result1
	vf_num_NO_SUCCESSOR_SSF = vf_num_result1
	call fn_NO_SUCCESSOR_VF 'vuvTextGridID' 'start_time' 'end_time'
	num_NO_SUCCESSOR_VF = num_result1
	vf_num_NO_SUCCESSOR_VF = vf_num_result1
	call fn_NO_FRAMES_WS_FS 'vuvTextGridID' 'start_time' 'end_time'
	num_NO_FRAMES_WS_FS = num_result1
	vf_num_NO_FRAMES_WS_FS = vf_num_result1
endproc

procedure fetch_PATTERN_BOUNDARY pattern_word$ pattern_word_next$
	if tk_DEBUG >= 5
		printline [proceed in fetch_PATTERN_BOUNDARY 'pattern_word$' 'pattern_word_next$']
	endif
	call fn_PATTERN_BOUNDARY 'pattern_word$' 'pattern_word_next$'
	pf_PATTERN_BOUNDARY$ = str_result1$
	vf_PATTERN_BOUNDARY = vf_str_result1
endproc

procedure fetch_SLOPE_DIFF pattern_slope$ pattern_slope_next$
	if tk_DEBUG >= 5
		printline [proceed in fetch_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$']
	endif
	call fn_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$'
	pf_SLOPE_DIFF = num_result1
	vf_SLOPE_DIFF = vf_num_result1
endproc


procedure fetch_energy_feature
	wd_index = gv_pf_index
	if tk_DEBUG >= 5
		printline [proceed in fetch_energy_feature]
	endif
	select wordTableID
	word_start = Get value... wd_index xmin
	word_end = Get value... wd_index xmax
	call fetch_energy_feature_in_range 'word_start' 'word_end'
	pf_MIN_ENERGY = num_MIN_F0
	vf_MIN_ENERGY = vf_num_MIN_F0
	pf_MIN_STYLFIT_ENERGY = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_ENERGY = vf_num_MIN_STYLFIT_F0
	pf_MAX_ENERGY = num_MAX_F0
	vf_MAX_ENERGY = vf_num_MAX_F0
	pf_MAX_STYLFIT_ENERGY = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_ENERGY = vf_num_MAX_STYLFIT_F0
	pf_MEAN_ENERGY = num_MEAN_F0
	vf_MEAN_ENERGY = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_ENERGY = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_ENERGY = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_ENERGY = num_FIRST_F0
	vf_FIRST_STYLFIT_ENERGY = vf_num_FIRST_F0
	pf_LAST_STYLFIT_ENERGY = num_LAST_F0
	vf_LAST_STYLFIT_ENERGY = vf_num_LAST_F0
	pf_ENERGY_PATTERN_WORD$ = str_PATTERN_WORD$
	vf_ENERGY_PATTERN_WORD = vf_str_PATTERN_WORD
	pf_ENERGY_PATTERN_WORD_COLLAPSED$ = str_PATTERN_WORD_COLLAPSED$
	vf_ENERGY_PATTERN_WORD_COLLAPSED = vf_str_PATTERN_WORD_COLLAPSED
	pf_ENERGY_PATTERN_SLOPE$ = str_PATTERN_SLOPE$
	vf_ENERGY_PATTERN_SLOPE = vf_str_PATTERN_SLOPE
	
	win_end = word_end
	win_start = word_end - gc_win_size
	if win_start < 0
		win_start = 0
	endif
	call fetch_energy_feature_in_range 'win_start' 'win_end'
	pf_MIN_ENERGY_WIN = num_MIN_F0
	vf_MIN_ENERGY_WIN = vf_num_MIN_F0
	pf_MIN_STYLFIT_ENERGY_WIN = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_ENERGY_WIN = vf_num_MIN_STYLFIT_F0
	pf_MAX_ENERGY_WIN = num_MAX_F0
	vf_MAX_ENERGY_WIN = vf_num_MAX_F0
	pf_MAX_STYLFIT_ENERGY_WIN = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_ENERGY_WIN = vf_num_MAX_STYLFIT_F0
	pf_MEAN_ENERGY_WIN = num_MEAN_F0
	vf_MEAN_ENERGY_WIN = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_ENERGY_WIN = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_ENERGY_WIN = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_ENERGY_WIN = num_FIRST_F0
	vf_FIRST_STYLFIT_ENERGY_WIN = vf_num_FIRST_F0
	pf_LAST_STYLFIT_ENERGY_WIN = num_LAST_F0
	vf_LAST_STYLFIT_ENERGY_WIN = vf_num_LAST_F0
	pf_ENERGY_PATTERN_WORD_WIN$ = str_PATTERN_WORD$
	vf_ENERGY_PATTERN_WORD_WIN = vf_str_PATTERN_WORD
	pf_ENERGY_PATTERN_WORD_COLLAPSED_WIN$ = str_PATTERN_WORD_COLLAPSED$
	vf_ENERGY_PATTERN_WORD_COLLAPSED_WIN = vf_str_PATTERN_WORD_COLLAPSED
	pf_ENERGY_PATTERN_SLOPE_WIN$ = str_PATTERN_SLOPE$
	vf_ENERGY_PATTERN_SLOPE_WIN = vf_str_PATTERN_SLOPE

	if wd_index = gv_pf_no
	vf_MIN_ENERGY_NEXT = 0
	vf_MIN_STYLFIT_ENERGY_NEXT = 0
	vf_MAX_ENERGY_NEXT = 0
	vf_MAX_STYLFIT_ENERGY_NEXT = 0
	vf_MEAN_ENERGY_NEXT = 0
	vf_MEAN_STYLFIT_ENERGY_NEXT = 0
	vf_FIRST_STYLFIT_ENERGY_NEXT = 0
	vf_LAST_STYLFIT_ENERGY_NEXT = 0
	vf_ENERGY_PATTERN_WORD_NEXT = 0
	vf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT = 0
	vf_ENERGY_PATTERN_SLOPE_NEXT = 0
	
	vf_MIN_ENERGY_NEXT_WIN = 0
	vf_MIN_STYLFIT_ENERGY_NEXT_WIN = 0
	vf_MAX_ENERGY_NEXT_WIN = 0
	vf_MAX_STYLFIT_ENERGY_NEXT_WIN = 0
	vf_MEAN_ENERGY_NEXT_WIN = 0
	vf_MEAN_STYLFIT_ENERGY_NEXT_WIN = 0
	vf_FIRST_STYLFIT_ENERGY_NEXT_WIN = 0
	vf_LAST_STYLFIT_ENERGY_NEXT_WIN = 0
	vf_ENERGY_PATTERN_WORD_NEXT_WIN = 0
	vf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT_WIN = 0
	vf_ENERGY_PATTERN_SLOPE_NEXT_WIN = 0	
	
	pf_ENERGY_PATTERN_WORD_NEXT$ = ""
	pf_ENERGY_PATTERN_SLOPE_NEXT$ = ""
	
	else

	select Table word_table
	wd_index_next = wd_index + 1
	word_start = Get value... wd_index_next xmin
	word_end = Get value... wd_index_next xmax
	call fetch_energy_feature_in_range 'word_start' 'word_end'
	pf_MIN_ENERGY_NEXT = num_MIN_F0
	vf_MIN_ENERGY_NEXT = vf_num_MIN_F0
	pf_MIN_STYLFIT_ENERGY_NEXT = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_ENERGY_NEXT = vf_num_MIN_STYLFIT_F0
	pf_MAX_ENERGY_NEXT = num_MAX_F0
	vf_MAX_ENERGY_NEXT = vf_num_MAX_F0
	pf_MAX_STYLFIT_ENERGY_NEXT = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_ENERGY_NEXT = vf_num_MAX_STYLFIT_F0
	pf_MEAN_ENERGY_NEXT = num_MEAN_F0
	vf_MEAN_ENERGY_NEXT = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_ENERGY_NEXT = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_ENERGY_NEXT = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_ENERGY_NEXT = num_FIRST_F0
	vf_FIRST_STYLFIT_ENERGY_NEXT = vf_num_FIRST_F0
	pf_LAST_STYLFIT_ENERGY_NEXT = num_LAST_F0
	vf_LAST_STYLFIT_ENERGY_NEXT = vf_num_LAST_F0
	pf_ENERGY_PATTERN_WORD_NEXT$ = str_PATTERN_WORD$
	vf_ENERGY_PATTERN_WORD_NEXT = vf_str_PATTERN_WORD
	pf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT$ = str_PATTERN_WORD_COLLAPSED$
	vf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT = vf_str_PATTERN_WORD_COLLAPSED
	pf_ENERGY_PATTERN_SLOPE_NEXT$ = str_PATTERN_SLOPE$
	vf_ENERGY_PATTERN_SLOPE_NEXT = vf_str_PATTERN_SLOPE

	win_start = word_start
	win_end = win_start + gc_win_size
	if win_end > gv_finishing_time
		win_end = gv_finishing_time
	endif
	call fetch_energy_feature_in_range 'win_start' 'win_end'
	pf_MIN_ENERGY_NEXT_WIN = num_MIN_F0
	vf_MIN_ENERGY_NEXT_WIN = vf_num_MIN_F0
	pf_MIN_STYLFIT_ENERGY_NEXT_WIN = num_MIN_STYLFIT_F0
	vf_MIN_STYLFIT_ENERGY_NEXT_WIN = vf_num_MIN_STYLFIT_F0
	pf_MAX_ENERGY_NEXT_WIN = num_MAX_F0
	vf_MAX_ENERGY_NEXT_WIN = vf_num_MAX_F0
	pf_MAX_STYLFIT_ENERGY_NEXT_WIN = num_MAX_STYLFIT_F0
	vf_MAX_STYLFIT_ENERGY_NEXT_WIN = vf_num_MAX_STYLFIT_F0
	pf_MEAN_ENERGY_NEXT_WIN = num_MEAN_F0
	vf_MEAN_ENERGY_NEXT_WIN = vf_num_MEAN_F0
	pf_MEAN_STYLFIT_ENERGY_NEXT_WIN = num_MEAN_STYLFIT_F0
	vf_MEAN_STYLFIT_ENERGY_NEXT_WIN = vf_num_MEAN_STYLFIT_F0
	pf_FIRST_STYLFIT_ENERGY_NEXT_WIN = num_FIRST_F0
	vf_FIRST_STYLFIT_ENERGY_NEXT_WIN = vf_num_FIRST_F0
	pf_LAST_STYLFIT_ENERGY_NEXT_WIN = num_LAST_F0
	vf_LAST_STYLFIT_ENERGY_NEXT_WIN = vf_num_LAST_F0
	pf_ENERGY_PATTERN_WORD_NEXT_WIN$ = str_PATTERN_WORD$
	vf_ENERGY_PATTERN_WORD_NEXT_WIN = vf_str_PATTERN_WORD
	pf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT_WIN$ = str_PATTERN_WORD_COLLAPSED$
	vf_ENERGY_PATTERN_WORD_COLLAPSED_NEXT_WIN = vf_str_PATTERN_WORD_COLLAPSED
	pf_ENERGY_PATTERN_SLOPE_NEXT_WIN$ = str_PATTERN_SLOPE$
	vf_ENERGY_PATTERN_SLOPE_NEXT_WIN = vf_str_PATTERN_SLOPE

	endif

	# seems that Praat has bug with long string. The script exits unexpectedly after finishing the procedure which uses that long string as an input parameter to the procedure that it calls to.
	pattern_slope$ = pf_ENERGY_PATTERN_SLOPE$
	pattern_slope_next$ = pf_ENERGY_PATTERN_SLOPE_NEXT$
	if pf_ENERGY_PATTERN_WORD$ <> "" and pf_ENERGY_PATTERN_WORD_NEXT$ <> ""
	   call fetch_ENERGY_PATTERN_BOUNDARY 'pf_ENERGY_PATTERN_WORD$' 'pf_ENERGY_PATTERN_WORD_NEXT$'
	else
	   vf_ENERGY_PATTERN_BOUNDARY = 0
	endif

	if pf_ENERGY_PATTERN_SLOPE$ <> "" and pf_ENERGY_PATTERN_SLOPE_NEXT$ <> ""
	   pattern_slope$ = pf_ENERGY_PATTERN_SLOPE$
	   pattern_slope_next$ = pf_ENERGY_PATTERN_SLOPE_NEXT$
	   if length(pattern_slope$) > 100	      			   
		pattern_slope$ = right$(pattern_slope$, 100)
	   endif
	   if length(pattern_slope_next$) > 100
		pattern_slope_next$ = left$(pattern_slope_next$, 100)
	   endif
	   call fetch_ENERGY_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$'
	else
	   vf_ENERGY_SLOPE_DIFF = 0
	endif

endproc


procedure fetch_energy_feature_in_range start_time end_time
	if tk_DEBUG >= 5
		printline [proceed in fetch_f0_feature_in_range 'start_time' 'end_time']
	endif
	call fn_MIN_F0 'rawEnergyPitchTierID' 'start_time' 'end_time'
	num_MIN_F0 = num_result1
	vf_num_MIN_F0 = vf_num_result1
	call fn_MIN_F0 'stylEnergyPitchTierID' 'start_time' 'end_time'
	num_MIN_STYLFIT_F0 = num_result1
	vf_num_MIN_STYLFIT_F0 = vf_num_result1
	call fn_MAX_F0 'rawEnergyPitchTierID' 'start_time' 'end_time'
	num_MAX_F0 = num_result1
	vf_num_MAX_F0 = vf_num_result1
	call fn_MAX_F0 'stylEnergyPitchTierID' 'start_time' 'end_time'
	num_MAX_STYLFIT_F0 = num_result1
	vf_num_MAX_STYLFIT_F0 = vf_num_result1
	call fn_MEAN_F0 'rawEnergyPitchTierID' 'start_time' 'end_time'
	num_MEAN_F0 = num_result1
	vf_num_MEAN_F0 = vf_num_result1
	call fn_MEAN_F0 'stylEnergyPitchTierID' 'start_time' 'end_time'
	num_MEAN_STYLFIT_F0 = num_result1	
	vf_num_MEAN_STYLFIT_F0 = vf_num_result1
	call fn_FIRST_F0 'stylEnergyPitchTierID' 'start_time' 'end_time'
	num_FIRST_F0 = num_result1
	vf_num_FIRST_F0 = vf_num_result1
	call fn_LAST_F0 'stylEnergyPitchTierID' start_time end_time
	num_LAST_F0 = num_result1
	vf_num_LAST_F0 = vf_num_result1
	call fn_PATTERN_WORD 'slopeEnergyTextGridID' 'start_time' 'end_time'
	str_PATTERN_WORD$ = str_result1$
	vf_str_PATTERN_WORD = vf_str_result1
	call fn_PATTERN_WORD_COLLAPSED 'slopeEnergyTextGridID' 'start_time' 'end_time'
	str_PATTERN_WORD_COLLAPSED$ = str_result1$
	vf_str_PATTERN_WORD_COLLAPSED = vf_str_result1
	call fn_PATTERN_SLOPE 'slopeEnergyTextGridID' 'start_time' 'end_time'
	str_PATTERN_SLOPE$ = str_result1$
	vf_str_PATTERN_SLOPE = vf_str_result1
endproc        


procedure fetch_ENERGY_PATTERN_BOUNDARY pattern_word$ pattern_word_next$
	if tk_DEBUG >= 5
		printline [proceed in fetch_ENERGY_PATTERN_BOUNDARY 'pattern_word$' 'pattern_word_next$']
	endif
	call fn_PATTERN_BOUNDARY 'pattern_word$' 'pattern_word_next$'
	pf_ENERGY_PATTERN_BOUNDARY$ = str_result1$
	vf_ENERGY_PATTERN_BOUNDARY = vf_str_result1
endproc

procedure fetch_ENERGY_SLOPE_DIFF pattern_slope$ pattern_slope_next$
	if tk_DEBUG >= 5
		printline [proceed in fetch_ENERGY_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$']
	endif
	call fn_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$'
	pf_ENERGY_SLOPE_DIFF = num_result1
	vf_ENERGY_SLOPE_DIFF = vf_num_result1
endproc


procedure fetch_spkr_stats
	if tk_DEBUG >= 5
		printline [proceed in fetch_spkr_stats]
	endif
# TODO: NEED TO HANDLE THE CASE WHERE phone_mean and phone_stdev
# are not valid.
	select rhymeTextGridID
	interval_no = Get number of intervals... 1
	for i from 1 to interval_no
#		printline <processing interval_no  = 'i'>
		select rhymeTextGridID
		label$ = Get label of interval... 1 'i'
		if label$ <> ""
			start = Get starting point... 1 'i'
			end = Get end point... 1 'i'
			call compute_frame_num 'start' 'end'
			dur = num_result1
			call update_last_rhyme_table 'dur'
#			printline <call fn_find_intervals 'phoneTextGridID' 'start' 'end'>
			call fn_find_intervals 'phoneTextGridID' 'start' 'end'
			interval_start = num_result1
			interval_end = num_result2
			norm_dur = 0
#			printline <bad: from 'interval_start' ('start') to 'interval_end' ('end'))>
			for j from interval_start to interval_end
				select phoneTextGridID
				phone_label$ = Get label of interval... 1 'j'
				start = Get starting point... 1 'j'
				end = Get end point... 1 'j'
				if phone_label$ <> ""
				   dur = round((end - start) / gc_frame_size)
				   call update_last_rhyme_phone_table 'dur'
#				   printline <start 'phone_label$'>
				   call lookup_phone_table 'globalPhoneTableID' 'phone_label$' MEAN
#				   printline <end 'phone_label$'>
				   phone_mean = num_result1
				   call lookup_phone_table 'globalPhoneTableID' 'phone_label$' STDEV
				   phone_stdev = num_result1
				   norm_dur = norm_dur + (dur - phone_mean) / phone_stdev
				else
#			           printline <bad phones in rhyme: from 'interval_start' ('start') to 'interval_end' ('end'))>
				endif
			endfor
			call update_norm_last_rhyme_table 'norm_dur'
		endif
	endfor
	select wordTextGridID    
    	interval_no = Get number of intervals... 1	
	for i from 1 to interval_no		
		select wordTextGridID		
        	label$ = Get label of interval... 1 'i'
        	if label$ = ""
		start = Get starting point... 1 'i'
		end = Get end point... 1 'i'
		dur = round((end - start) / gc_frame_size)	
            	call update_pause_table 'dur'
		endif
    	endfor
endproc

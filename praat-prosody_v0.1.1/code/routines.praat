# routines.praat
#
# - create_word_table
# - init_wav
#
#
#
#----------------------------------------

procedure fn_WORD_PHONES_and_FLAG phoneTextGridID startingTime endTime
# return the phones in the WORD, with their durations (in frames). The
# format is: phone1:duration_phone2:duration_...
# and the flag indicating whether the word before the boundary has
# reliable phone durations
#
# str_result1$: contains the phones string together with the durations
# vf_str_result1: 1 if str_result1$ is valid, otherwise set it to 0
# str_result2$: contains the flag
# vf_str_result2: 1 if str_result2$ is valid, otherwise set it to 0
#
	if tk_DEBUG >= 6
		printline [proceed in fn_WORD_PHONES_and_FLAG 'phoneTextGridID' 'startingTime' 'endTime']
	endif
	call find_interval_range 'phoneTextGridID' 'startingTime' 'endTime'
	startingIndex = num_result1
	endIndex = num_result2
	str_result1$ = ""
	vf_str_result1 = 1
	str_result2$ = "0"
	vf_str_result2 = 1
	num_phone = 0
	for i from startingIndex to endIndex
		select phoneTextGridID
		label$ = Get label of interval... 1 'i'
		if label$ <> ""
			call get_interval_dur_in_frames 'phoneTextGridID' 'i'
			durFrame = num_result1
			if num_phone <> 0
				str_result1$ = str_result1$ + "_"
			endif
			str_result1$ = str_result1$ + label$ + ":" + fixed$(durFrame,0)
			call lookup_phone_table 'globalPhoneTableID' 'label$' THRESHOLD
			phone_threshold = num_result1
			if phone_threshold = -1
                vf_str_result2 = 0
            elsif durFrame > phone_threshold
				str_result2$ = "SUSP"
			endif
			num_phone = num_phone + 1
		endif
	endfor
	if num_phone = 0
	   vf_str_result1 = 0
	   vf_str_result2 = 0
    endif
endproc


procedure fn_MIN_F0 pitchTierID startingTime endTime
# compute the minimum f0 value in 'pitchTierID'
# within the range 'startingTime' and 'endTime'.
#
# num_result1: the minimum pitch f0 value
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
	if tk_DEBUG >= 6
		printline [proceed in fn_MIN_F0 'pitchTierID' 'startingTime' 'endTime']
	endif
	num_result1 = gc_pos_infinit
	vf_num_result1 = 1
	select 'pitchTierID'
	startingIndex = Get high index from time... 'startingTime'
	endIndex = Get low index from time... 'endTime'
	for i from startingIndex to endIndex
		curPitchValue = Get value at index... 'i'
		if curPitchValue < num_result1
			num_result1 = curPitchValue
		endif
	endfor
	if num_result1 = gc_pos_infinit
		vf_num_result1 = 0
	endif
endproc

procedure fn_MAX_F0 pitchTierID startingTime endTime
# compute the maximum f0 value in 'pitchTierID'
# within the range 'startingTime' and 'endTime'.
#
# num_result1: the maximum pitch f0 value
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
	if tk_DEBUG >= 6
		printline [proceed in fn_MAX_F0 'pitchTierID' 'startingTime' 'endTime']
	endif
	num_result1 = gc_neg_infinit
	vf_num_result1 = 1
	select 'pitchTierID'
	startingIndex = Get high index from time... 'startingTime'
	endIndex = Get low index from time... 'endTime'
	for i from startingIndex to endIndex
		curPitchValue = Get value at index... 'i'
		if curPitchValue > num_result1
			num_result1 = curPitchValue
		endif
	endfor
	if num_result1 = gc_neg_infinit
        vf_num_result1 = 0
	endif
endproc

procedure fn_MEAN_F0 pitchTierID startingTime endTime
# compute the mean f0 value in 'pitchTierID' 
# within the range 'startingTime' and 'endTime'.
#
# num_result1: the mean pitch f0 value
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
# 
	if tk_DEBUG >= 6
		printline [proceed in fn_MEAN_F0 'pitchTierID' 'startingTime' 'endTime']
	endif
	num_result1 = 0
	vf_num_result1 = 1
	select 'pitchTierID'
	startingIndex = Get high index from time... 'startingTime'
	endIndex = Get low index from time... 'endTime'
	for i from startingIndex to endIndex
		curPitchValue = Get value at index... 'i'
		num_result1 = num_result1 + curPitchValue
	endfor
	if startingIndex <= endIndex
		num_result1 = num_result1 / (endIndex - startingIndex + 1)
	endif
	if num_result1 = 0
		vf_num_result1 = 0
	endif
endproc

procedure fn_FIRST_F0 pitchTierID startingTime endTime
# num_result1: the first pitch value
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
	if tk_DEBUG >= 6
		printline [proceed in 'pitchTierID' 'startingTime' 'endTime']
	endif
	select pitchTierID
	startingIndex = Get high index from time... 'startingTime'
	endIndex = Get low index from time... 'endTime'
	if startingIndex <= endIndex
		num_result1 = Get value at index... 'startingIndex'
		vf_num_result1 = 1
	else
		num_result1 = -1
		vf_num_result1 = 0
	endif	
endproc

procedure fn_LAST_F0 pitchTierID startingTime endTime
# num_result1: the last pitch value
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
	if tk_DEBUG >= 6
		printline [proceed in fn_LAST_F0 'pitchTierID' 'startingTime' 'endTime']
	endif
	select pitchTierID
	startingIndex = Get high index from time... 'startingTime'
	endIndex = Get low index from time... 'endTime'
	if startingIndex <= endIndex
		num_result1 = Get value at index... 'endIndex'
		vf_num_result1 = 1
	else
		num_result1 = -1
		vf_num_result1 = 0
	endif	
endproc	
	
procedure fn_PATTERN_WORD _slopeTextGridID startingTime endTime
# compute the dynamic word pattern of the pitch values from 'startingTime'
# to 'endTime'. This feature is composed by a sequence of "f", "uv", and "r"
# representing a falling slope, an unvoiced section and a rising slope within
# the defined range. Sequences of less than gc_min_frame_length fs or rs or uvs
# in the stylized f0 file are skipped, and the longer sequeces are represented
# by just one f, r, or uv. Note that sequeces of f's or r's with difference
# slopes are represented with ff, or rr. 
#
# according to the SRI description, zero slope is skipped for this feature.
#
# str_result1$: containing the PATTERN_WORD
# vf_str_result1: 1 if str_result1$ is valid, otherwise set it to 0

#TODO
	if tk_DEBUG >= 6
		printline [proceed in fn_PATTERN_WORD '_slopeTextGridID' 'startingTime' 'endTime']
	endif
	str_result1$ = ""
	vf_str_result1 = 0
	select '_slopeTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	# assign the first pattern character(s)
	x1 = startingTime
	x2 = Get end point... 1 'startingIndex'
	if (x2 - x1) / gc_frame_size >= gc_min_frame_length
		label$ = Get label of interval... 1 'startingIndex'
		if label$ = ""
			str_result1$ = "U"
		else
			slope = 'label$'
			if slope > 0
				str_result1$ = "r"
			elsif slope < 0
				str_result1$ = "f"
			endif
		endif
	endif
	# compute the pattern string from the second interval to the
	# interval before the last one
	for i from startingIndex + 1 to endIndex - 1
		x1 = Get starting point... 1 'i'
		x2 = Get end point... 1 'i'
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'i'
			# look back 2 characters to determine whether 
			# consecutive f's or r's happened recently
			last_pattern$ = right$(str_result1$, 2)
			if label$ = ""
				if last_pattern$ <> "U"
					str_result1$ = str_result1$ + "U"
				endif
			else
				slope = 'label$'
				if slope > 0
					if last_pattern$ <> "rr"
						str_result1$ = str_result1$ + "r"
					endif
				elsif slope < 0
					if last_pattern$ <> "ff"
						str_result1$ = str_result1$ + "f"
					endif
				endif
			endif
		endif
	endfor
	# compute the last pattern character(s)
	if (startingIndex <> endIndex)
		x1 = Get starting point... 1 'endIndex'
		x2 = endTime
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'endIndex'
			last_pattern$ = right$(str_result1$, 2)
			if label$ = ""
				if last_pattern$ <> "U"
					str_result1$ = str_result1$ + "U"
				endif
			else
				slope = 'label$'
				if slope > 0
					if last_pattern$ <> "rr"
						str_result1$ = str_result1$ + "r"
					endif
				elsif slope < 0
					if last_pattern$ <> "ff"
						str_result1$ = str_result1$ + "f"
					endif
				endif
			endif
		endif		
	endif
	if str_result1$ <> ""
	    vf_str_result1 = 1
	endif
endproc

procedure fn_PATTERN_WORD_COLLAPSED _slopeTextGridID startingTime endTime
# compute the dynamic pattern of the pitch values from 'startingTime'
# to 'endTime'. This feature is similar to PATTERN_WORD, but consecutive
# f's and r's are combined into one f or r, consecutive f's (r's) represent
# consecutive falls (rises) with different slopes.
#
# according to the SRI description, zero slope is skipped for this feature.
#
# str_result1$: containing the PATTERN_WORD_COLLAPSED
# vf_str_result1: 1 if str_result1$ is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_PATTERN_WORD_COLLAPSED '_slopeTextGridID' 'startingTime' 'endTime']
    endif
	str_result1$ = ""
	vf_str_result1 = 0
	select '_slopeTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	# assign the first pattern character(s)
	x1 = startingTime
	x2 = Get end point... 1 'startingIndex'
	if (x2 - x1) / gc_frame_size >= gc_min_frame_length
		label$ = Get label of interval... 1 'startingIndex'
		if label$ = ""
			str_result1$ = "U"
		else
			slope = 'label$'
			if slope > 0
				str_result1$ = "r"
			elsif slope < 0
				str_result1$ = "f"
			endif
		endif
	endif
	# compute the pattern string from the second interval to the 
	# interval before the last one
	for i from startingIndex + 1 to endIndex - 1
		x1 = Get starting point... 1 'i'
		x2 = Get end point... 1 'i'
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'i'
			# look back 1 characters to avoid f's or
			# r's to happen
			last_pattern$ = right$(str_result1$, 1)
			if label$ = ""
				if last_pattern$ <> "v"
					str_result1$ = str_result1$ + "U"
				endif
			else
				slope = 'label$'
				if slope > 0
					if last_pattern$ <> "r"
						str_result1$ = str_result1$ + "r"
					endif
				elsif slope < 0
					if last_pattern$ <> "f"
						str_result1$ = str_result1$ + "f"
					endif
				endif
			endif
		endif
	endfor
	# compute the last pattern character(s)
	if (startingIndex <> endIndex)
		x1 = Get starting point... 1 'endIndex'
		x2 = endTime
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'endIndex'
			last_pattern$ = right$(str_result1$, 1)
			if label$ = ""
				if last_pattern$ <> "v"
					str_result1$ = str_result1$ + "U"
				endif
			else
				slope = 'label$'
				if slope > 0
					if last_pattern$ <> "r"
						str_result1$ = str_result1$ + "r"
					endif
				elsif slope < 0
					if last_pattern$ <> "f"
						str_result1$ = str_result1$ + "f"
					endif
				endif
			endif
		endif
	endif
	if str_result1$ <> ""
        vf_str_result1  = 1
    endif
endproc

procedure fn_PATTERN_SLOPE _slopeTextGridID startingTime endTime
# compute the dynamic slope pattern of the pitch values from 'startingTime'
# to 'endTime'. This feature is similar to PATTERN_WORD, but instead of f
# and r's a sequence of slopes is listed, and these slope sequeces that 
# have length less than gc_min_frame_length are excluded.
#
# according to the SRI description, zero slope is skipped for this feature.
# Question: what's the corresponding process to "ff" and "rr"?
#
# str_result1$: containing the PATTERN_SLOPE feature, the slopes are seperated by ';'
# vf_str_result1: 1 if str_result1$ is valid, otherwise set it to 0
#
#	first_slope controls whether to add ';' before the slope
    if tk_DEBUG >= 6
        printline [proceed in fn_PATTERN_SLOPE '_slopeTextGridID' 'startingTime' 'endTime']
    endif
	first_slope = 1
	str_result1$ = ""
	vf_str_result1 = 0
	select '_slopeTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	# assign the first pattern character(s)
	x1 = startingTime
	x2 = Get end point... 1 'startingIndex'
	if (x2 - x1) / gc_frame_size >= gc_min_frame_length
		label$ = Get label of interval... 1 'startingIndex'
		if label$ = ""
			str_result1$ = "U"
			first_slope = 0
		else 
			slope = 'label$'
			if slope <> 0
				str_result1$ = label$
				first_slope = 0
			endif
		endif
	endif
	# compute the pattern string from the second interval to the 
	# interval before the last one
	for i from startingIndex + 1 to endIndex - 1
		x1 = Get starting point... 1 'i'
		x2 = Get end point... 1 'i'
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'i'
			# look back 2 characters to determine whether
			# consecutive f's or r's happened recently
			last_pattern$ = right$(str_result1$, 2)
			if label$ = ""
				if last_pattern$ <> "U"
					if first_slope <> 1
						str_result1$ = str_result1$ + ";"
				   endif
					str_result1$ = str_result1$ + "U"
					first_slope = 0
				endif
			else
				slope = 'label$'
				if slope <> 0
					if first_slope <> 1
						str_result1$ = str_result1$ + ";"
				   endif
					str_result1$ = str_result1$ + label$
					first_slope = 0
				endif
			endif
		endif
	endfor
	# compute the last pattern character(s)
	if (startingIndex <> endIndex)
		x1 = Get starting point... 1 'endIndex'
		x2 = endTime
		if (x2 - x1) / gc_frame_size >= gc_min_frame_length
			label$ = Get label of interval... 1 'endIndex'
			last_pattern$ = right$(str_result1$, 2)
			if label$ = ""
				if last_pattern$ <> "U"
					if first_slope <> 1
						str_result1$ = str_result1$ + ";"
				   endif
					str_result1$ = str_result1$ + "U"
					first_slope = 0
				endif
			else
				slope = 'label$'
				if slope <> 0
					if first_slope <> 1
						str_result1$ = str_result1$ + ";"
				   endif
					str_result1$ = str_result1$ + label$
					first_slope = 0
				endif
			endif
		endif
	endif
	if str_result1$ <> ""
		vf_str_result1 = 1
	endif
endproc

procedure fn_NO_PREVIOUS_SSF _slopeTextGridID startingTime endTime
# return in num_result1 the number of previous consecutive frames
# inside the waveform which have the same slope as last voiced frame
# within the range from 'startingTime' to 'endTime' (voiced sequences 
# of less than gc_min_frame_length are not considered, just discard
# them and consider the sequences before them)
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_PREVIOUS_SSF '_slopeTextGridID' 'startingTime' 'endTime']
    endif
	select '_slopeTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = endIndex + 1
	repeat
		i = i - 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = startingIndex or (label$ <> "" and nFrames >= gc_min_frame_length)
	if i = startingIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		num_result1 = nFrames
		vf_num_result1 = 1
	endif
endproc

procedure fn_NO_PREVIOUS_VF vuvTextGridID startingTime endTime
# return in num_result1 the number of consecutive "voiced" frames inside the
# waveform from the last voice frame within the range from 'startingTime' to
# 'endTime' backward (voiced sequences of less than gc_min_frame_length are 
# not considered)
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_PREVIOUS_VF 'vuvTextGridID' 'startingTime' 'endTime']
    endif
	select 'vuvTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = endIndex + 1
	repeat
		i = i - 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = startingIndex or (nFrames >= gc_min_frame_length and label$ = "V")
	if i = startingIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		num_result1 = nFrames
		vf_num_result1 = 1
	endif
endproc

procedure fn_NO_FRAMES_LS_WE vuvTextGridID startingTime endTime
# return in num_result1 the number of consecutive frames between the last
# voiced frame which belongs to a sequence of voiced frames larger than
# gc_min_frame_length within the range from 'startingTime' to 'endTime' and 
# 'endTime'
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_FRAMES_LS_WE 'vuvTextGridID' 'startingTime' 'endTime']
    endif
	select 'vuvTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = endIndex + 1
	repeat
		i = i - 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = startingIndex or (nFrames >= gc_min_frame_length and label$ = "V")
	if i = startingIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		durTime = endTime - x2
		num_result1 = round(durTime / gc_frame_size)
		vf_num_result1 = 1
	endif
endproc

procedure fn_NO_SUCCESSOR_SSF _slopeTextGridID startingTime endTime
# return in num_result1 the number of successor consecutive frames
# inside the waveform which have the same slope as the first voiced frame
# within the range from 'startingTime' to 'endTime' and 'endTime' (voiced
# sequences of less than gc_min_frame_length are not considered)
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_SUCCESSOR_SSF '_slopeTextGridID' 'startingTime' 'endTime']
    endif
	select '_slopeTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = startingIndex - 1
	repeat
		i = i + 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = endIndex or (label$ <> "" and nFrames >= gc_min_frame_length)
	if i = endIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		num_result1 = nFrames
		vf_num_result1 = 1
	endif
endproc

procedure fn_NO_SUCCESSOR_VF vuvTextGridID startingTime endTime
# return in num_result1 the number of consecutive "voiced" frames inside the
# waveform from the first voice frame within the range from 'startingTime' to
# 'endTime' and 'endTime' forward (voiced sequences of less than 
# gc_min_frame_length are not considered)
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_SUCCESSOR_VF 'vuvTextGridID' 'startingTime' 'endTime']
    endif
	select 'vuvTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = startingIndex - 1
	repeat
		i = i + 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = endIndex or (nFrames >= gc_min_frame_length and label$ = "V")
	if i = endIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		num_result1 = nFrames
		vf_num_result1 = 1
	endif
endproc

procedure fn_NO_FRAMES_WS_FS vuvTextGridID startingTime endTime
# return in num_result1 the number of consecutive frames between the last
# voiced frame which belongs to a sequence of voiced frames larger than
# gc_min_frame_length within the range from 'startingTime' to 'endTime' and
# 'endTime'
#
# num_result1: return the number
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_NO_FRAMES_WS_FS 'vuvTextGridID' 'startingTime' 'endTime']
    endif
	select 'vuvTextGridID'
	startingIndex = Get interval at time... 1 'startingTime'
	endIndex = Get interval at time... 1 'endTime'
	i = startingIndex - 1
	repeat
		i = i + 1
		x1 = Get starting point... 1 'i'
		if x1 < startingTime
			x1 = startingTime
		endif
		x2 = Get end point... 1 'i'
		if x2 > endTime
			x2 = endTime
		endif
		nFrames = round((x2 - x1) / gc_frame_size)
		label$ = Get label of interval... 1 'i'
	until i = endIndex or (nFrames >= gc_min_frame_length and label$ = "V")
	if i = endIndex
		num_result1 = 0
		vf_num_result1 = 0
	else
		durTime = x1 - startingTime
		num_result1 = round(durTime / gc_frame_size)
		vf_num_result1 = 1
	endif
endproc

procedure fn_PATTERN_BOUNDARY pattern_word$ pattern_word_next$
# return in 'str_result1$' the last f or r in the 'pattern_word$'
# concatenated with the first f or r in the 'pattern_word_next$'.
# if there is not a f or r pattern in one of the two places, return
# a blank string 'str_result1$'
#
# str_result1$: value of the PATTERN_BOUNDARY
# vf_str_result1: 1 if str_result1 is valid, otherwise set it to 0
#
	if tk_DEBUG >= 6
        printline [proceed in fn_PATTERN_BOUNDARY 'pattern_word$' 'pattern_word_next$']
    endif
	str_result1$ = ""
	vf_str_result1 = 0
	left_pattern$ = "U"
	index = length(pattern_word$)
	if index > 0
		repeat
			left_pattern$ = mid$(pattern_word$, index, 1)
			index = index - 1
		until index < 1 or left_pattern$ <> "U"
	endif
	if left_pattern$ <> "U"
		right_pattern$ = "U"
		len = length(pattern_word_next$)
		index = 1
		if len > 0
			repeat
				right_pattern$ = mid$(pattern_word_next$, index, 1)
				index = index + 1
			until index > len or right_pattern$ <> "U"
		endif
		if right_pattern$ <> "U"
			str_result1$ = left_pattern$ + right_pattern$
			vf_str_result1 = 1
		endif
	endif
endproc

procedure fn_SLOPE_DIFF pattern_slope$ pattern_slope_next$
# return in 'str_result1$' the difference between the last 
# non_zero (longer than gc_min_frame_length) slope of the word
# and the first non_zero (longer than # gc_min_frame_length) 
# slope of the next word. If one of the words do not have a
# non-zero slope which occurred more than gc_min_frame_length 
# times ,then this feature has a value "X".
#
# num_result1: the difference of slopes
# vf_num_result1: 1 if num_result1 is valid, otherwise set it to 0
#
    if tk_DEBUG >= 6
        printline [proceed in fn_SLOPE_DIFF 'pattern_slope$' 'pattern_slope_next$']
    endif
    num_result1 = 0
    vf_num_result1 = 0
	left_pattern$ = pattern_slope$
	len = length(left_pattern$)
	find_slope = 0
	if left_pattern$ <> ""
		repeat
			index = rindex(left_pattern$, ";")
			pattern$ = right$(left_pattern$, len - index)
			if pattern$ <> "U"
			   	left_slope = 'pattern$'
				find_slope = 1
			else
			    if index = 0
			        len = 0
			    else
			        left_pattern$ = left$(left_pattern$, index - 1)
			        len = index - 1
			    endif
			endif
		until len = 0 or find_slope = 1
	endif
	if find_slope = 1
		right_pattern$ = pattern_slope_next$
		len = length(right_pattern$)
		find_slope = 0
		if right_pattern$ <> ""
			repeat
				index = index(right_pattern$, ";")
				if index = 0
					pattern$ = right_pattern$
				else
					pattern$ = left$(right_pattern$, index - 1)
				endif
				if pattern$ <> "U"
					right_slope = 'pattern$'
					find_slope = 1
				else
				    if index = 0
				        len = 0
				    else
				        right_pattern$ = right$(right_pattern$, len - index)
				        len = len - index
				    endif
			    endif
			until len = 0 or find_slope = 1
		endif
		if find_slope = 1
			num_result1 = left_slope - right_slope
			vf_num_result1 = 1
		endif
	endif
endproc

procedure queryCrspdInters srcTextGridID srcInterInd trgTextGridID
# find the interval indices in the trgTextGrid within the boundaries defined
# by the starting and end time of the interval srcInterInd in srcTextGrid.
#
# return values:
# num_result1: the index of the first interval with a valid label within the range
# num_result2: the index of the last interval with a valid label within the range
#
    if tk_DEBUG >= 6
        printline [proceed in queryCrspdInters 'srcTextGridID' 'srcInterInd' 'trgTextGridID']
    endif
	select 'srcTextGridID'
	x1 = Get starting point... 1 'srcInterInd'
	x2 = Get end point... 1 'srcInterInd'
	# eliminate the tiny difference between the bourndaries of these two TextGrids
	x1 = x1 + 0.0001
	x2 = x2 - 0.0001
	select 'trgTextGridID'
	num_result1 = Get interval at time... 1 'x1'
	num_result2 = Get interval at time... 1 'x2'
	label1$ = Get label of interval... 1 'num_result1'
	while label1$ = ""
		num_result1 = num_result1 + 1
		label1$ = Get label of interval... 1 'num_result1'
	endwhile
	# test in case there is no labeled interval in the 'trgTextGrid', there should be an error in 'trgTextGrid'
	if num_result1 > num_result2
		exit There is no labeled interval in the object 'trgTextGrid', there should be an error in object 'trgTextGrid'.
	endif
	label2$ = Get label of interval... 1 'num_result2'
	while label2$ = ""
		num_result2 = num_result2 - 1
		label2$ = Get label of interval... 1 'num_result2'
	endwhile
endproc


#---------------------------------------
# code by Lei
# fn_Check_Last is used to find the last vowel, rhyme
# of a word or any window region
#
# return the GV gv_CHECKED_ID
# ( the interval no. of last vowel, rhyme, vuv, etc)
# if there has no interested element.
# return -1
#
# As for Get interval at time...
# for a word with t0 start and t1 as end
# using t0 as argument, we can get the interval indexed to this word
# if using t1 as argument, we will get the interval next to the word
# therefore, we will add small offset (epslon) on t1 so that we can
# get the interval index of the current word.
#
# CAUTION: repeat in Praat script
# after exiting from until, it has minus one more.
# we have to recover the value by adding 1
#
# by Lei 06/25/2005
#
# modified by Zhongqiang 06/29/2005
#procedure fn_Check_Last start end obj$
#	select TextGrid 'obj$'


#TODO
procedure fn_Check_Last objID start end
    if tk_DEBUG >= 6
        printline [proceed in fn_Check_Last objID start end]
    endif	
	select objID
	epslon = 0.001
	start = start + epslon
	end   = end   - epslon
	id0 = Get interval at time... 1 'start'
	id1 = Get interval at time... 1 'end'
	ii = id1
	repeat
 		label$ = Get label of interval... 1 'ii'
 		ii = ii - 1
	until label$ <> ""
 	ii = ii + 1
	if ii < id0
 		gv_CHECKED_ID = -1
	else
 		gv_CHECKED_ID = ii
	endif
endproc


procedure fn_find_intervals objectID start end
	if tk_DEBUG >= 6
		printline [proceed in fn_find_intervals 'objectID' 'start' 'end']
	endif
	select objectID
    	start = start + gc_epslon
	end = end - gc_epslon
	num_result1 = Get interval at time... 1 'start'
	num_result2 = Get interval at time... 1 'end'
#	printline <in_fn_find_intervals: 'num_result1'('start') to 'num_result2'('end') >	
endproc


#------------------------------------------
# code by Zhongqiang
# 06/30/2005
#
procedure gen_dur_files
# generate the vowel and rhyme TextGrid files based on the
# word and phone TextGrids
# word and phone TextGrids are already prepared in
# object 'wordTextGridID' and 'phoneTextGridID'
#
	if tk_DEBUG >= 6
		printline [proceed in gen_dur_files]
	endif
	select wordTextGridID
	wordStartingTime = Get starting time
	wordFinishingTime = Get finishing time
	wordIntervalNO = Get number of intervals... 1
	Create TextGrid... 'wordStartingTime' 'wordFinishingTime' vowel
	vowelTextGridID = selected("TextGrid", -1)
	Create TextGrid... 'wordStartingTime' 'wordFinishingTime' rhyme
	rhymeTextGridID = selected("TextGrid", -1)
	for i from 1 to wordIntervalNO
		select 'wordTextGridID'
		label$ = Get label of interval... 1 'i'
		wordStartingTime = Get starting point... 1 'i'
		wordFinishingTime = Get end point... 1 'i'
		if label$ <> ""
			call find_interval_range 'phoneTextGridID' 'wordStartingTime' 'wordFinishingTime'
			startingInd = num_result1
			endInd = num_result2
			lastVowelStartingTime = -1
			for j from startingInd to endInd
				select 'phoneTextGridID'
				startingTime = Get starting point... 1 'j'
				endTime = Get end point... 1 'j'
				label$ = Get label of interval... 1 'j'
				call isVowel 'label$'
				isVowel = num_result1
				if isVowel = 1
					call insertTextGridInterval 'vowelTextGridID' 'startingTime' 'endTime' vowel
					lastVowelStartingTime = startingTime
				endif
			endfor
			if lastVowelStartingTime <> -1
				call insertTextGridInterval 'rhymeTextGridID' 'lastVowelStartingTime' 'wordFinishingTime' rhyme
			endif
		endif
	endfor
endproc

procedure isVowel label$
# if 'label$' is a vowel in the ISIP lexicon, result1 = 1, else result1 = 0
#
    if tk_DEBUG >= 6
		printline [proceed in isVowel 'label$']
	endif
	num_result1 = 0
    len = length (label$)
	if (len > 1)
		first$ = left$(label$, 2)
		if (index ("~AA~AE~AH~AO~AW~AX~AXR~AY~EH~ER~EY~IH~IX~IY~OW~OY~UH~UW", first$) > 0)
			num_result1 = 1
		endif
	endif
endproc

procedure insertTextGridInterval textGridID startingTime endTime label$
# insert a new interval in the first tier of TextGrid 'textGridID'.
# the starting time of the new interval is 'startingTime
# the end time of the new interval is 'endTime'
# the lable of the new interval is 'label'
#
    if tk_DEBUG >= 6
		printline [proceed in insertTextGridInterval 'textGridID' 'startingTime' 'endTime' 'label$']
	endif
	select 'textGridID'
	# check whether the boundary 'startingTime' exists
	x1 = startingTime - 0.0001
	x2 = startingTime + 0.0001
	inter1 = Get interval at time... 1 'x1'
	inter2 = Get interval at time... 1 'x2'
	if inter1 = inter2
		# if startingTime is not located at a existing boundary, then intert a boundary at startingTime
		if startingTime <> 0
		   Insert boundary... 1 'startingTime'
		endif
	endif
	if endTime <> gv_finishing_time
	   Insert boundary... 1 'endTime'
	endif
	midTime = (startingTime + endTime) / 2
	intervalID = Get interval at time... 1 'midTime'
	Set interval text... 1 'intervalID' 'label$'
endproc

procedure gen_pitch_files
# extract the pitch information from the waveform
# the resulting objects are:
# rawPitchTier
# stylPitchTier
# slopeTextGrid
# vuvTextGrid
#
	if tk_DEBUG >= 6
		printline [proceed in gen_pitch_files]
	endif
	if (gv_use_existing_param_files = gc_TRUE and fileReadable(gv_wav_pitch$))
		Read from file... 'gv_wav_pitch$'
		pitchID = selected("Pitch", -1)
		wavStartingTime = Get starting time
		wavFinishingTime = Get finishing time
	else
		Read from file... 'gv_spkr_wav$'
		wavSoundID = selected("Sound", -1)
		wavStartingTime = Get starting time
		wavFinishingTime = Get finishing time
		if pf_GEN$ = "male"
			To Pitch... 0.01 75.0 300.0
		elsif pf_GEN$ = "female"
			To Pitch... 0.01 100. 600.0
		elsif pf_GEN$ = "unknown"
		        To Pitch... 0.01 75.0 600.0			
		else
			exit The gender value 'pf_GEN$' is not supported
		endif
		pitchID = selected("Pitch", -1)
		Smooth... 10.0
		Write to text file... 'gv_wav_pitch$'
		select 'wavSoundID'
		Remove
	endif
	select 'pitchID'
    pitchTimeStep = Get time step
	Down to PitchTier
	rawPitchTierID = selected("PitchTier", -1)
 	select 'pitchID'
	To PointProcess
	pointProcessID = selected("PointProcess", -1)
	To TextGrid (vuv)... 0.02 0.01
	vuvTextGridID = selected("TextGrid", -1)
	vuvIntervalNo = Get number of intervals... 1

	select 'pointProcessID'
	plus 'pitchID'
	Remove
	Create TextGrid... 'wavStartingTime' 'wavFinishingTime' "slope(HZ/s)"
	slopeTextGridID = selected("TextGrid", -1)
	Create PitchTier... "stylPitchTier" 'wavStartingTime' 'wavFinishingTime'
	stylPitchTierID = selected("PitchTier", -1)

	for i from 1 to vuvIntervalNo
		select 'vuvTextGridID'
		label$ = Get label of interval... 1 'i'
		if (label$ = "V")
			segStartingTime = Get starting point... 1 'i'
			segEndTime = Get end point... 1 'i'
			select 'rawPitchTierID'
			segStartingPoint = Get high index from time... 'segStartingTime'
			segEndPoint = Get low index from time... 'segEndTime'
			Create PitchTier... "segPitchTier" 'wavStartingTime' 'wavFinishingTime'
			segPitchTierID = selected ("PitchTier", -1)
			for k from segStartingPoint to segEndPoint
				select 'rawPitchTierID'
				segPointTime = Get time from index... 'k'
				segPointValue = Get value at index... 'k'
				select 'segPitchTierID'
				Add point... segPointTime segPointValue
			endfor
			select 'segPitchTierID'
			Stylize... 4.0 Semitones
            segStylPointNo = Get number of points
			for j from 1 to segStylPointNo
				select 'segPitchTierID'
                segPointTime = Get time from index... 'j'
				segPointValue = Get value at index... 'j'
				if j = 1
					select 'stylPitchTierID'
					Add point... segPointTime segPointValue
					select 'slopeTextGridID'
					Insert boundary... 1 segPointTime
				else
					segSlope = (segPointValue - lastSegPointValue) / (segPointTime - lastSegPointTime)
					select 'slopeTextGridID'
                    Insert boundary... 1 segPointTime
					segMidTime = (segPointTime + lastSegPointTime) / 2
                    slopeInterval = Get interval at time... 1 'segMidTime'
					Set interval text... 1 slopeInterval 'segSlope'

					select 'stylPitchTierID'
                    stylPointNo = round((segPointTime - lastSegPointTime) / pitchTimeStep)
					for k from 1 to stylPointNo
						stylPointTime = lastSegPointTime + k * pitchTimeStep
                        stylPointValue = lastSegPointValue + k * pitchTimeStep * segSlope
						Add point... stylPointTime stylPointValue
					endfor
				endif
                lastSegPointTime = segPointTime
				lastSegPointValue = segPointValue
			endfor
			select 'segPitchTierID'
			Remove
		endif
	endfor
endproc

procedure gen_energy_files
# extract the energy information from the waveform
# IntensityTier is converted to PitchTier, and the 
# resulting objects are:
# rawEnergyPitchTier
# styEnergylPitchTier
#
	if tk_DEBUG >= 6
		printline [proceed in gen_energy_files]
	endif
	if (gv_use_existing_param_files = gc_TRUE and fileReadable(gv_wav_energy$))
		Read from file... 'gv_wav_energy$'
		intensityID = selected("Intensity", -1)
		wavStartingTime = Get starting time
		wavFinishingTime = Get finishing time
	else
		Read from file... 'gv_spkr_wav$'
		wavSoundID = selected("Sound", -1)
		wavStartingTime = Get starting time
		wavFinishingTime = Get finishing time
		To Intensity... 75.0 0.0
		intensityID = selected("Intensity", -1)
		Write to text file... 'gv_wav_energy$'
		select 'wavSoundID'
		Remove
	endif
	select 'intensityID'
    	intensityTimeStep = Get time step
	pointNo = Get number of frames
	Create TextGrid... 'wavStartingTime' 'wavFinishingTime' "slope(dB/s)"
	slopeEnergyTextGridID = selected("TextGrid", -1)
    Create PitchTier... "rawEnergyPitchTier" 'wavStartingTime' 'wavFinishingTime'
    rawEnergyPitchTierID = selected("PitchTier", -1)
    Create PitchTier... "stylEnergyPitchTier" 'wavStartingTime' 'wavFinishingTime'
    stylEnergyPitchTierID = selected("PitchTier", -1)	
    for i from 1 to pointNo
        select 'intensityID'
        intensityTime = Get time from frame number... 'i'
        intensityValue = Get value in frame... 'i'
	if intensityValue < 1.5
	   intensityValue = 1.5
	endif
        select 'rawEnergyPitchTierID'
        Add point... intensityTime intensityValue
    endfor
    select 'intensityID'
    Remove
    select 'rawEnergyPitchTierID'
    Copy... 'tempStylEnergyPitchTier'
    tempStylEnergyPitchTierID = selected("PitchTier", -1)
    Stylize... 3.0 Hz
    stylpointNo = Get number of points
    for j from 1 to stylpointNo
		select 'tempStylEnergyPitchTierID'
        stylPointTime = Get time from index... 'j'
        stylPointValue = Get value at index... 'j'
        if j <> 1
            stylSlope = (stylPointValue - lastStylPointValue) / (stylPointTime - lastStylPointTime)
	    select 'slopeEnergyTextGridID'
            Insert boundary... 1 stylPointTime
			segMidTime = (stylPointTime + lastStylPointTime) / 2
            slopeInterval = Get interval at time... 1 'segMidTime'
			Set interval text... 1 slopeInterval 'stylSlope'
			select 'stylEnergyPitchTierID'
			stylInterpointNo = round((stylPointTime - lastStylPointTime) / intensityTimeStep)
            for k from 1 to stylInterpointNo
                stylInterPointTime = lastStylPointTime + k * intensityTimeStep
                stylInterPointValue = lastStylPointValue + k * intensityTimeStep * stylSlope
                Add point... stylInterPointTime stylInterPointValue
            endfor
		else 
			select 'stylEnergyPitchTierID'
			Add point... stylPointTime stylPointValue
			select 'slopeEnergyTextGridID'
			Insert boundary... 1 stylPointTime
        endif     
        lastStylPointTime = stylPointTime
        lastStylPointValue = stylPointValue
    endfor
	select 'tempStylEnergyPitchTierID'
	Remove
endproc

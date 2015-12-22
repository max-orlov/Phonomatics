# util.praat
# utility procedures to faciliate
# other operations
#
# included procedures
#
# - check_system
# - fname_parts
# - compute_stats
# - make_dir
# - remove_dir
# - find_interval_range
# - find_last_interval
# - compute_frame_num
# - get_interval_dur_in_frames


procedure check_system pathname$
	if tk_DEBUG >= 6
		printline [proceed in check_system 'pathname$']
	endif
	pos_ = rindex(pathname$, "/")
	if (pos_ > 0)
		gv_system_type$ = "linux"
		gv_path_delimit$ = "/"
	else
		gv_system_type$ = "windows"
		gv_path_delimit$ = "\"
	endif
endproc

###
#TODO
# COPYRIGHT
procedure fname_parts s_$
# This procedure is taken from the praat script of 'prosogram' publicly available 
# online for free download
# Obtain filename parts
# s_$		the total filename
# str_result1$	the filename without path
# str_result2$	the basename (i.e. no path, no extension)
# str_result3$	the filename extension (excluding dot)
# str_result4$	the file path (excluding trailing slash) including drive
# str_result5$	the file path (excluding trailing slash) excluding drive
# str_result6$	the drive (excluding separator ':' )
	if tk_DEBUG >= 6
		printline [proceed in fname_parts 's_$']
	endif
	str_result1$ = s_$
 	str_result2$ = ""
	str_result3$ = ""
	str_result4$ = ""
	str_result5$ = ""
	str_result6$ = ""
	pos_ = rindex (s_$, "\")
 	if (pos_ = 0)
		pos_ = rindex (s_$, "/")
   	endif
#printline fname parts s_$ 's_$' pos 'pos_'
	if (pos_ > 0)
		str_result4$ = mid$ (s_$, 1, pos_ -1)
		len_ = length (s_$) - pos_
		str_result1$ = mid$ (s_$, pos_ + 1, len_)
	endif
	pos_ = rindex (str_result1$, ".")
	if (pos_ > 0)
		len_ = length (str_result1$)
		str_result3$ = right$ (str_result1$, len_ - pos_)
		str_result2$ = left$ (str_result1$, pos_ - 1)
	else
		str_result2$ = str_result1$
	endif
	pos_ = index (str_result4$, ":")
	if (pos_ = 2)
		len_ = length (str_result4$)
		str_result5$ = right$ (str_result4$, len_ - pos_)
		str_result6$ = left$ (str_result4$, pos_ - 1)
	else
		str_result5$ = str_result4$
	endif
endproc


procedure compute_stats mean_sum square_sum no_count
# compute the mean and stdev based on the accumerating
# variables: mean_sum, square_sum, and no_count
# return values:
#  num_result1: mean
#  num_result2: stdev
	if tk_DEBUG >= 6
 		printline [proceed in compute_stats 'mean_sum' 'square_sum' 'no_count']
 	endif
	if 	no_count < gc_min_spkr_sample
		num_result1 = -1
		num_result2 = -1
	else
        num_result1 = mean_sum / no_count
        num_result2 = sqrt((square_sum - no_count * num_result1 * num_result1) / (no_count - 1))
    endif
endproc

procedure make_dir dir_name$
	if tk_DEBUG >= 6
		printline [proceed in make_dir 'dir_name$']
	endif
	if gv_system_type$ = "windows"
		cmd_$ = "mkdir 'dir_name$'"
	else
		cmd_$ = "mkdir -p 'dir_name$'"
	endif
    system 'cmd_$'
endproc

procedure remove_dir dir_name$
    if tk_DEBUG >= 6
		printline [proceed in remove_dir 'dir_name$']
	endif
	if gv_system_type$ = "windows"
		cmd_$ = "rmdir /S /Q 'dir_name$'"
	else
		cmd_$ = "rm -rf 'dir_name$'"
	endif
	system 'cmd_$'
endproc


procedure find_interval_range textGridID startingTime endTime
# return the startingInterval and endInterval for the time range
# startingTime - endTime in textGridID
#
# return value:
# num_result1: startingInterval
# num_result2: endInterval
	if tk_DEBUG >= 6
		printline [proceed in find_interval_range 'textGridID' 'startingTime' 'endTime']
	endif
	x1 = startingTime + gc_epslon
	x2 = endTime - gc_epslon
	select 'textGridID'
	num_result1 = Get interval at time... 1 'x1'
	num_result2 = Get interval at time... 1 'x2'
endproc

procedure find_last_interval textGridID startingTime endTime
# return the index of the last valid interval in textGridID
# given the range from startingTime to endTime
	if tk_DEBUG >= 6
		printline [proceed in find_last_interval 'textGridID' 'startingTime' 'endTime']
	endif
	call find_interval_range 'textGridID' 'startingTime' 'endTime'
	startingInterval = num_result1
	endInterval = num_result2
	select 'textGridID'
	intervalIndex = endInterval + 1
	label$ = ""
	while intervalIndex > startingInterval and label$ = ""
		intervalIndex = intervalIndex - 1
		label$ = Get label of interval... 1 'intervalIndex'
	endwhile
	if label$ = ""
		num_result1 = -1
	else
		num_result1 = intervalIndex
	endif
endproc

procedure compute_frame_num startingTime endTime
# return in num_result1 the number of frames for
# the time range from startingTime to endTime
	if tk_DEBUG >= 6
		printline [proceed in compute_frame_num 'startingTime endTime']
	endif
	num_result1 = round((endTime - startingTime) / gc_frame_size)
endproc

procedure get_interval_dur_in_frames textGridID intervalIndex
# return in num_result1 the number of frames in the intervalIndex'th
# interval in textGridID
	if tk_DEBUG >= 6
		printline [proceed in get_interval_dur_in_frames 'textGridID' 'intervalIndex']
	endif
	select textGridID
	x1 = Get starting point... 1 'intervalIndex'
	x2 = Get end point... 1 'intervalIndex'
	dur = round((x2 - x1) / gc_frame_size)
	num_result1 = dur
endproc





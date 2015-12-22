# stats.praat
#
# routines to compute stats
# - accum_spkr_feat_stats
# - accum_spkr_phone_stats
#

include routines.praat
include table.praat
include config.praat

procedure accum_spkr_feat_stats
	if tk_DEBUG > -1
		printline [proceed accum_spkr_feat_stats]
	endif
	select rawPitchTierID
	point_no = Get number of points
	for i from 1 to point_no
		select rawPitchTierID
		pitch_value = Get value at index... 'i'
		log_pitch_value = ln(pitch_value)
		call update_spkr_feat_table PITCH 'log_pitch_value'
	endfor

	select rawEnergyPitchTierID
	point_no = Get number of points
	for i from 1 to point_no
		select rawEnergyPitchTierID
		energy_value = Get value at index... 'i'
		log_energy_value = ln(energy_value)
		call update_spkr_feat_table ENERGY 'log_energy_value'
	endfor

	select wordTextGridID
	word_interval_no = Get number of intervals... 1
	for word_i from 1 to word_interval_no
		select wordTextGridID
		label$ = Get label of interval... 1 'word_i'
		if label$ <> ""
			word_start = Get starting point... 1 'word_i'
			word_end = Get end point... 1 'word_i'

			call find_interval_range 'slopeTextGridID' 'word_start' 'word_end'
			startingInd = num_result1
			endInd = num_result2
			for int_j from startingInd to endInd
				select slopeTextGridID
				label$ = Get label of interval... 1 'int_j'
				if label$ <> ""
					interval_start = Get starting point... 1 'int_j'
					interval_end = Get end point... 1 'int_j'
					if interval_start < word_start
						interval_start = word_start
					endif
					if interval_end > word_end
						interval_end = word_end
					endif
					if (interval_end - interval_start) / gc_frame_size >= gc_min_frame_length
						slope = 'label$'
						call update_spkr_feat_table SLOPE 'slope'
					endif	
				endif
			endfor

			
			call find_interval_range 'slopeEnergyTextGridID' 'word_start' 'word_end'
			startingInd = num_result1
			endInd = num_result2
			for int_j from startingInd to endInd
				select slopeEnergyTextGridID
				label$ = Get label of interval... 1 'int_j'
				if label$ <> ""
					interval_start = Get starting point... 1 'int_j'
					interval_end = Get end point... 1 'int_j'
					if interval_start < word_start
						interval_start = word_start
					endif
					if interval_end > word_end
						interval_end = word_end
					endif
					if (interval_end - interval_start) / gc_frame_size >= gc_min_frame_length
						slope = 'label$'
						call update_spkr_feat_table ENERGY_SLOPE 'slope'
					endif	
				endif
			endfor

			call find_interval_range 'vuvTextGridID' 'word_start' 'word_end'
			startingInd = num_result1
			endInd = num_result2
			for int_j from startingInd to endInd
				select vuvTextGridID
				interval_start = Get starting point... 1 'int_j'
				interval_end = Get end point... 1 'int_j'
				if interval_start < word_start
					interval_start = word_start
				endif
				if interval_end > word_end
					interval_end = word_end
				endif
				dur = round((interval_end - interval_start) / gc_frame_size)

				if dur >= gc_min_frame_length
					label$ = Get label of interval... 1 'int_j'
					if label$ = "U"
						call update_spkr_feat_table UNVOICED 'dur'
					else
						call update_spkr_feat_table VOICED 'dur'
					endif
				endif
			endfor
		endif
	endfor
endproc

procedure accum_spkr_phone_stats
	if tk_DEBUG > -1
		printline [proceed accum_spkr_phone_stats]
	endif
	select phoneTextGridID
    interval_no = Get number of intervals... 1
	for i from 1 to interval_no
		select phoneTextGridID
		label$ = Get label of interval... 1 'i'
		if label$ <> ""
			start = Get starting point... 1 'i'
			end = Get end point... 1 'i'
			dur = round((end - start) / gc_frame_size)
			call update_phone_table 'globalPhoneTableID' 'label$' 'dur'
			call update_phone_table 'spkrPhoneTableID' 'label$' 'dur'
		endif
	endfor
endproc







# derive.praat
# procedures for computing the derived features

include table.praat

procedure derive_pf
	if tk_DEBUG >= 5
		printline [proceed in derive_pf]
	endif
	call derive_normalized_word
	call derive_pattern_feats
	call derive_normalized_pause
	call derive_normalized_vowel
	call derive_normalized_rhyme
	call derive_f0_feats
	call derive_energy_pattern_feats
	call derive_energy_feats
	call derive_average_phone
endproc

procedure derive_normalized_word
	if tk_DEBUG >= 5
		printline[proceed in derive_normalized_word]
	endif
	pf_WORD_DUR = pf_WORD_END - pf_WORD_START
	vf_WORD_DUR = 1
    # calculating WORD_AV_DUR
    if vf_WORD_PHONES = 0
        vf_WORD_AV_DUR = 0
        vf_NORM_WORD_DUR = 0
    else
   	    pf_WORD_AV_DUR = 0
   	    part_WORD_PHONES$ = pf_WORD_PHONES$
	    colon_pos = index(part_WORD_PHONES$, ":")
	    while colon_pos > 0
	        phone$ = left$(part_WORD_PHONES$, colon_pos - 1)
		    call lookup_phone_table 'globalPhoneTableID' 'phone$' MEAN
	   	    phone_mean = num_result1
		    pf_WORD_AV_DUR = pf_WORD_AV_DUR + phone_mean
		    len = length(part_WORD_PHONES$)
		    underscore_pos = index(part_WORD_PHONES$, "_")
		    if underscore_pos = 0
			    underscore_pos = len + 1
			endif
		    part_WORD_PHONES$ = right$(part_WORD_PHONES$, len - underscore_pos)
		    colon_pos = index(part_WORD_PHONES$, ":")
	    endwhile
	    if pf_WORD_AV_DUR = 0
	        vf_WORD_AV_DUR = 0
	        vf_NORM_WORD_DUR = 0
	    else
	        vf_WORD_AV_DUR = 1
	        pf_NORM_WORD_DUR = pf_WORD_DUR / pf_WORD_AV_DUR
	        vf_NORM_WORD_DUR = 1
	    endif
	endif
endproc	
	
procedure derive_pattern_feats
	if tk_DEBUG >= 5
		printline [proceed in derive_pattern_feats]
	endif
	if vf_PATTERN_SLOPE = 0
	    vf_LAST_SLOPE = 0
	else
		part_PATTERN_SLOPE$ = pf_PATTERN_SLOPE$
		find_slope = gc_FALSE
		while find_slope = gc_FALSE
			len = length(part_PATTERN_SLOPE$)
			comma_pos = rindex(part_PATTERN_SLOPE$, ";")
			last_slope$ = right$(part_PATTERN_SLOPE$, len - comma_pos)
			if last_slope$ = "U"
				if comma_pos = 0
					find_slope = gc_TRUE
					pf_LAST_SLOPE = gc_pos_infinit
					vf_LAST_SLOPE = 0
				else
					part_PATTERN_SLOPE$ = left$(part_PATTERN_SLOPE$, comma_pos - 1)
				endif
			else
				pf_LAST_SLOPE = 'last_slope$'
				vf_LAST_SLOPE = 1
				find_slope = gc_TRUE
			endif
		endwhile
	endif
	if vf_PATTERN_SLOPE_NEXT = 0
	    vf_FIRST_SLOPE_NEXT = 0
	else
		part_PATTERN_SLOPE$ = pf_PATTERN_SLOPE_NEXT$
		find_slope = gc_FALSE
		while find_slope = gc_FALSE
			len = length(part_PATTERN_SLOPE$)
			comma_pos = index(part_PATTERN_SLOPE$, ";")
			if comma_pos = 0
				comma_pos = len + 1
			endif
			first_slope$ = left$(part_PATTERN_SLOPE$, comma_pos - 1)
			if first_slope$ = "U"
				part_PATTERN_SLOPE$ = right$(part_PATTERN_SLOPE$, len - comma_pos)
				if part_PATTERN_SLOPE$ = ""
					find_slope = gc_TRUE
					pf_FIRST_SLOPE_NEXT = gc_pos_infinit
					vf_FIRST_SLOPE_NEXT = 0
				endif
			else
				pf_FIRST_SLOPE_NEXT = 'first_slope$'
				vf_FIRST_SLOPE_NEXT = 1
				find_slope = gc_TRUE
			endif
		endwhile
	endif
endproc

procedure derive_normalized_pause
	if tk_DEBUG >= 5
		printline [proceed in drive_normalized_pause]
	endif
	call lookup_spkr_sess_table 'pauseTableID' MEAN
	spkr_sess_pause_mean = num_result1
	if spkr_sess_pause_mean <= 0 or vf_PAUSE_DUR = 0
	    vf_PAUSE_DUR_N = 0
	else
	    pf_PAUSE_DUR_N = pf_PAUSE_DUR / spkr_sess_pause_mean
	    vf_PAUSE_DUR_N = 1
	endif
endproc

procedure derive_normalized_vowel
# TODO:
#	NEED TO HANDLE THE CASE WHEN A PHONE IN THE STATISTIC TABLE HAS 
#   COUNT LESS THAN THE MIN_COUNT
	if tk_DEBUG >= 5
		printline [proceed in derive_normalized_vowel]
	endif
	if vf_LAST_VOWEL = 1
		call lookup_phone_table 'globalPhoneTableID' 'pf_LAST_VOWEL$' MEAN
		all_phone_mean = num_result1
		call lookup_phone_table 'globalPhoneTableID' 'pf_LAST_VOWEL$' STDEV
		all_phone_stdev = num_result1
		if all_phone_stdev <> -1
    		pf_LAST_VOWEL_DUR_Z = (pf_LAST_VOWEL_DUR - all_phone_mean) / all_phone_stdev
    		vf_LAST_VOWEL_DUR_Z = 1
	       	pf_LAST_VOWEL_DUR_N = pf_LAST_VOWEL_DUR / all_phone_mean
	       	vf_LAST_VOWEL_DUR_N = 1
	    endif
		call lookup_phone_table 'spkrPhoneTableID' 'pf_LAST_VOWEL$' MEAN
		spkr_phone_mean = num_result1
		call lookup_phone_table 'spkrPhoneTableID' 'pf_LAST_VOWEL$' STDEV
		spkr_phone_stdev = num_result1
		if spkr_phone_stdev <> -1
		    pf_LAST_VOWEL_DUR_ZSP = (pf_LAST_VOWEL_DUR - spkr_phone_mean) / spkr_phone_stdev
		    pf_LAST_VOWEL_DUR_NSP = pf_LAST_VOWEL_DUR / spkr_phone_mean
		    vf_LAST_VOWEL_DUR_ZSP = 1
		    vf_LAST_VOWEL_DUR_NSP = 1
		endif
	else
		vf_LAST_VOWEL_DUR_Z = 0
		vf_LAST_VOWEL_DUR_N = 0
		vf_LAST_VOWEL_DUR_ZSP = 0
		vf_LAST_VOWEL_DUR_NSP = 0
	endif
endproc

procedure derive_normalized_rhyme
	if tk_DEBUG >= 5
		printline [proceed in derive_normalized_rhyme]
	endif
	# retrieve the statistics from tables
	call lookup_spkr_sess_table 'lastRhymePhoneTableID' MEAN
	spkr_sess_rhyme_phone_mean = num_result1
	call lookup_spkr_sess_table 'normLastRhymeTableID' MEAN
	spkr_sess_rhyme_norm_phone_mean = num_result1
	call lookup_spkr_sess_table 'normLastRhymeTableID' STDEV
	spkr_sess_rhyme_norm_phone_stdev = num_result1
	call lookup_spkr_sess_table 'lastRhymeTableID'  MEAN
	spkr_sess_rhyme_whole_mean = num_result1
	call lookup_spkr_sess_table 'lastRhymeTableID' STDEV
	spkr_sess_rhyme_whole_stdev = num_result1
	
	# compute the normalized features
	# printline [pf_WORD = 'pf_WORD$']
	# printline [pf_WORD_PHONES$ = 'pf_WORD_PHONES$']
  # printline [pf_LAST_RHYME_DUR = 'pf_LAST_RHYME_DUR']
	# printline [pf_PHONES_IN_LAST_RHYME = 'pf_PHONES_IN_LAST_RHYME']
	if vf_PHONES_IN_LAST_RHYME = 0 
		vf_LAST_RHYME_DUR_PH = 0
		vf_LAST_RHYME_DUR_PH_ND = 0
		vf_LAST_RHYME_DUR_PH_NR = 0
		vf_LAST_RHYME_NORM_DUR_PH = 0
		vf_LAST_RHYME_NORM_DUR_PH_ND = 0
		vf_LAST_RHYME_NORM_DUR_PH_NR = 0
		vf_LAST_RHYME_DUR_WHOLE_ND = 0
		vf_LAST_RHYME_DUR_WHOLE_NR = 0
		vf_LAST_RHYME_DUR_WHOLE_Z = 0
	else
	  pf_LAST_RHYME_DUR_PH = pf_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME
	  vf_LAST_RHYME_DUR_PH = 1
	  if spkr_sess_rhyme_phone_mean > 0
	        pf_LAST_RHYME_DUR_PH_ND = (pf_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME) - spkr_sess_rhyme_phone_mean
		    vf_LAST_RHYME_DUR_PH_ND = 1
  		    pf_LAST_RHYME_DUR_PH_NR = (pf_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME) / spkr_sess_rhyme_phone_mean
		    vf_LAST_RHYME_DUR_PH_NR = 1
		else
		    vf_LAST_RHYME_DUR_PH_ND = 0
		    vf_LAST_RHYME_DUR_PH_NR = 0
		endif
		if spkr_sess_rhyme_whole_mean > 0
            pf_LAST_RHYME_DUR_WHOLE_ND = pf_LAST_RHYME_DUR - spkr_sess_rhyme_whole_mean
            vf_LAST_RHYME_DUR_WHOLE_ND = 1
            pf_LAST_RHYME_DUR_WHOLE_NR = pf_LAST_RHYME_DUR / spkr_sess_rhyme_whole_mean
            vf_LAST_RHYME_DUR_WHOLE_NR = 1
            if spkr_sess_rhyme_whole_stdev > 0
                pf_LAST_RHYME_DUR_WHOLE_Z = (pf_LAST_RHYME_DUR - spkr_sess_rhyme_whole_mean) / spkr_sess_rhyme_whole_stdev
                vf_LAST_RHYME_DUR_WHOLE_Z = 1
            else
                vf_LAST_RHYME_DUR_WHOLE_Z = 0
            endif
        else
            vf_LAST_RHYME_DUR_WHOLE_ND = 0
            vf_LAST_RHYME_DUR_WHOLE_NR = 0
            vf_LAST_RHYME_DUR_WHOLE_Z  = 0
        endif

        if vf_NORM_LAST_RHYME_DUR = 1
            pf_LAST_RHYME_NORM_DUR_PH = pf_NORM_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME
            vf_LAST_RHYME_NORM_DUR_PH = 1
            if spkr_sess_rhyme_norm_phone_stdev <> -1
                pf_LAST_RHYME_NORM_DUR_PH_ND = (pf_NORM_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME) - spkr_sess_rhyme_norm_phone_mean
                vf_LAST_RHYME_NORM_DUR_PH_ND = 1
                if spkr_sess_rhyme_norm_phone_mean <> 0
                    pf_LAST_RHYME_NORM_DUR_PH_NR = (pf_NORM_LAST_RHYME_DUR / pf_PHONES_IN_LAST_RHYME) / spkr_sess_rhyme_norm_phone_mean
                    vf_LAST_RHYME_NORM_DUR_PH_NR = 1
                else
                    vf_LAST_RHYME_NORM_DUR_PH_NR = 0
                endif
            else
                vf_LAST_RHYME_NORM_DUR_PH_ND = 0
                vf_LAST_RHYME_NORM_DUR_PH_NR = 0
            endif
        endif
	endif
endproc

procedure derive_f0_feats
	if tk_DEBUG >= 5
		printline [proceed in dervie_f0_feats]
	endif
	# Compute basic pitch characteristics first
	call lookup_spkr_feat_table MEAN_PITCH
	spkr_feat_f0_mean = num_result1
	call lookup_spkr_feat_table STDEV_PITCH
	spkr_feat_f0_stdev = num_result1

	if spkr_feat_f0_mean > 0 and spkr_feat_f0_stdev > 0
    	spkr_feat_f0_mode = exp(spkr_feat_f0_mean)
       	spkr_feat_f0_baseln = 0.75 * spkr_feat_f0_mode
    	spkr_feat_f0_topln = 1.5 * spkr_feat_f0_mode
    	spkr_feat_f0_sdlin = exp(spkr_feat_f0_stdev)
    	spkr_feat_f0_range = spkr_feat_f0_topln - spkr_feat_f0_baseln

    	# Logratio between the previous and the next word max, mins and means:
    	# Logratio between the previous and the next word max, mins and means normalized by pitch range
    	if vf_MAX_STYLFIT_F0 = 0 or vf_MAX_STYLFIT_F0_NEXT = 0
    		vf_F0K_WORD_DIFF_HIHI_N = 0
    		vf_F0K_WORD_DIFF_HIHI_NG = 0
    	else
    		pf_F0K_WORD_DIFF_HIHI_N = ln(pf_MAX_STYLFIT_F0 / pf_MAX_STYLFIT_F0_NEXT)
    		vf_F0K_WORD_DIFF_HIHI_N = 1
    		pf_F0K_WORD_DIFF_HIHI_NG = (ln(pf_MAX_STYLFIT_F0) / ln(pf_MAX_STYLFIT_F0_NEXT)) / spkr_feat_f0_range
    		vf_F0K_WORD_DIFF_HIHI_NG = 1
    	endif

    	if vf_MAX_STYLFIT_F0 = 0 or vf_MIN_STYLFIT_F0_NEXT = 0
    	    vf_F0K_WORD_DIFF_HILO_N = 0
    	    vf_F0K_WORD_DIFF_HILO_NG = 0
    	else
    		pf_F0K_WORD_DIFF_HILO_N = ln(pf_MAX_STYLFIT_F0 / pf_MIN_STYLFIT_F0_NEXT)
    		vf_F0K_WORD_DIFF_HILO_N = 1
    		pf_F0K_WORD_DIFF_HILO_NG = (ln(pf_MAX_STYLFIT_F0) / ln(pf_MIN_STYLFIT_F0_NEXT)) / spkr_feat_f0_range
    		vf_F0K_WORD_DIFF_HILO_NG = 1
        endif

        if vf_MIN_STYLFIT_F0 = 0 or vf_MIN_STYLFIT_F0_NEXT = 0
            vf_F0K_WORD_DIFF_LOLO_N = 0
            vf_F0K_WORD_DIFF_LOLO_NG = 0
        else
    		pf_F0K_WORD_DIFF_LOLO_N = ln(pf_MIN_STYLFIT_F0 / pf_MIN_STYLFIT_F0_NEXT)
    		vf_F0K_WORD_DIFF_LOLO_N = 1
    		pf_F0K_WORD_DIFF_LOLO_NG = (ln(pf_MIN_STYLFIT_F0) / ln(pf_MIN_STYLFIT_F0_NEXT)) / spkr_feat_f0_range
    		vf_F0K_WORD_DIFF_LOLO_NG = 1
    	endif

    	if vf_MIN_STYLFIT_F0 = 0 or vf_MAX_STYLFIT_F0_NEXT = 0
    	    vf_F0K_WORD_DIFF_LOHI_N = 0
    	    vf_F0K_WORD_DIFF_LOHI_NG = 0
        else
    		pf_F0K_WORD_DIFF_LOHI_N = ln(pf_MIN_STYLFIT_F0 / pf_MAX_STYLFIT_F0_NEXT)
    		vf_F0K_WORD_DIFF_LOHI_N = 1
    		pf_F0K_WORD_DIFF_LOHI_NG = (ln(pf_MIN_STYLFIT_F0) / ln(pf_MAX_STYLFIT_F0_NEXT)) / spkr_feat_f0_range
    		vf_F0K_WORD_DIFF_LOHI_NG = 1
    	endif

    	if vf_MEAN_STYLFIT_F0 = 0 or vf_MEAN_STYLFIT_F0_NEXT = 0
    	    vf_F0K_WORD_DIFF_MNMN_N = 0
    	    vf_F0K_WORD_DIFF_MNMN_NG = 0
    	else
    		pf_F0K_WORD_DIFF_MNMN_N = ln(pf_MEAN_STYLFIT_F0 / pf_MEAN_STYLFIT_F0_NEXT)
    		vf_F0K_WORD_DIFF_MNMN_N = 1
    		pf_F0K_WORD_DIFF_MNMN_NG = (ln(pf_MEAN_STYLFIT_F0) / ln(pf_MEAN_STYLFIT_F0_NEXT)) / spkr_feat_f0_range
            vf_F0K_WORD_DIFF_MNMN_NG = 1
    	endif

    	# Logratio between the previous and the next window max, mins and means:
    	# Logratio between the previous and the next window max, mins and means normalized by pitch range

    	if vf_MAX_STYLFIT_F0_WIN = 1 and vf_MAX_STYLFIT_F0_NEXT_WIN = 1
    		pf_F0K_WIN_DIFF_HIHI_N = ln(pf_MAX_STYLFIT_F0_WIN / pf_MAX_STYLFIT_F0_NEXT_WIN)
    		vf_F0K_WIN_DIFF_HIHI_N = 1
    		pf_F0K_WIN_DIFF_HIHI_NG = (ln(pf_MAX_STYLFIT_F0_WIN) / ln(pf_MAX_STYLFIT_F0_NEXT_WIN)) / spkr_feat_f0_range
    		vf_F0K_WIN_DIFF_HIHI_NG = 1
    	endif

    	if vf_MAX_STYLFIT_F0_WIN = 1 and vf_MIN_STYLFIT_F0_NEXT_WIN = 1
    		pf_F0K_WIN_DIFF_HILO_N = ln(pf_MAX_STYLFIT_F0_WIN / pf_MIN_STYLFIT_F0_NEXT_WIN)
    		vf_F0K_WIN_DIFF_HILO_N = 1
    		pf_F0K_WIN_DIFF_HILO_NG = (ln(pf_MAX_STYLFIT_F0_WIN) / ln(pf_MIN_STYLFIT_F0_NEXT_WIN)) / spkr_feat_f0_range
    		vf_F0K_WIN_DIFF_HILO_NG = 1
        endif

        if vf_MIN_STYLFIT_F0_WIN = 1 and vf_MIN_STYLFIT_F0_NEXT_WIN = 1
    		pf_F0K_WIN_DIFF_LOLO_N = ln(pf_MIN_STYLFIT_F0_WIN / pf_MIN_STYLFIT_F0_NEXT_WIN)
    		vf_F0K_WIN_DIFF_LOLO_N = 1
    		pf_F0K_WIN_DIFF_LOLO_NG = (ln(pf_MIN_STYLFIT_F0_WIN) / ln(pf_MIN_STYLFIT_F0_NEXT_WIN)) / spkr_feat_f0_range
    		vf_F0K_WIN_DIFF_LOLO_NG = 1
    	endif

    	if vf_MIN_STYLFIT_F0_WIN = 1 and vf_MAX_STYLFIT_F0_NEXT_WIN = 1
    		pf_F0K_WIN_DIFF_LOHI_N = ln(pf_MIN_STYLFIT_F0_WIN / pf_MAX_STYLFIT_F0_NEXT_WIN)
    		vf_F0K_WIN_DIFF_LOHI_N = 1
    		pf_F0K_WIN_DIFF_LOHI_NG = (ln(pf_MIN_STYLFIT_F0_WIN) / ln(pf_MAX_STYLFIT_F0_NEXT_WIN)) / spkr_feat_f0_range
    		vf_F0K_WIN_DIFF_LOHI_NG = 1
    	endif

    	if vf_MEAN_STYLFIT_F0_WIN = 1 and vf_MEAN_STYLFIT_F0_NEXT_WIN = 1
    		pf_F0K_WIN_DIFF_MNMN_N = ln(pf_MEAN_STYLFIT_F0_WIN / pf_MEAN_STYLFIT_F0_NEXT_WIN)
    		vf_F0K_WIN_DIFF_MNMN_N = 1
    		pf_F0K_WIN_DIFF_MNMN_NG = (ln(pf_MEAN_STYLFIT_F0_WIN) / ln(pf_MEAN_STYLFIT_F0_NEXT_WIN)) / spkr_feat_f0_range
            vf_F0K_WIN_DIFF_MNMN_NG = 1
    	endif

    	# Difference and logration between last, mean and min in window pitch and the baseline pitch
    	if vf_LAST_STYLFIT_F0 = 1
    	    pf_F0K_DIFF_LAST_KBASELN = pf_LAST_STYLFIT_F0 - spkr_feat_f0_baseln
    	    vf_F0K_DIFF_LAST_KBASELN = 1
    	    pf_F0K_LR_LAST_KBASELN = ln(pf_LAST_STYLFIT_F0 / spkr_feat_f0_baseln)
        	vf_F0K_LR_LAST_KBASELN = 1
        endif

        if vf_MEAN_STYLFIT_F0 = 1
            pf_F0K_DIFF_MEAN_KBASELN = pf_MEAN_STYLFIT_F0 - spkr_feat_f0_baseln
            vf_F0K_DIFF_MEAN_KBASELN = 1
            pf_F0K_LR_MEAN_KBASELN = ln(pf_MEAN_STYLFIT_F0 / spkr_feat_f0_baseln)
            vf_F0K_LR_MEAN_KBASELN = 1
        endif

        if vf_MIN_STYLFIT_F0_WIN = 1
            pf_F0K_DIFF_WINMIN_KBASELN = pf_MIN_STYLFIT_F0_WIN - spkr_feat_f0_baseln
            vf_F0K_DIFF_WINMIN_KBASELN = 1
            pf_F0K_LR_WINMIN_KBASELN = ln(pf_MIN_STYLFIT_F0_WIN / spkr_feat_f0_baseln)
            vf_F0K_LR_WINMIN_KBASELN = 1
    	endif

    	# Normalization of the mean pitch in the word (and nextword) using the baseline, topline and range of pitch
        if vf_MEAN_STYLFIT_F0 = 1
        	pf_F0K_ZRANGE_MEAN_KBASELN = (pf_MEAN_STYLFIT_F0 - spkr_feat_f0_baseln) / spkr_feat_f0_range
        	vf_F0K_ZRANGE_MEAN_KBASELN = 1
         	pf_F0K_ZRANGE_MEAN_KTOPLN = (spkr_feat_f0_topln - pf_MEAN_STYLFIT_F0) / spkr_feat_f0_range
         	vf_F0K_ZRANGE_MEAN_KTOPLN = 1
        endif
        if vf_MEAN_STYLFIT_F0_NEXT = 1
            pf_F0K_ZRANGE_MEANNEXT_KBASELN = (pf_MEAN_STYLFIT_F0_NEXT - spkr_feat_f0_baseln) / spkr_feat_f0_range
            vf_F0K_ZRANGE_MEANNEXT_KBASELN = 1
    	    pf_F0K_ZRANGE_MEANNEXT_KTOPLN = (spkr_feat_f0_topln - pf_MEAN_STYLFIT_F0_NEXT) / spkr_feat_f0_range
    	    vf_F0K_ZRANGE_MEANNEXT_KTOPLN = 1
    	endif
####
    	# Difference and logratio between mean and max pitches (in the next word) and the topline pitch
    	if vf_MEAN_STYLFIT_F0_NEXT = 1
    	    pf_F0K_DIFF_MEANNEXT_KTOPLN = pf_MEAN_STYLFIT_F0_NEXT - spkr_feat_f0_topln
    	    vf_F0K_DIFF_MEANNEXT_KTOPLN = 1
   	        pf_F0K_LR_MEANNEXT_KTOPLN = ln(pf_MEAN_STYLFIT_F0_NEXT / spkr_feat_f0_topln)
    	    vf_F0K_LR_MEANNEXT_KTOPLN = 1
    	endif

    	if vf_MAX_STYLFIT_F0_NEXT = 1
    	    pf_F0K_DIFF_MAXNEXT_KTOPLN = pf_MAX_STYLFIT_F0_NEXT - spkr_feat_f0_topln
    	    vf_F0K_DIFF_MAXNEXT_KTOPLN = 1
    	    pf_F0K_LR_MAXNEXT_KTOPLN = ln(pf_MAX_STYLFIT_F0_NEXT / spkr_feat_f0_topln)
    	    vf_F0K_LR_MAXNEXT_KTOPLN = 1
    	endif

    	if vf_MAX_STYLFIT_F0_NEXT_WIN = 1
    	   	pf_F0K_DIFF_WINMAXNEXT_KTOPLN = pf_MAX_STYLFIT_F0_NEXT_WIN - spkr_feat_f0_topln
    	   	vf_F0K_DIFF_WINMAXNEXT_KTOPLN = 1
          	pf_F0K_LR_WINMAXNEXT_KTOPLN = ln(pf_MAX_STYLFIT_F0_NEXT_WIN / spkr_feat_f0_topln)
          	vf_F0K_LR_WINMAXNEXT_KTOPLN = 1
        endif

    	# Normalizations of the max pitch in this word and the next using pitch mode and range
        if vf_MAX_STYLFIT_F0 = 1
    		pf_F0K_MAXK_MODE_N = ln(pf_MAX_STYLFIT_F0 / spkr_feat_f0_mode)
    		vf_F0K_MAXK_MODE_N = 1
    		pf_F0K_MAXK_MODE_Z = (pf_MAX_STYLFIT_F0 - spkr_feat_f0_mode) / spkr_feat_f0_range
    		vf_F0K_MAXK_MODE_Z = 1
    	endif
    	if vf_MAX_STYLFIT_F0_NEXT = 1
    		pf_F0K_MAXK_NEXT_MODE_N = ln(pf_MAX_STYLFIT_F0_NEXT / spkr_feat_f0_mode)
    		vf_F0K_MAXK_NEXT_MODE_N = 1
    		pf_F0K_MAXK_NEXT_MODE_Z = (pf_MAX_STYLFIT_F0_NEXT - spkr_feat_f0_mode) / spkr_feat_f0_range
    		vf_F0K_MAXK_NEXT_MODE_Z = 1
    	endif
    	
    	# Logratio between pitches in the word extremes:
    	if vf_FIRST_STYLFIT_F0 = 1 and vf_FIRST_STYLFIT_F0_NEXT = 1
    	    pf_F0K_WORD_DIFF_BEGBEG = ln(pf_FIRST_STYLFIT_F0 / pf_FIRST_STYLFIT_F0_NEXT)
    	    vf_F0K_WORD_DIFF_BEGBEG = 1
    	endif

    	if vf_LAST_STYLFIT_F0 = 1 and vf_FIRST_STYLFIT_F0_NEXT = 1
            pf_F0K_WORD_DIFF_ENDBEG = ln(pf_LAST_STYLFIT_F0 / pf_FIRST_STYLFIT_F0_NEXT)
            vf_F0K_WORD_DIFF_ENDBEG = 1
    	endif
    	
    	if vf_FIRST_STYLFIT_F0 = 1 and vf_LAST_STYLFIT_F0 = 1
            pf_F0K_INWORD_DIFF = ln(pf_FIRST_STYLFIT_F0 / pf_LAST_STYLFIT_F0)
            vf_F0K_INWORD_DIFF = 1
    	endif

    	# normalization of slope
    	call lookup_spkr_feat_table STDEV_SLOPE
    	spkr_feat_sd_slope = num_result1   
        if vf_SLOPE_DIFF = 1 and spkr_feat_sd_slope > 0
            pf_SLOPE_DIFF_N = pf_SLOPE_DIFF / spkr_feat_sd_slope
            vf_SLOPE_DIFF_N = 1
        endif
        if vf_LAST_SLOPE = 1 and vf_LAST_STYLFIT_F0 = 1
            pf_LAST_SLOPE_N = pf_LAST_SLOPE / pf_LAST_STYLFIT_F0
            vf_LAST_SLOPE_N = 1
        endif
    endif
endproc

procedure derive_average_phone
	if tk_DEBUG >= 5
		printline [proceed in derive_average_phone]
	endif

	# initialization
	vf_AVG_PHONE_DUR_Z = 1
	vf_MAX_PHONE_DUR_Z = 1
	vf_AVG_PHONE_DUR_N = 1
	vf_MAX_PHONE_DUR_N = 1

	vf_AVG_PHONE_DUR_ZSP = 1
	vf_MAX_PHONE_DUR_ZSP = 1
	vf_AVG_PHONE_DUR_NSP = 1
	vf_MAX_PHONE_DUR_NSP = 1

	vf_AVG_VOWEL_DUR_Z = 1
	vf_MAX_VOWEL_DUR_Z = 1
	vf_AVG_VOWEL_DUR_N = 1
	vf_MAX_VOWEL_DUR_N = 1
	
	vf_AVG_VOWEL_DUR_ZSP = 1
	vf_MAX_VOWEL_DUR_ZSP = 1
	vf_AVG_VOWEL_DUR_NSP = 1
	vf_MAX_VOWEL_DUR_NSP = 1		
	
	pf_AVG_PHONE_DUR_Z = 0
	pf_MAX_PHONE_DUR_Z = gc_neg_infinit
	pf_AVG_PHONE_DUR_N = 0
	pf_MAX_PHONE_DUR_N = gc_neg_infinit
	
	pf_AVG_PHONE_DUR_ZSP = 0
	pf_MAX_PHONE_DUR_ZSP = gc_neg_infinit
	pf_AVG_PHONE_DUR_NSP = 0
	pf_MAX_PHONE_DUR_NSP = gc_neg_infinit
	
	pf_AVG_VOWEL_DUR_Z = 0
	pf_MAX_VOWEL_DUR_Z = gc_neg_infinit
	pf_AVG_VOWEL_DUR_N = 0
	pf_MAX_VOWEL_DUR_N = gc_neg_infinit
	
	pf_AVG_VOWEL_DUR_ZSP = 0
	pf_MAX_VOWEL_DUR_ZSP = gc_neg_infinit
	pf_AVG_VOWEL_DUR_NSP = 0
	pf_MAX_VOWEL_DUR_NSP = gc_neg_infinit	
	
	nphones = 0
	nvowels = 0
	
	part_WORD_PHONES$ = pf_WORD_PHONES$
	colon_pos = index(part_WORD_PHONES$, ":")
	while colon_pos > 0
		phone$ = left$(part_WORD_PHONES$,  colon_pos - 1)
		call isVowel 'phone$'
		isVowel = num_result1

		call lookup_phone_table 'globalPhoneTableID' 'phone$' MEAN
		global_phone_mean = num_result1
		call lookup_phone_table 'globalPhoneTableID' 'phone$' STDEV
		global_phone_stdev = num_result1
		
		call lookup_phone_table 'spkrPhoneTableID' 'phone$' MEAN
		spkr_phone_mean = num_result1
		call lookup_phone_table 'spkrPhoneTableID' 'phone$' STDEV
		spkr_phone_stdev = num_result1
		
		len = length(part_WORD_PHONES$)
		underscore_pos = index(part_WORD_PHONES$, "_")
		if underscore_pos = 0
			underscore_pos = len + 1
		endif
		dur$ = mid$(part_WORD_PHONES$, colon_pos + 1, underscore_pos - 1 - colon_pos)
		phone_dur = 'dur$'
		
		# global normalization
		if global_phone_stdev = -1
		    vf_AVG_PHONE_DUR_Z = 0
		    vf_MAX_PHONE_DUR_Z = 0
		    vf_AVG_PHONE_DUR_N = 0
		    vf_MAX_PHONE_DUR_N = 0
		 else
            global_phone_z = (phone_dur - global_phone_mean) / global_phone_stdev
   			pf_AVG_PHONE_DUR_Z = pf_AVG_PHONE_DUR_Z + global_phone_z
    		if global_phone_z > pf_MAX_PHONE_DUR_Z
    			pf_MAX_PHONE_DUR_Z = global_phone_z
    		endif
	    	global_phone_n = phone_dur / global_phone_mean
	       	pf_AVG_PHONE_DUR_N = pf_AVG_PHONE_DUR_N + global_phone_n
		    if global_phone_n > pf_MAX_PHONE_DUR_N
			    pf_MAX_PHONE_DUR_N = global_phone_n
    		endif
        endif
        
		# spkr specific normalization
		if spkr_phone_stdev = -1
            vf_AVG_PHONE_DUR_ZSP = 0
		    vf_MAX_PHONE_DUR_ZSP = 0
		    vf_AVG_PHONE_DUR_NSP = 0
		    vf_MAX_PHONE_DUR_NSP = 0	
		else
            spkr_phone_z = (phone_dur - spkr_phone_mean) / spkr_phone_stdev
    		pf_AVG_PHONE_DUR_ZSP = pf_AVG_PHONE_DUR_ZSP + spkr_phone_z
    		if spkr_phone_z > pf_MAX_PHONE_DUR_ZSP
    			pf_MAX_PHONE_DUR_ZSP = spkr_phone_z
    		endif
    		spkr_phone_n = phone_dur / spkr_phone_mean
    		pf_AVG_PHONE_DUR_NSP = pf_AVG_PHONE_DUR_NSP + spkr_phone_n
       		if spkr_phone_n > pf_MAX_PHONE_DUR_NSP
    		  	pf_MAX_PHONE_DUR_NSP = spkr_phone_n
    		endif	
        endif
				
		nphones = nphones + 1
		
		if isVowel = 1
			# global normalization
			if global_phone_stdev = -1
    		    vf_AVG_VOWEL_DUR_Z = 0
    		    vf_MAX_VOWEL_DUR_Z = 0
    		    vf_AVG_VOWEL_DUR_N = 0
    		    vf_MAX_VOWEL_DUR_N = 0
	        else
    			pf_AVG_VOWEL_DUR_Z = pf_AVG_VOWEL_DUR_Z + global_phone_z
    			if global_phone_z > pf_MAX_VOWEL_DUR_Z
    				pf_MAX_VOWEL_DUR_Z = global_phone_z
    			endif
    			pf_AVG_VOWEL_DUR_N = pf_AVG_VOWEL_DUR_N + global_phone_n
    			if global_phone_n > pf_MAX_VOWEL_DUR_N
    				pf_MAX_VOWEL_DUR_N = global_phone_n
    			endif
			endif
			
			# spkr normalization
			if spkr_phone_stdev = -1
    		    vf_AVG_VOWEL_DUR_ZSP = 0
    		    vf_MAX_VOWEL_DUR_ZSP = 0
    		    vf_AVG_VOWEL_DUR_NSP = 0
    		    vf_MAX_VOWEL_DUR_NSP = 0
	        else			
    			pf_AVG_VOWEL_DUR_ZSP = pf_AVG_VOWEL_DUR_ZSP + spkr_phone_z
    			if spkr_phone_z > pf_MAX_VOWEL_DUR_ZSP
	       			pf_MAX_VOWEL_DUR_ZSP = spkr_phone_z
    			endif
    			pf_AVG_VOWEL_DUR_NSP = pf_AVG_VOWEL_DUR_NSP + spkr_phone_n
    			if spkr_phone_n > pf_MAX_VOWEL_DUR_NSP
    				pf_MAX_VOWEL_DUR_NSP = spkr_phone_n
	       		endif		
	       	endif			
			nvowels = nvowels + 1
		endif
		part_WORD_PHONES$ = right$(part_WORD_PHONES$, len - underscore_pos)
		colon_pos = index(part_WORD_PHONES$, ":")
	endwhile
	if nphones > 0
		pf_AVG_PHONE_DUR_Z = pf_AVG_PHONE_DUR_Z / nphones
		pf_AVG_PHONE_DUR_N = pf_AVG_PHONE_DUR_N / nphones
	
		pf_AVG_PHONE_DUR_ZSP = pf_AVG_PHONE_DUR_ZSP / nphones
		pf_AVG_PHONE_DUR_NSP = pf_AVG_PHONE_DUR_NSP / nphones
	else
    	vf_AVG_PHONE_DUR_Z = 0
    	vf_MAX_PHONE_DUR_Z = 0
    	vf_AVG_PHONE_DUR_N = 0
    	vf_MAX_PHONE_DUR_N = 0
	
    	vf_AVG_PHONE_DUR_ZSP = 0
    	vf_MAX_PHONE_DUR_ZSP = 0
    	vf_AVG_PHONE_DUR_NSP = 0
    	vf_MAX_PHONE_DUR_NSP = 0	
	endif
		
	if nvowels > 0
		pf_AVG_VOWEL_DUR_Z = pf_AVG_VOWEL_DUR_Z / nvowels
		pf_AVG_VOWEL_DUR_N = pf_AVG_VOWEL_DUR_N / nvowels
	
		pf_AVG_VOWEL_DUR_ZSP = pf_AVG_VOWEL_DUR_ZSP / nvowels
		pf_AVG_VOWEL_DUR_NSP = pf_AVG_VOWEL_DUR_NSP / nvowels
	else
    	vf_AVG_VOWEL_DUR_Z = 0
    	vf_MAX_VOWEL_DUR_Z = 0
    	vf_AVG_VOWEL_DUR_N = 0
    	vf_MAX_VOWEL_DUR_N = 0
	
    	vf_AVG_VOWEL_DUR_ZSP = 0
    	vf_MAX_VOWEL_DUR_ZSP = 0
    	vf_AVG_VOWEL_DUR_NSP = 0
    	vf_MAX_VOWEL_DUR_NSP = 0		
	endif
endproc

procedure derive_energy_pattern_feats
	if tk_DEBUG >= 5
		printline [proceed in derive_energy_pattern_feats]
	endif
	if vf_ENERGY_PATTERN_SLOPE = 0
	    vf_ENERGY_LAST_SLOPE = 0
	else
		part_PATTERN_SLOPE$ = pf_ENERGY_PATTERN_SLOPE$
		find_slope = gc_FALSE
		while find_slope = gc_FALSE
			len = length(part_PATTERN_SLOPE$)
			comma_pos = rindex(part_PATTERN_SLOPE$, ";")
			last_slope$ = right$(part_PATTERN_SLOPE$, len - comma_pos)
			if last_slope$ = "U"
				if comma_pos = 0
					find_slope = gc_TRUE
					pf_ENERGY_LAST_SLOPE = gc_pos_infinit
					vf_ENERGY_LAST_SLOPE = 0
				else
					part_PATTERN_SLOPE$ = left$(part_PATTERN_SLOPE$, comma_pos - 1)
				endif
			else
				pf_ENERGY_LAST_SLOPE = 'last_slope$'
				vf_ENERGY_LAST_SLOPE = 1
				find_slope = gc_TRUE
			endif
		endwhile
	endif
	if vf_ENERGY_PATTERN_SLOPE_NEXT = 0
	    vf_ENERGY_FIRST_SLOPE_NEXT = 0
	else
		part_PATTERN_SLOPE$ = pf_ENERGY_PATTERN_SLOPE_NEXT$
		find_slope = gc_FALSE
		while find_slope = gc_FALSE
			len = length(part_PATTERN_SLOPE$)
			comma_pos = index(part_PATTERN_SLOPE$, ";")
			if comma_pos = 0
				comma_pos = len + 1
			endif
			first_slope$ = left$(part_PATTERN_SLOPE$, comma_pos - 1)
			if first_slope$ = "U"
				part_PATTERN_SLOPE$ = right$(part_PATTERN_SLOPE$, len - comma_pos)
				if part_PATTERN_SLOPE$ = ""
					find_slope = gc_TRUE
					pf_ENERGY_FIRST_SLOPE_NEXT = gc_pos_infinit
					vf_ENERGY_FIRST_SLOPE_NEXT = 0
				endif
			else
				pf_ENERGY_FIRST_SLOPE_NEXT = 'first_slope$'
				vf_ENERGY_FIRST_SLOPE_NEXT = 1
				find_slope = gc_TRUE
			endif
		endwhile
	endif
endproc



procedure derive_energy_feats
	if tk_DEBUG >= 5
		printline [proceed in dervie_energy_feats]
	endif
	# Compute basic energy characteristics first
	call lookup_spkr_feat_table MEAN_ENERGY
	spkr_feat_energy_mean = num_result1
	call lookup_spkr_feat_table STDEV_ENERGY
	spkr_feat_energy_stdev = num_result1

	if spkr_feat_energy_mean > 0 and spkr_feat_energy_stdev > 0
    	spkr_feat_energy_mode = exp(spkr_feat_energy_mean)
       	spkr_feat_energy_baseln = 0.75 * spkr_feat_energy_mode
    	spkr_feat_energy_topln = 1.5 * spkr_feat_energy_mode
    	spkr_feat_energy_sdlin = exp(spkr_feat_energy_stdev)
    	spkr_feat_energy_range = spkr_feat_energy_topln - spkr_feat_energy_baseln

    	# Logratio between the previous and the next word max, mins and means:
    	# Logratio between the previous and the next word max, mins and means normalized by energy range
    	if vf_MAX_STYLFIT_ENERGY = 0 or vf_MAX_STYLFIT_ENERGY_NEXT = 0
    		vf_ENERGY_WORD_DIFF_HIHI_N = 0
    		vf_ENERGY_WORD_DIFF_HIHI_NG = 0
    	else
    		pf_ENERGY_WORD_DIFF_HIHI_N = ln(pf_MAX_STYLFIT_ENERGY / pf_MAX_STYLFIT_ENERGY_NEXT)
    		vf_ENERGY_WORD_DIFF_HIHI_N = 1
    		pf_ENERGY_WORD_DIFF_HIHI_NG = (ln(pf_MAX_STYLFIT_ENERGY) / ln(pf_MAX_STYLFIT_ENERGY_NEXT)) / spkr_feat_energy_range
    		vf_ENERGY_WORD_DIFF_HIHI_NG = 1
    	endif

    	if vf_MAX_STYLFIT_ENERGY = 0 or vf_MIN_STYLFIT_ENERGY_NEXT = 0
    	    vf_ENERGY_WORD_DIFF_HILO_N = 0
    	    vf_ENERGY_WORD_DIFF_HILO_NG = 0
    	else
    		pf_ENERGY_WORD_DIFF_HILO_N = ln(pf_MAX_STYLFIT_ENERGY / pf_MIN_STYLFIT_ENERGY_NEXT)
    		vf_ENERGY_WORD_DIFF_HILO_N = 1
    		pf_ENERGY_WORD_DIFF_HILO_NG = (ln(pf_MAX_STYLFIT_ENERGY) / ln(pf_MIN_STYLFIT_ENERGY_NEXT)) / spkr_feat_energy_range
    		vf_ENERGY_WORD_DIFF_HILO_NG = 1
        endif

        if vf_MIN_STYLFIT_ENERGY = 0 or vf_MIN_STYLFIT_ENERGY_NEXT = 0
            vf_ENERGY_WORD_DIFF_LOLO_N = 0
            vf_ENERGY_WORD_DIFF_LOLO_NG = 0
        else
    		pf_ENERGY_WORD_DIFF_LOLO_N = ln(pf_MIN_STYLFIT_ENERGY / pf_MIN_STYLFIT_ENERGY_NEXT)
    		vf_ENERGY_WORD_DIFF_LOLO_N = 1
    		pf_ENERGY_WORD_DIFF_LOLO_NG = (ln(pf_MIN_STYLFIT_ENERGY) / ln(pf_MIN_STYLFIT_ENERGY_NEXT)) / spkr_feat_energy_range
    		vf_ENERGY_WORD_DIFF_LOLO_NG = 1
    	endif

    	if vf_MIN_STYLFIT_ENERGY = 0 or vf_MAX_STYLFIT_ENERGY_NEXT = 0
    	    vf_ENERGY_WORD_DIFF_LOHI_N = 0
    	    vf_ENERGY_WORD_DIFF_LOHI_NG = 0
        else
    		pf_ENERGY_WORD_DIFF_LOHI_N = ln(pf_MIN_STYLFIT_ENERGY / pf_MAX_STYLFIT_ENERGY_NEXT)
    		vf_ENERGY_WORD_DIFF_LOHI_N = 1
    		pf_ENERGY_WORD_DIFF_LOHI_NG = (ln(pf_MIN_STYLFIT_ENERGY) / ln(pf_MAX_STYLFIT_ENERGY_NEXT)) / spkr_feat_energy_range
    		vf_ENERGY_WORD_DIFF_LOHI_NG = 1
    	endif

    	if vf_MEAN_STYLFIT_ENERGY = 0 or vf_MEAN_STYLFIT_ENERGY_NEXT = 0
    	    vf_ENERGY_WORD_DIFF_MNMN_N = 0
    	    vf_ENERGY_WORD_DIFF_MNMN_NG = 0
    	else
    		pf_ENERGY_WORD_DIFF_MNMN_N = ln(pf_MEAN_STYLFIT_ENERGY / pf_MEAN_STYLFIT_ENERGY_NEXT)
    		vf_ENERGY_WORD_DIFF_MNMN_N = 1
    		pf_ENERGY_WORD_DIFF_MNMN_NG = (ln(pf_MEAN_STYLFIT_ENERGY) / ln(pf_MEAN_STYLFIT_ENERGY_NEXT)) / spkr_feat_energy_range
            vf_ENERGY_WORD_DIFF_MNMN_NG = 1
    	endif

    	# Logratio between the previous and the next window max, mins and means:
    	# Logratio between the previous and the next window max, mins and means normalized by energy range

    	if vf_MAX_STYLFIT_ENERGY_WIN = 1 and vf_MAX_STYLFIT_ENERGY_NEXT_WIN = 1
    		pf_ENERGY_WIN_DIFF_HIHI_N = ln(pf_MAX_STYLFIT_ENERGY_WIN / pf_MAX_STYLFIT_ENERGY_NEXT_WIN)
    		vf_ENERGY_WIN_DIFF_HIHI_N = 1
    		pf_ENERGY_WIN_DIFF_HIHI_NG = (ln(pf_MAX_STYLFIT_ENERGY_WIN) / ln(pf_MAX_STYLFIT_ENERGY_NEXT_WIN)) / spkr_feat_energy_range
    		vf_ENERGY_WIN_DIFF_HIHI_NG = 1
    	endif

    	if vf_MAX_STYLFIT_ENERGY_WIN = 1 and vf_MIN_STYLFIT_ENERGY_NEXT_WIN = 1
    		pf_ENERGY_WIN_DIFF_HILO_N = ln(pf_MAX_STYLFIT_ENERGY_WIN / pf_MIN_STYLFIT_ENERGY_NEXT_WIN)
    		vf_ENERGY_WIN_DIFF_HILO_N = 1
    		pf_ENERGY_WIN_DIFF_HILO_NG = (ln(pf_MAX_STYLFIT_ENERGY_WIN) / ln(pf_MIN_STYLFIT_ENERGY_NEXT_WIN)) / spkr_feat_energy_range
    		vf_ENERGY_WIN_DIFF_HILO_NG = 1
        endif

        if vf_MIN_STYLFIT_ENERGY_WIN = 1 and vf_MIN_STYLFIT_ENERGY_NEXT_WIN = 1
    		pf_ENERGY_WIN_DIFF_LOLO_N = ln(pf_MIN_STYLFIT_ENERGY_WIN / pf_MIN_STYLFIT_ENERGY_NEXT_WIN)
    		vf_ENERGY_WIN_DIFF_LOLO_N = 1
    		pf_ENERGY_WIN_DIFF_LOLO_NG = (ln(pf_MIN_STYLFIT_ENERGY_WIN) / ln(pf_MIN_STYLFIT_ENERGY_NEXT_WIN)) / spkr_feat_energy_range
    		vf_ENERGY_WIN_DIFF_LOLO_NG = 1
    	endif

    	if vf_MIN_STYLFIT_ENERGY_WIN = 1 and vf_MAX_STYLFIT_ENERGY_NEXT_WIN = 1
    		pf_ENERGY_WIN_DIFF_LOHI_N = ln(pf_MIN_STYLFIT_ENERGY_WIN / pf_MAX_STYLFIT_ENERGY_NEXT_WIN)
    		vf_ENERGY_WIN_DIFF_LOHI_N = 1
    		pf_ENERGY_WIN_DIFF_LOHI_NG = (ln(pf_MIN_STYLFIT_ENERGY_WIN) / ln(pf_MAX_STYLFIT_ENERGY_NEXT_WIN)) / spkr_feat_energy_range
    		vf_ENERGY_WIN_DIFF_LOHI_NG = 1
    	endif

    	if vf_MEAN_STYLFIT_ENERGY_WIN = 1 and vf_MEAN_STYLFIT_ENERGY_NEXT_WIN = 1
    		pf_ENERGY_WIN_DIFF_MNMN_N = ln(pf_MEAN_STYLFIT_ENERGY_WIN / pf_MEAN_STYLFIT_ENERGY_NEXT_WIN)
    		vf_ENERGY_WIN_DIFF_MNMN_N = 1
    		pf_ENERGY_WIN_DIFF_MNMN_NG = (ln(pf_MEAN_STYLFIT_ENERGY_WIN) / ln(pf_MEAN_STYLFIT_ENERGY_NEXT_WIN)) / spkr_feat_energy_range
            vf_ENERGY_WIN_DIFF_MNMN_NG = 1
    	endif

    	# Difference and logration between last, mean and min in window energy and the baseline energy
    	if vf_LAST_STYLFIT_ENERGY = 1
    	    pf_ENERGY_DIFF_LAST_KBASELN = pf_LAST_STYLFIT_ENERGY - spkr_feat_energy_baseln
    	    vf_ENERGY_DIFF_LAST_KBASELN = 1
    	    pf_ENERGY_LR_LAST_KBASELN = ln(pf_LAST_STYLFIT_ENERGY / spkr_feat_energy_baseln)
        	vf_ENERGY_LR_LAST_KBASELN = 1
        endif

        if vf_MEAN_STYLFIT_ENERGY = 1
            pf_ENERGY_DIFF_MEAN_KBASELN = pf_MEAN_STYLFIT_ENERGY - spkr_feat_energy_baseln
            vf_ENERGY_DIFF_MEAN_KBASELN = 1
            pf_ENERGY_LR_MEAN_KBASELN = ln(pf_MEAN_STYLFIT_ENERGY / spkr_feat_energy_baseln)
            vf_ENERGY_LR_MEAN_KBASELN = 1
        endif

        if vf_MIN_STYLFIT_ENERGY_WIN = 1
            pf_ENERGY_DIFF_WINMIN_KBASELN = pf_MIN_STYLFIT_ENERGY_WIN - spkr_feat_energy_baseln
            vf_ENERGY_DIFF_WINMIN_KBASELN = 1
            pf_ENERGY_LR_WINMIN_KBASELN = ln(pf_MIN_STYLFIT_ENERGY_WIN / spkr_feat_energy_baseln)
            vf_ENERGY_LR_WINMIN_KBASELN = 1
    	endif

    	# Normalization of the mean energy in the word (and nextword) using the baseline, topline and range of energy
        if vf_MEAN_STYLFIT_ENERGY = 1
        	pf_ENERGY_ZRANGE_MEAN_KBASELN = (pf_MEAN_STYLFIT_ENERGY - spkr_feat_energy_baseln) / spkr_feat_energy_range
        	vf_ENERGY_ZRANGE_MEAN_KBASELN = 1
         	pf_ENERGY_ZRANGE_MEAN_KTOPLN = (spkr_feat_energy_topln - pf_MEAN_STYLFIT_ENERGY) / spkr_feat_energy_range
         	vf_ENERGY_ZRANGE_MEAN_KTOPLN = 1
        endif
        if vf_MEAN_STYLFIT_ENERGY_NEXT = 1
            pf_ENERGY_ZRANGE_MEANNEXT_KBASELN = (pf_MEAN_STYLFIT_ENERGY_NEXT - spkr_feat_energy_baseln) / spkr_feat_energy_range
            vf_ENERGY_ZRANGE_MEANNEXT_KBASELN = 1
    	    pf_ENERGY_ZRANGE_MEANNEXT_KTOPLN = (spkr_feat_energy_topln - pf_MEAN_STYLFIT_ENERGY_NEXT) / spkr_feat_energy_range
    	    vf_ENERGY_ZRANGE_MEANNEXT_KTOPLN = 1
    	endif
####
    	# Difference and logratio between mean and max energy (in the next word) and the topline energy
    	if vf_MEAN_STYLFIT_ENERGY_NEXT = 1
    	    pf_ENERGY_DIFF_MEANNEXT_KTOPLN = pf_MEAN_STYLFIT_ENERGY_NEXT - spkr_feat_energy_topln
    	    vf_ENERGY_DIFF_MEANNEXT_KTOPLN = 1
   	        pf_ENERGY_LR_MEANNEXT_KTOPLN = ln(pf_MEAN_STYLFIT_ENERGY_NEXT / spkr_feat_energy_topln)
    	    vf_ENERGY_LR_MEANNEXT_KTOPLN = 1
    	endif

    	if vf_MAX_STYLFIT_ENERGY_NEXT = 1
    	    pf_ENERGY_DIFF_MAXNEXT_KTOPLN = pf_MAX_STYLFIT_ENERGY_NEXT - spkr_feat_energy_topln
    	    vf_ENERGY_DIFF_MAXNEXT_KTOPLN = 1
    	    pf_ENERGY_LR_MAXNEXT_KTOPLN = ln(pf_MAX_STYLFIT_ENERGY_NEXT / spkr_feat_energy_topln)
    	    vf_ENERGY_LR_MAXNEXT_KTOPLN = 1
    	endif

    	if vf_MAX_STYLFIT_ENERGY_NEXT_WIN = 1
    	   	pf_ENERGY_DIFF_WINMAXNEXT_KTOPLN = pf_MAX_STYLFIT_ENERGY_NEXT_WIN - spkr_feat_energy_topln
    	   	vf_ENERGY_DIFF_WINMAXNEXT_KTOPLN = 1
          	pf_ENERGY_LR_WINMAXNEXT_KTOPLN = ln(pf_MAX_STYLFIT_ENERGY_NEXT_WIN / spkr_feat_energy_topln)
          	vf_ENERGY_LR_WINMAXNEXT_KTOPLN = 1
        endif

    	# Normalizations of the max energy in this word and the next using energy mode and range
        if vf_MAX_STYLFIT_ENERGY = 1
    		pf_ENERGY_MAXK_MODE_N = ln(pf_MAX_STYLFIT_ENERGY / spkr_feat_energy_mode)
    		vf_ENERGY_MAXK_MODE_N = 1
    		pf_ENERGY_MAXK_MODE_Z = (pf_MAX_STYLFIT_ENERGY - spkr_feat_energy_mode) / spkr_feat_energy_range
    		vf_ENERGY_MAXK_MODE_Z = 1
    	endif
    	if vf_MAX_STYLFIT_ENERGY_NEXT = 1
    		pf_ENERGY_MAXK_NEXT_MODE_N = ln(pf_MAX_STYLFIT_ENERGY_NEXT / spkr_feat_energy_mode)
    		vf_ENERGY_MAXK_NEXT_MODE_N = 1
    		pf_ENERGY_MAXK_NEXT_MODE_Z = (pf_MAX_STYLFIT_ENERGY_NEXT - spkr_feat_energy_mode) / spkr_feat_energy_range
    		vf_ENERGY_MAXK_NEXT_MODE_Z = 1
    	endif
    	
    	# Logratio between energy in the word extremes:
    	if vf_FIRST_STYLFIT_ENERGY = 1 and vf_FIRST_STYLFIT_ENERGY_NEXT = 1
    	    pf_ENERGY_WORD_DIFF_BEGBEG = ln(pf_FIRST_STYLFIT_ENERGY / pf_FIRST_STYLFIT_ENERGY_NEXT)
    	    vf_ENERGY_WORD_DIFF_BEGBEG = 1
    	endif

    	if vf_LAST_STYLFIT_ENERGY = 1 and vf_FIRST_STYLFIT_ENERGY_NEXT = 1
            pf_ENERGY_WORD_DIFF_ENDBEG = ln(pf_LAST_STYLFIT_ENERGY / pf_FIRST_STYLFIT_ENERGY_NEXT)
            vf_ENERGY_WORD_DIFF_ENDBEG = 1
    	endif
    	
    	if vf_FIRST_STYLFIT_ENERGY = 1 and vf_LAST_STYLFIT_ENERGY = 1
            pf_ENERGY_INWORD_DIFF = ln(pf_FIRST_STYLFIT_ENERGY / pf_LAST_STYLFIT_ENERGY)
            vf_ENERGY_INWORD_DIFF = 1
    	endif

    	# normalization of slope
    	call lookup_spkr_feat_table STDEV_ENERGY_SLOPE
    	spkr_feat_energy_sd_slope = num_result1   
        if vf_ENERGY_SLOPE_DIFF = 1 and spkr_feat_energy_sd_slope > 0
            pf_ENERGY_SLOPE_DIFF_N = pf_ENERGY_SLOPE_DIFF / spkr_feat_energy_sd_slope
            vf_ENERGY_SLOPE_DIFF_N = 1
        endif
        if vf_ENERGY_LAST_SLOPE = 1 and vf_LAST_STYLFIT_ENERGY = 1
            pf_ENERGY_LAST_SLOPE_N = pf_ENERGY_LAST_SLOPE / pf_LAST_STYLFIT_ENERGY
            vf_ENERGY_LAST_SLOPE_N = 1
        endif
    endif
endproc



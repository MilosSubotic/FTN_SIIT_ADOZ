#!/usr/bin/env julia

using Plots
using FFTW
using DSP

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_smpl = 48000


p_t_domain = plot(
	title = "Time domain",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
	#ylim = [-1.2, 1.2],
	size = (1000, 800),
)


p_f_domain_amp = plot(
	title = "Freq Amplitude",
	xlabel = "Freq [kHz]",
	ylabel = "Amp [V]",
	size = (1000, 800),
)

if false
	p_f_domain_amp = plot(
		title = "Freq Amplitude",
		xlabel = "Freq [kHz]",
		ylabel = "Amp [V]",
		size = (1000, 800),
	)
else
	p_f_domain_amp = plot(
		title = "Freq Amplitude",
		xlabel = "Freq [kHz]",
		ylabel = "Amp [V]",
		yaxis = :log,
		size = (1000, 800),
	)
end

p_f_domain_amp_dB = plot(
	title = "Freq Amplitude",
	xlabel = "Freq [kHz]",
	ylabel = "Amp [dB]",
	size = (1000, 800),
)

p_f_domain_phs = plot(
	title = "Freq Phase",
	xlabel = "Freq [kHz]",
	ylabel = "Phase [deg]",
	size = (1000, 800),
)

A_to_dB(A) = 20*log10(A)

for	N_taps in [50, 300]
	L = div(N_taps, 2)
	@show L
	rf_fft = range(0.0, 0.5, length = L+1)
	f_fft = rf_fft * f_smpl

	for f_cut in [5000, 15000] 
		@show f_cut
		rf_cut = f_cut/f_smpl # [rel]
		@show rf_cut

		nf_cut = 2*rf_cut # [rel nyqist]
		@show nf_cut

		
		coefs = digitalfilter(
			Lowpass(nf_cut),
			FIRWindow(
				hamming(
					N_taps-1,
					padding = 1 # To be round.
				)
			)
		)
		
		coefs_fft = fft(coefs)
		coefs_mag = abs.(coefs_fft)
		coefs_phs = rad2deg.(angle.(coefs_fft))


		plot!(
			p_t_domain,
			coefs,
			label = "f_cut = $f_cut Hz, N_taps = $N_taps",
		)

		plot!(
			p_f_domain_amp,
			f_fft/1000,
			coefs_mag[1:L+1],
			label = "f_cut = $f_cut Hz, N_taps = $N_taps",
		)
		plot!(
			p_f_domain_amp_dB,
			f_fft/1000,
			A_to_dB.(coefs_mag[1:L+1]),
			label = "f_cut = $f_cut Hz, N_taps = $N_taps",
		)

		plot!(
			p_f_domain_phs,
			f_fft/1000,
			coefs_phs[1:L+1],
			label = "f_cut = $f_cut Hz, N_taps = $N_taps",
		)
	end
end
gui(p_t_domain)
#gui(p_f_domain_amp)
#gui(p_f_domain_amp_dB)
#gui(p_f_domain_phs)


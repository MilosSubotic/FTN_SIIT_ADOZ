#!/usr/bin/env julia

using Plots
using FFTW
using DSP

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_cut = 250

f_smpl = 1024
T_smpl = 1/f_smpl

@show T_smpl*1e6

t_sig = 0.5

t = collect(0.0:T_smpl:t_sig)[1:end-1]

p_f_domain_amp = plot(
	title = "Freq Amplitude",
	xlabel = "Rel Freq []",
	ylabel = "Amp [V]",
	size = (1000, 800),
)

p_f_domain_phs = plot(
	title = "Freq Phase",
	xlabel = "Freq [Hz]",
	ylabel = "Phase [deg]",
	size = (1000, 800),
)


L = div(length(t), 2)
@show L
rf_fft = range(0.0, 0.5, length = L+1)
f_fft = rf_fft * f_smpl

N_taps = 301
rf_cut = f_cut/f_smpl # [rel]
nf_cut = 2*rf_cut # [rel nyqist]
coefs = digitalfilter(
	Lowpass(nf_cut),
	FIRWindow(
		hamming(
			N_taps-1,
			padding = 1 # To be round.
		)
	)
)

for f in [200, 300]
	y = sin.(2π*t*f)

	y = conv(y, coefs)
	y = y[N_taps:end]

	rf = f / f_smpl

	global y_fft
	y_fft = fft(y)
	y_mag = abs.(y_fft)
	y_phs = rad2deg.(angle.(y_fft))


	plot!(
		p_f_domain_amp,
		rf_fft,
		y_mag[1:L+1],
		label = "f=$f Hz  rf = $rf",
	)

	plot!(
		p_f_domain_phs,
		f_fft,
		y_phs[1:L+1],
		label = "f=$f Hz  rf = $rf",
	)

end
#gui(p_t_domain)
gui(p_f_domain_amp)
#gui(p_f_domain_phs)


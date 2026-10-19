#!/usr/bin/env julia

using Plots
using FFTW
using DSP

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_smpl = 1024
T_smpl = 1/f_smpl

@show T_smpl*1e6

t_sig = 0.5
fs = [64, 128, 256, 512, 512+256]
markers = [:o, :diamond, :+, :rect, :x,]
markersize = [8, 6, 10, 4, 10]

p_t_domain = plot(
	title = "Time domain",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
	ylim = [-1.2, 1.2],
	size = (1000, 800),
)
N = 16

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

#for i in 1:length(fs)
for i in [3, 5] 
	f = fs[i]
	y = sin.(2π*t*f)

	rf = f / f_smpl

	global y_fft
	y_fft = fft(y)
	y_mag = abs.(y_fft)
	y_phs = rad2deg.(angle.(y_fft))


	scatter!(
		p_t_domain,
		t[1:N+1]*1e3,
		y[1:N+1], 
		label = "f=$f Hz  rf = $rf",
		marker = markers[i],
		markersize = markersize[i],
	)


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
gui(p_t_domain)
#gui(p_f_domain_amp)
gui(p_f_domain_phs)


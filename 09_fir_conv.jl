#!/usr/bin/env julia

using Plots
using FFTW
using DSP

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_cut = 25

f_smpl = 1000
T_smpl = 1/f_smpl

@show T_smpl*1e6

t_sig = 0.5

t = collect(0.0:T_smpl:t_sig)[1:end-1]


p_t_domain = plot(
	title = "Time domain",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
	#ylim = [-1.2, 1.2],
	size = (1000, 800),
)

p_f_domain_amp = plot(
	title = "Freq Amplitude",
	xlabel = "Freq [Hz]",
	ylabel = "Amp [V]",
	size = (1000, 800),
)


L = div(length(t), 2)
@show L
rf_fft = range(0.0, 0.5, length = L+1)
f_fft = rf_fft * f_smpl

N_taps = 201
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

M = 300

function my_conv(sig::Vector{Float64}, coefs::Vector{Float64})
	N_taps = length(coefs)

	buf = zeros(Float64, N_taps)
	function fir_iter(sample)
		pushfirst!(buf, sample)
		pop!(buf)
		@assert length(buf) == N_taps

		acc = 0.0
		for i in 1:N_taps
			acc += buf[i]*coefs[end+1-i]
		end
		return acc
	end


	out = Float64[]

	for sample in sig
		out_sample = fir_iter(sample)
		push!(out, out_sample)
	end

	return out
end

for f in [20, 30]
	y_src = sin.(2π*t*f)

	#y_filtered = conv(y_src, coefs)
	y_filtered = my_conv(y_src, coefs)

	y_cut = y_filtered[N_taps:end]

	rf = f / f_smpl

	global y_fft
	y_fft = fft(y_cut)
	y_mag = abs.(y_fft)
	y_phs = rad2deg.(angle.(y_fft))


	#plot!(
	#	p_t_domain,
	#	y_src[1:M],
	#	label = "src f=$f Hz  rf = $rf",
	#)
	plot!(
		p_t_domain,
		#y_cut[1:M],
		y_filtered[1:M],
		label = "filtered f=$f Hz  rf = $rf",
	)


	plot!(
		p_f_domain_amp,
		f_fft,
		y_mag[1:L+1],
		label = "f=$f Hz  rf = $rf",
	)

end
gui(p_t_domain)
#gui(p_f_domain_amp)


#!/usr/bin/env julia

using Plots

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_smpl = 1024
T_smpl = 1/f_smpl

@show T_smpl*1e6

t_sig = 1.0
fs = [64, 128, 256, 512, 512+256]
markers = [:o, :diamond, :+, :rect, :x,]
markersize = [8, 6, 10, 4, 10]

p = plot(
	title = "Signal",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
	ylim = [-1.2, 1.2],
	size = (1000, 800),
)
N = 16

t = collect(0.0:T_smpl:t_sig)
for i in 1:length(fs)
#for i in [3, 5] 
	f = fs[i]
	y = sin.(2π*t*f)

	rf = f / f_smpl

	scatter!(
		p,
		t[1:N+1]*1e3,
		y[1:N+1], 
		label = "f=$f Hz  rf = $rf",
		marker = markers[i],
		markersize = markersize[i],
	)
end
gui(p)


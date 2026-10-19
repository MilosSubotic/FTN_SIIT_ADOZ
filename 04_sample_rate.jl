#!/usr/bin/env julia

using Plots

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_smpl = 1024
T_smpl = 1/f_smpl

@show T_smpl*1e6

t_sig = 1.0
f_sig = 512.0

t = collect(0.0:T_smpl:t_sig)
y_sig = sin.(2π*t*f_sig)

p = plot(
	title = "Signal",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
	ylim = [-1.2, 1.2],
)
N = 16
scatter!(p, t[1:N+1]*1e3, y_sig[1:N+1], label = "y_sig")
gui(p)



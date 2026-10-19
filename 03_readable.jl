#!/usr/bin/env julia

using Plots

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

f_smpl = 48e3
T_smpl = 1/f_smpl

t_sig = 1.0
f_sig = 20.0

t = collect(0.0:T_smpl:t_sig)
y_1Hz = sin.(2π*t)
y_2Hz = sin.(2π*t*2)
y_sig = sin.(2π*t*f_sig)

p = plot(
	title = "Signal",
	xlabel = "Time [ms]",
	ylabel = "Amp [V]",
)
N = 2400
STEP = 100
scatter!(p, t[1:STEP:N]*1e3, y_1Hz[1:STEP:N], label = "y_1Hz")
scatter!(p, t[1:STEP:N]*1e3, y_2Hz[1:STEP:N], label = "y_2Hz")
scatter!(p, t[1:STEP:N]*1e3, y_sig[1:STEP:N], label = "y_sig $f_sig Hz")
gui(p)



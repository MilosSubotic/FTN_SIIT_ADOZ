#!/usr/bin/env julia

function fun(x)
	println("any x = ", x)
end

function fun(x::Int)
	println("int x = ", x)
end

fun("asdf")
fun(1)


v = [1, 2, 3]
m = [
	1 2
	3 4
]

using Plots


x = collect(1:10)
y1 = 2*x
y2 = 2*x .+ 1
y3 = x.^2 .+ 1


p = plot(
	title = "Signal",
	xlabel = "Time [s]",
	ylabel = "Amp [V]",
)
plot!(p, x, y1, label = "y1 = 2*x")
plot!(p, x, y2, label = "2*x .+ 1")
scatter!(p, x, y3, label = "x.^2 .+ 1")
gui(p)


t = collect(0.0:0.25:1.0)
angle_deg = 360*t
angle_rad = deg2rad.(angle_deg)
y_1Hz = sin.(angle_rad)

p = plot(
	title = "Signal",
	xlabel = "Time [s]",
	ylabel = "Amp [V]",
)
scatter!(p, t, y_1Hz, label = "y_1Hz")
gui(p)

N = 100
t = collect(0.0:(1.0/N):1.0)
angle_deg = 360*t
angle_rad = deg2rad.(angle_deg)
y_1Hz = sin.(angle_rad)

p = plot(
	title = "Signal",
	xlabel = "Time [s]",
	ylabel = "Amp [V]",
)
scatter!(p, t, y_1Hz, label = "y_1Hz")
gui(p)


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
	xlabel = "Time [s]",
	ylabel = "Amp [V]",
)
N = 2400
scatter!(p, t[1:N], y_1Hz[1:N], label = "y_1Hz")
scatter!(p, t[1:N], y_2Hz[1:N], label = "y_2Hz")
scatter!(p, t[1:N], y_sig[1:N], label = "y_sig $f_sig Hz")
gui(p)




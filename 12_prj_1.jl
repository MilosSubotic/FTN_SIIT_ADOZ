#!/usr/bin/env julia

using Plots
using FFTW
using DSP
using WAV

# Audio: 20Hz - 20kHz
# sample rate: 44.1kHz 48kHz

y, f_smpl = wavread("data/1.wav")

wavplay(y, f_smpl)


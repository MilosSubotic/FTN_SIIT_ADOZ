#!/usr/bin/env julia

import Pkg

function install_if_not_installed(pkgs::Vector{String})
	deps = Pkg.dependencies()
	#all_pkgs = String[dep.name for dep in values(deps)]
	installed_pkgs = String[
		dep.name for dep in values(deps)
			if dep.is_direct_dep && dep.version !== nothing
	]
	for pkg in pkgs
		if !(pkg in installed_pkgs)
			println("Installing $pkg...")
			Pkg.add(pkg)
		end
	end
end

install_if_not_installed(
	[
		"ArgParse", "Reexport",
		"Plots", "PyPlot", #"Plotly",
		"CSV", "DataFrames",
		"DSP", "FFTW",
		"LsqFit",
		"NPZ",
		"StaticArrays",
	]
)

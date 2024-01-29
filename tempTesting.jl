using CSV
using DelimitedFiles
using DataFrames
using Plots
using Debugger

include("src/MERIT.jl")


# TESTING CODE BELOW HERE
println(pwd())
plotlyjs()
frequencies = readdlm("data/frequencies.csv", ',', Float64)
antennalocations = readdlm("data/antenna_locations.csv", ',', Float64)
channelnames = readdlm("data/channel_names.csv", ',', Int64)
scan1 = readdlm("data/B0_P3_p000.csv", ',', ComplexF64)
scan2 = readdlm("data/B0_P3_p036.csv", ',', ComplexF64)

signal = scan1 - scan2
points, axes = MERIT.domain_hemisphere(2.5e-3, 7e-2)
timeDelays = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, points)
image = abs.(MERIT.Beamform.beamform(signal, frequencies, points, timeDelays))
imageSlice = MERIT.Visualize.get_slice(image, points, 35e-3, axes)
graphHandle = heatmap(axes[1], axes[2], imageSlice, colorscale="Viridis")
gui(graphHandle)
readline()
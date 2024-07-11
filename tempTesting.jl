using CSV
using DelimitedFiles
using DataFrames
using Plots
using Debugger
using MAT
using Profile
using PProf
using BenchmarkTools
using PlotlyJS

include("src/MERIT.jl")


# TESTING CODE BELOW HERE

function testing()
    plotlyjs()
    frequencies = readdlm("data/frequencies.csv", ',', Float64, use_mmap=true)
    antennalocations = readdlm("data/antenna_locations.csv", ',', Float64, use_mmap=true)
    channelnames = readdlm("data/channel_names.csv", ',', Int64, use_mmap=true)
    scan1 = readdlm("data/B0_P3_p000.csv", ',', ComplexF64, use_mmap=true)
    scan2 = readdlm("data/B0_P3_p036.csv", ',', ComplexF64, use_mmap=true)

    signal = scan1 .- scan2
    points, axesPlot = MERIT.domain_hemisphere(2.5e-3, 7e-2+5e-3)
    timeDelays = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, points)
    
    println(size(timeDelays))
    
    image = abs.(MERIT.Beamform.beamform(signal, frequencies, points, timeDelays))
    imageSlice = MERIT.Visualize.get_slice(image, points, 35e-3, axesPlot)
    println(size(imageSlice))
    graphHandle = heatmap(axesPlot[1], axesPlot[2], imageSlice, colorscale="Viridis")
    Base.invokelatest(display, graphHandle)
    readline()
end
include("MERIT.jl")
include("Process.jl")
using BenchmarkTools
using DelimitedFiles

antennalocations = readdlm("data/antenna_locations.csv", ',', Float64, use_mmap=true)
channelnames = readdlm("data/channel_names.csv", ',', Int64, use_mmap=true)
scan1 = readdlm("data/B0_P3_p000.csv", ',', ComplexF64, use_mmap=true)
scan2 = readdlm("data/B0_P3_p036.csv", ',', ComplexF64, use_mmap=true)
frequencies = readdlm("data/frequencies.csv", ',', Float64, use_mmap=true)
signal = scan1 .- scan2
points, axes = MERIT.domain_hemisphere(2.5e-3, 7e-2+5e-3)
timeDelays = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, points)

function testfnc(signal, delay, frequencies)
    Process.delay_signal(signal, delay, frequencies)
end

testfnc(signal, timeDelays, frequencies)
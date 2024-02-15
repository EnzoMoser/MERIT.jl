using MERIT
using BenchmarkTools
using Profile
using PProf

# function testfnc(signal, frequencies, points, timeDelays)
#     image = abs.(MERIT.Beamform.beamform(signal, frequencies, points, timeDelays))
# end

scan = BreastScan{Float32, ComplexF32, UInt32}()
domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3, Float32)
load_scans!(scan,"data/B0_P3_p000.csv" , "data/B0_P3_p036.csv", ',', ComplexF32)
load_frequencies!(scan, "data/frequencies.csv", ',', Float32)
load_antennas!(scan, "data/antenna_locations.csv", ',', Float32)
load_channels!(scan, "data/channel_names.csv", ',', UInt32)
scan.delayFunc = get_delays(Float32(8.0))
scan.beamformerFunc = DAS
image = abs.(beamform(scan))
imageSlice = get_slice(image, scan, 35e-3)
println(size(imageSlice))
plot_scan(imageSlice, scan)

# Profile.Allocs.clear()
# Profile.Allocs.@profile sample_rate=0.1 testfnc(signal, frequencies, points, timeDelays)
# PProf.Allocs.pprof(from_c = false)
using Plots
using MERIT

plotlyjs()
scan = BreastScan{Float32, ComplexF32, UInt32}()
domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3)
load_scans!(scan,"data/B0_P3_p000.csv" , "data/B0_P3_p036.csv", ',')
load_frequencies!(scan, "data/frequencies.csv", ',')
load_antennas!(scan, "data/antenna_locations.csv", ',')
load_channels!(scan, "data/channel_names.csv", ',')
scan.delayFunc = get_delays(Float32(8.0))
scan.beamformerFunc = DAS
image = abs.(beamform(scan))
imageSlice = get_slice(image, scan, 35e-3)
graphHandle = heatmap(scan.axes[1], scan.axes[2], imageSlice, colorscale="Viridis")
savefig(graphHandle, "GettingStarted.png")


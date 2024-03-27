using MERIT
using BenchmarkTools

function testing(scan)
    scan.delayFunc = get_delays(Float32(8.0))
    scan.beamformerFunc = DAS
    imgCom = beamform(scan)
end


suite = BenchmarkGroup()

# for a in 2:50:852
#     antenna_locations = genAntennaLocations(a, 4, Float64)
#     channelNames = genChannelNames(a, 4, "monostatic", Int64)
#     frequencies = genFrequencies(1.5, 4.5, 76, Float64)
#     scan_data = genRandomData(length(frequencies), size(channelNames, 1), ComplexF64)
   
#     scan = BreastScan{Float64, ComplexF64, Int64}()
#     scan.signal = scan_data
#     scan.frequencies = frequencies
#     scan.channels = channelNames
#     scan.antennas = antenna_locations
#     domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3)
#     suite["antennas"][string(a)] = @benchmarkable testing($scan) evals=1 samples=10 seconds=30
# end


# for p in 1:12500:200000
#     antenna_locations = genAntennaLocations(6, 4, Float64)
#     channelNames = genChannelNames(6, 4, "leveled-half-multistatic-minus-self", UInt64)
#     frequencies = genFrequencies(1.5, 4.5, 76, Float64)
#     scan_data = genRandomData(length(frequencies), size(channelNames, 1), ComplexF64)
   
#     scan = BreastScan{Float64, ComplexF64, UInt64}()
#     scan.signal = scan_data
#     scan.frequencies = frequencies
#     scan.channels = channelNames
#     scan.antennas = antenna_locations
#     scan.points = rand(Point3{Float64}, p)
#     suite["points"][string(p)] = @benchmarkable testing($scan) evals=1 samples=10 seconds=30
# end

for f in 2:10:1000
    antenna_locations = genAntennaLocations(6, 4, Float64)
    channelNames = genChannelNames(6, 4, "leveled-half-multistatic-minus-self", UInt64)
    frequencies = genFrequencies(1.5, 4.5, f, Float64)
    scan_data = genRandomData(length(frequencies), size(channelNames, 1), ComplexF64)
   
    scan = BreastScan{Float64, ComplexF64, UInt64}()
    scan.signal = scan_data
    scan.frequencies = frequencies
    scan.antennas = antenna_locations
    scan.channels = channelNames
    domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3)
    suite["frequency"][string(f)] = @benchmarkable testing($scan) evals=1 samples=10 seconds=30
end

BenchmarkTools.save("frequencyParams.json", params(suite))
result = run(suite, verbose=true)
BenchmarkTools.save("frequencyResults.json", result)
using MERIT
using Test
using DelimitedFiles
using MAT

@testset "MERIT.jl" begin
    # Write your tests here.
    println(pwd())
    antennalocations = readdlm("../data/antenna_locations.csv", ',', Float64)
    channelnames = readdlm("../data/channel_names.csv", ',', Int64)
    pointsTRUTH  = matread("../data/tests/points.mat")["points"]
    timesTRUTH   = matread("../data/tests/time.mat")["time"]
    timesTEST    = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, pointsTRUTH)
    
    #Do the sizes match
    @test size(timesTRUTH) == size(timesTEST)

    #Do the elements match
    @test timesTRUTH == timesTEST
end

using MERIT
using Test
using DelimitedFiles
using MAT

@testset "MERIT.jl" begin
    # Write your tests here.
    #TODO Write test for Beamform.get_delays()
    antennalocations = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/antenna_locations.csv", ',', Float64)
    channelnames = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/channel_names.csv", ',', Int64)
    pointsTRUTH  = matread("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/tests/points.mat")["points"]
    timesTRUTH   = matread("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/tests/time.mat")["time"]
    timesTEST    = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, pointsTRUTH)
    
    #Do the sizes match
    @test size(timesTRUTH) == size(timesTEST)

    #Do the elements match
    @test timesTRUTH == timesTEST
end

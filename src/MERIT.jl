module MERIT

#TODO Impliment DAS (delay and sum)
#       Use DataFrames to avoid the time it takes to convert to vector.

include("./Beamform.jl")
using CSV
using DelimitedFiles
using DataFrames
using Plots
using MAT

#Abstract type for the type heirarchy
#All scan types should be a subtype of Scans
abstract type Scans end

mutable struct BreastScans <: Scans
    #Holds all the info for the breast scans
    
    #DataFrame to hold the data from each scan
    scan::DataFrame
end

export Scans, BreastScans


"A function to return the points of a hemisphere
    resolution: The resolution for each axis. A tuple in the format XYZ
    radius    : The radius of the hemisphere
    
Returns a vector of vectors in the format vec{xpoints, ypoints, zpoints}"
function domainHemisphere(resolution::Float64, radius::Float64)
    points = [[],[],[]]
    for x in -radius:resolution:radius
        for y in -radius:resolution:radius
            for z in -radius:resolution:0
                if(x^2 + y^2 + z^2 <= radius^2)
                    push!(points[1], x)
                    push!(points[2], y)
                    push!(points[3], z + radius) 
                end
            end
        end
    end
    return Float64.(stack((points[1], points[2], points[3]); dims=2))
end



# TESTING CODE BELOW HERE
frequencies = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/frequencies.csv", ',', Float64)
antennalocations = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/antenna_locations.csv", ',', Float64)
channelnames = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/channel_names.csv", ',', Int64)
scan1 = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/B0_P3_p000.csv", ',', ComplexF64)
scan2 = readdlm("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/B0_P3_p036.csv", ',', ComplexF64)
timesTRUTH  = matread("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/tests/time.mat")["time"]
pointsTRUTH = matread("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/tests/points.mat")["points"]
points = domainHemisphere(2.5e-3, 7e-2)

timesTEST = Beamform.get_delays(channelnames, antennalocations, 8.0, pointsTRUTH)
println(size(timesTEST))
println(size(timesTRUTH))
println(sum(reshape(timesTEST .== timesTRUTH, (1,:))))
# plotlyjs()
# display(plot(scatter(points[:,1], points[:,2], points[:,3])))
# println("Plotted plot")
# readline()
end

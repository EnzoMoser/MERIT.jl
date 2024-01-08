module MERIT

#TODO Impliment DAS (delay and sum)
#       Use DataFrames to avoid the time it takes to convert to vector.


using CSV
using DataFrames
using Plots

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
function domainHemisphere(resolution::tuple{Float64}, radius::Float64)
    points = Vector{Tuple{Float64,Float64,Float64}}()
    for x in -radius:resolution:radius
        for y in -radius:resolution:radius
            for z in 0:resolution:radius
                if(x^2 + y^2 + z^2 <= radius)
                    append!(points, (x,y,z))
                end
            end
        end
    end
    return points
end



# TESTING CODE BELOW HERE
frequencies = CSV.read("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/frequencies.csv", DataFrame)
antennalocations = CSV.read("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/antenna_locations.csv", DataFrame)
channelnames = CSV.read("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/antenna_locations.csv", DataFrame)
scan1 = CSV.read("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/B0_P3_p000.csv", DataFrame)
scan2 = CSV.read("/mnt/c/Users/aaron/Desktop/Coding/MERIT/data/B0_P3_p036.csv", DataFrame)








end

using Combinatorics

function genAntennaLocations(num_points::Integer, T)
    pointsVec = Point3{T}[]
    ϕ = π * (sqrt(5) - 1)
    for i in 1:num_points
        y = 1 - (i/(num_points-1))
        radius = sqrt(1-y^2)
        θ = ϕ * i
        x = cos(θ) * radius
        z = sin(θ) * radius
        
        push!(pointsVec, Point3{T}(x, z, y))
    end
    return pointsVec
end


function genChannelNames(num_antennas::Integer, setup::String, T::Integer)
    if num_antennas <= 0
        throw(DomainError("The number of antennas must be a positive Integer"))
    end

    if setup == "multistatic"
        return T.(collect(permutations(1:num_antennas, 2)))
    else if setup == "half-multistatic"
        return T.(collect(combinations(1:num_antennas, 2)))
    else if setup == "monostatic" 
        channelsMatrix = zeros(T, num_antennas, 2)
        channelsMatrix[:, 1] = [x for x in 1:num_antennas]
        channelsMatrix[:, 2] = [x for x in 1:num_antennas]
    else
        throw(DomainError("Unknown setup. The options are 'multistatic', 'half-multistatic' or 'monostatic''"))
    end
end

function genFrequencies(num_frequencies::Integer, T)
    return round.(round.(rand(T, num_frequencies, 1); digits=2)*10e9, digits=2)
end


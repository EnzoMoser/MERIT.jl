using Combinatorics

# function genAntennaLocations(num_points::Integer, T)
#     pointsvec = point3{t}[]
#     ϕ = π * (sqrt(5) - 1)
#     for i in 1:num_points
#         y = 1 - (i/(num_points-1))
#         radius = sqrt(1-y^2)
#         θ = ϕ * i
#         x = cos(θ) * radius
#         z = sin(θ) * radius
        
#         push!(pointsvec, point3{t}(x, z, y))
#     end
#     return pointsvec
# end

function genAntennaLocations(antennas_per_level::Integer, num_levels::Integer, T::DataType)
    pointsVec = Point3{T}[]
    Δθ = 2π / antennas_per_level
    for z in 0:1/num_levels:1-(1/num_levels)
        radius = sqrt(1-(z^2))
        for θ in 0:Δθ:2π - Δθ
            push!(pointsVec, Point3{T}(radius*cos(θ), radius*sin(θ), z))
        end
    end

    return pointsVec
end

function genChannelNames(antennas_per_level::Integer, num_levels::Integer, setup::String, T::DataType)
    if antennas_per_level*num_levels <= 0
        throw(DomainError("The number of antennas must be a positive Integer"))
    end

    if setup == "multistatic"
        permutations_per_level = permutations(1:antennas_per_level, 2)
        num_permutations_per_level = length(permutations_per_level)
        channelNames = zeros(T, num_permutations_per_level*num_levels, 2)
        for i in 1:num_levels
            channelNames[1+num_permutations_per_level*(i-1):num_permutations_per_level+num_permutations_per_level*(i-1), :] .= reduce(vcat, transpose.(collect(permutations_per_level))) .+ antennas_per_level*(i-1)
        end
        
        return channelNames
    elseif setup == "half-multistatic"
        combinations_per_level = combinations(1:antennas_per_level, 2)
        num_combinations_per_level = length(combinations_per_level)
        channelNames = zeros(T, length(combinations_per_level)*num_levels, 2)

        for i in 1:num_levels
            channelNames[1+num_combinations_per_level*(i-1):num_combinations_per_level+num_combinations_per_level*(i-1), :] .= reduce(vcat, transpose.(collect(combinations_per_level))) .+ antennas_per_level*(i-1)
        end

        return channelNames
    elseif setup == "monostatic" 
        channelNames = zeros(T, antennas_per_level*num_levels, 2)
        channelsNames[:, 1] = [x for x in 1:antennas_per_level*num_levels]
        channelsNames[:, 2] = [x for x in 1:antennas_per_level*num_levels]
        return channelNames
    else
        throw(DomainError("Unknown setup. The options are 'multistatic', 'half-multistatic' or 'monostatic''"))
    end
end

function genFrequencies(num_frequencies::Integer, T::DataType)
    return round.(round.(rand(T, num_frequencies, 1); digits=2)*10e9, digits=2)
end

function genRandomData(num_frequencies::Integer, num_channels::Integer, T::DataType)
    return rand(T, num_frequencies, num_channels)
end
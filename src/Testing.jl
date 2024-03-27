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

    
    if setup == "leveled-multistaic"
        # This includes the transmitting antenna. So if 1 transmits, (1,1) will be a channel.
        # Leveled assumes that the antennae are along a circle in the horizontal plane and these antenna move down 
        idx = 1
        for i in 1:num_levels
            for j in 1:antennas_per_level
                for k in 1:antennas_per_level
                    channelNames[idx, 1] = j + antennas_per_level*(i-1)
                    channelNames[idx, 2] = k + antennas_per_level*(i-1)
                    idx+=1
                end
            end
        end
    elseif setup == "leveled-multistatic-minus-self"
        # This excludes the transmitting antenna. So if 1 transmits, (1,1) will never be channel
        # Leveled assumes that the antennae are along a circle in the horizontal plane and these antenna move down 
        permutations_per_level = permutations(1:antennas_per_level, 2)
        num_permutations_per_level = length(permutations_per_level)
        channelNames = zeros(T, length(permutations_per_level)*num_levels, 2)

        for i in 1:num_levels
            channelNames[1+num_permutations_per_level*(i-1):num_permutations_per_level+num_permutations_per_level*(i-1), :] .= reduce(vcat, transpose.(collect(permutations_per_level))) .+ antennas_per_level*(i-1)
        end
        
        return channelNames
    elseif setup == "leveled-half-multistatic-minus-self"
        # This excludes the transmitting anntenna and identical channel paths. So if (1, 2) is a channel, (2, 1) wont be a channel
        # Leveled assumes that the antennae are along a circle in the horizontal plane and these antenna move down 
        combinations_per_level = combinations(1:antennas_per_level, 2)
        num_combinations_per_level = length(combinations_per_level)
        channelNames = zeros(T, length(combinations_per_level)*num_levels, 2)

        for i in 1:num_levels
            channelNames[1+num_combinations_per_level*(i-1):num_combinations_per_level+num_combinations_per_level*(i-1), :] .= reduce(vcat, transpose.(collect(combinations_per_level))) .+ antennas_per_level*(i-1)
        end

        return channelNames
    elseif setup == "multistatic"
        #This inlcudes the transmitting antenna, but also considers all antennas around the setup as receivers
        channelNames = zeros(T, (antennas_per_level*num_levels)^2, 2)
        idx = 1
        for i in 1:antennas_per_level*num_levels
            for j in 1:antennas_per_level*num_levels  
                    channelNames[idx, 1] = j
                    channelNames[idx, 2] = k
                    idx+=1
            end
        end
    elseif setup == "multistaic-minus-self"
        # This excludes the transmitting antenna. So if 1 transmits, (1,1) will never be channel
        # This considers all antennae in the setup as receivers
        permutations_for_full_set = permutations(1:antennas_per_level*num_levels, 2)
        num_permutations_for_full_set = length(permutations_for_full_set)
        channelNames = zeros(T, num_permutations_for_full_set, 2)
        channelNames[:, :] = reduce(vcat, transpose.(collect(permutations_for_full_set)))
        return channelNames

    elseif setup == "half-multistatic-minus-self"
        combinations_half_multistatic = combinations(1:antennas_per_level*num_levels, 2)
        return T.(reduce(vcat, transpose.(collect(combinations_half_multistatic))))
    elseif setup == "monostatic" 
        channelNames = zeros(T, antennas_per_level*num_levels-num_levels, 2)
        channelNames[:, 1] = [x for x in 1:antennas_per_level*num_levels-num_levels]
        channelNames[:, 2] = [x for x in 1:antennas_per_level*num_levels-num_levels]
        return channelNames
    else
        throw(DomainError("Unknown setup option"))
    end
end

function genFrequencies(min_frequency, max_frequency, num_frequencies::Integer, T::DataType)
    # 1-8 GHz was chosen since it seems to encompass most systems 
    return reshape(collect(min_frequency:((max_frequency-min_frequency)/num_frequencies):max_frequency).*10^9, :, 1) 
end

function genRandomData(num_frequencies::Integer, num_channels::Integer, T::DataType)
    return rand(T, num_frequencies, num_channels)
end
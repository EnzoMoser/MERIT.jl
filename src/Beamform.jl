module Beamform
    include("./Beamformer.jl")
    include("./Process.jl")

    # Deprecated get_delays function. This function was replaced with the one below. The one below uses
    # broadcasting and is therefore slightly faster than this implimentation here.
    function get_delays_deprecated(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Matrix{Float64})
        
        if relative_permittivity <= 0
            throw(DomainError(relative_permittivity, "The relative permittivity cannot 0 or less than 0"))
        end
        
        c_0::Float64 = 299792458.0
        speed = c_0 / sqrt(relative_permittivity)
        
        #Reshaping and transposing to allow the element-wise operations later on
        #to execute appropriately
        antenna = antenna'
        points = reshape(transpose(points), (3, 1, :))

        #These distances will be of the form [dist to antenna 1, dist to antenna 2, ..., dist to antenna N] x numPoints
        #So it'll be the distances from a point to all antennas. Size of (1 x numAntennas x numPoints)
        distances = sqrt.(sum((antenna .- points) .^ 2, dims=1))

        #The time taken to pass through the medium is the distance from the sending antenna
        #to the point, plus the distance from the point to the receving antenna, divided by the speed.
        #Since the medium introduces a delay of +t seconds, we need to add a delay of -t seconds
        #to reverse the delay. 
        #Size of (1 x channelNamesLength x NumPoints).
        time = -((distances[:, channel[:,1], :] + distances[:, channel[:,2], :]) ./ speed)
        return time
    end


    function get_delays(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Matrix{Float64})
        
        if relative_permittivity <= 0
            throw(DomainError(relative_permittivity, "The relative permittivity cannot 0 or less than 0"))
        end
        
        c_0::Float64 = 299792458.0

        #Base.sqrt_llvm is funtionally similar to sqrt. (sqrt calls sqrt_llvm after performing a check for negative numbers)
        #To avoid this check, I used sqrt_llvm since I already check that relative_permittivity is positive in the above check.
        #There might be some potential sppedups due to SIMD being possible with sqrt_llvm but not sqrt.
        #This is the forum post where I found the info: https://discourse.julialang.org/t/sqrt-abs-x-is-even-faster-than-sqrt/58154/4
        speed = c_0 / Base.sqrt_llvm(relative_permittivity)
        
        #These distances will be of the form [dist to antenna 1, dist to antenna 2, ..., dist to antenna N] x numPoints
        #So it'll be the distances from a point to all antennas. Size of (1 x numAntennas x numPoints)
        distances = zeros(Float64, 1, size(antenna, 1), size(points, 1))
        
        time = zeros(Float64, 1, size(channel, 1), size(points, 1))
        pointsAntennaDifferences = zeros(Float64, 3, size(antenna, 1), size(points, 1))
        
        #Reshaping and transposing to allow the element-wise operations later on
        #to execute appropriately
        antenna = antenna'
        points = reshape(transpose(points), (3, 1, :))
         
        pointsAntennaDifferences .= (antenna .- points) .^ 2
        
        for j in 1:size(points, 3)
            for i in 1:size(antenna, 2)
                @inbounds distances[1, i, j] = pointsAntennaDifferences[1, i, j] + pointsAntennaDifferences[2, i, j] + pointsAntennaDifferences[3, i, j]
            end
        end

        distances .= Base.sqrt_llvm.(distances)

        #The time taken to pass through the medium is the distance from the sending antenna
        #to the point, plus the distance from the point to the receving antenna, divided by the speed.
        #Since the medium introduces a delay of +t seconds, we need to add a delay of -t seconds
        #to reverse the delay. 
        #Size of (1 x channelNamesLength x NumPoints).
        time .= .-((distances[:, channel[:,1], :] .+ distances[:, channel[:,2], :]) ./ speed)
        return time
    end

    function beamform(signals, frequencies, points, delays)
        #TODO: Change this function to accept a function handle to any beamformer
        
        #Images are stored along the first dimension. The second dimension stores the same images but with different delay parameters.
        #We vary the delay parameter by changing the relative_permittivity. The third and futher dimensions can store multiple scans
        #for batch processing. 
        #For simplicity's sake we only use one delay for now and one scan.  
        image = zeros(ComplexF64, (size(points, 1), 1, 1))
        delayedSignals = zeros(ComplexF64, size(frequencies, 1), size(signals, 2), 1)
        
        for pointsIdx in range(1, size(points, 1))
            Process.delay_signal!(delayedSignals ,signals, delays[:, :, pointsIdx], frequencies)
            @inbounds image[pointsIdx, 1, 1] = Beamformer.DAS(delayedSignals)
        end

        return image
    end

end



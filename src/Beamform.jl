module Beamform
    include("./Beamformer.jl")
    include("./Process.jl")

    function get_delays(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Matrix{Float64})
        c_0::Float64 = 299792458.0
        speed = c_0 /  sqrt(relative_permittivity)
        
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
        println(size(time))
        return time
    end

    function beamform(signals, frequencies, points, delays)
        #TODO: Change this function to accept a function handle to any beamformer
        
        #Images are stored along the first dimension. The second dimension stores the same images but with different delay parameters.
        #We vary the delay parameter by changing the relative_permittivity. The third and futher dimensions can store multiple scans
        #for batch processing. 
        #For simplicity's sake we only use one delay for now and one scan.  
        image = zeros(ComplexF64, (size(points, 1), 1, 1))

        for pointsIdx in range(1, size(points, 1))
            image[pointsIdx, 1, :] = Beamformer.DAS(Process.delay_signal(signals, delays[:, :, pointsIdx], frequencies))[:,1,1] 
        end

        return image
    end

end
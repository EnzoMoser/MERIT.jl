module Beamform

function get_delays(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Matrix{Float64})
    c_0::Float64 = 299792458.0
    speed = c_0 /  sqrt(relative_permittivity)
    
    #Reshaping and transposing to allow the element-wise operations later on
    #to execute appropriately
    antenna = antenna'
    points = reshape(transpose(points), (3, 1, :))

    #These distances will be of the form [dist to antenna 1, dist to antenna 2, ..., dist to antenna 24] x NumPoints
    #So it'll be the distances from a point to all antennas. Size of (1 x 24 x NumPoints)
    distances = sqrt.(sum((antenna .- points) .^ 2, dims=1))

    #The time taken to pass through the medium is the distance from the sending antenna
    #to the point, plus the distance from the point to the receving antenna, divided by the speed.
    #This is the delay
    time = -((distances[:, channel[:,1], :] + distances[:, channel[:,2], :]) ./ speed)
    return time
end

end
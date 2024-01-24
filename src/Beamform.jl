module Beamform

function get_delays(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Matrix{Float64})
    c_0::Float64 = 299792458.0
    speed = c_0 /  sqrt(relative_permittivity)
    antenna = antenna'
    points = reshape(transpose(points), (3, 1, :))
    distances = sqrt.(sum((antenna .- points) .^ 2, dims=1))
    time = -((distances[:, channel[:,1], :] + distances[:, channel[:,2], :]) ./ speed)
    return time
end

end
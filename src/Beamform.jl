module Beamform

function get_delays(channel, antenna::Matrix{Float64}, relative_permittivity::Float64, points::Vector{Float64})
    c_0::Float64 = 299792458.0
    speed = c_0 /  relative_permittivity

    #IMPORTANT
    # points should be a vector while antenna should be a matrix
    permuted_points = zeros(Float64, size(points))
    permutedims!(permuted_points, points, (2,3,1))
    distances = sqrt.(sum((antenna .- permuted_points') .^ 2, dims=2))
end

end
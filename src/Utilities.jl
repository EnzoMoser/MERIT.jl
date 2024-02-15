function add_dim(x)
    return reshape(x, (size(x)..., 1))
end

"A function to return the points of a hemisphere
resolution: The resolution for the axes
radius    : The radius of the hemisphere

Returns a Nx3 matrix where N is the number of points produced. Also returns the axes as a range type."
#!THIS FUNCTION IS DEPRECATED in favor of the one below. Use that instead
function domain_hemisphere(resolution::Real, radius::Real, dtype)
    
    if radius <= 0.0
        throw(DomainError(radius, "The radius cannot be 0 or negative"))
    end
    
    if resolution <= 0.0
        throw(DomainError(resolution, "The resolution cannot be 0 or negative"))
    end        
    
    if resolution >= 2*radius
        error("The resolution cannot be greater than 2*radius")
    end
    
    points = Vector[dtype[], dtype[], dtype[]]
    
    #Check the numbers of 1s in the matlab
    for x in -dtype(radius):dtype(resolution):dtype(radius)
        for y in -dtype(radius):dtype(resolution):dtype(radius)
            for z in dtype(0):dtype(resolution):dtype(radius)
                if(x^2 + y^2 + z^2 <= radius^2)
                    push!(points[1], x)
                    push!(points[2], y)
                    push!(points[3], z)
                end
            end
        end
    end
    return stack((points[1], points[2], points[3]); dims=2), (-dtype(radius):dtype(resolution):dtype(radius), -dtype(radius):dtype(resolution):dtype(radius), dtype(0):dtype(resolution):dtype(radius))
end

function domain_hemisphere!(scan::BreastScan{T, Y, Z}, resolution::Real, radius::Real) where {T <: Real, Y <: Number, Z <:Integer}
    if radius <= 0.0
        throw(DomainError(radius, "The radius cannot be 0 or negative"))
    end

    if resolution <= 0.0
        throw(DomainError(resolution, "The resolution cannot be 0 or negative"))
    end        

    if resolution >= 2*radius
        error("The resolution cannot be greater than 2*radius")
    end

    points = Vector[T[], T[], T[]]

    #Check the numbers of 1s in the matlab
    for x in -T(radius):T(resolution):T(radius)
        for y in -T(radius):T(resolution):T(radius)
            for z in T(0):T(resolution):T(radius)
                if(x^2 + y^2 + z^2 <= radius^2)
                    push!(points[1], x)
                    push!(points[2], y)
                    push!(points[3], z)
                end
            end
        end
    end

    scan.points = stack((points[1], points[2], points[3]); dims=2)
    scan.axes = (-T(radius):T(resolution):T(radius), -T(radius):T(resolution):T(radius), T(0):T(resolution):T(radius))
end

function load_scans!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.signal = readdlm(source1, delim, Y, use_mmap=true)
end

function load_scans!(scan::BreastScan{T, Y, Z}, source1::String, source2::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.signal = readdlm(source1, delim, Y, use_mmap=true) .- readdlm(source2, delim, Y, use_mmap=true)
end

function load_frequencies!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.frequencies = readdlm(source1, delim, T, use_mmap=true)
end

function load_antennas!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.antennas = readdlm(source1, delim, T, use_mmap=true)
end

function load_channels!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.channels = readdlm(source1, delim, Z, use_mmap=true)
end
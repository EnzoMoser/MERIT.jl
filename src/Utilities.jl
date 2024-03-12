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

"A function to generate the points of a hemisphere
scan       : The BreastScan struct
resolution : The resolution for the axes
radius     : The radius of the hemisphere

Updates the 'points' and 'axes' fields of the BreastScan struct"
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

    radius = radius + 5e-3
    scan.points = Point3{T}[]
    #Check the numbers of 1s in the matlab
    for x in -T(radius):T(resolution):T(radius)
        for y in -T(radius):T(resolution):T(radius)
            for z in T(0):T(resolution):T(radius)
                if(x^2 + y^2 + z^2 <= radius^2)
                    push!(scan.points, Point3{T}(x, y, z))
                end
            end
        end
    end

    scan.axes = (-T(radius):T(resolution):T(radius), -T(radius):T(resolution):T(radius), T(0):T(resolution):T(radius))
end


"
scan    : The BreastScan struct
source1 : The path to the CSV file
delim   : The delimination character for the CSV file

Loads one scan (filetype should be a CSV) into the signal field of the BreastScan struct
"
function load_scans!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.signal = readdlm(source1, delim, Y, use_mmap=true)
end

function load_scans(Y::DataType, source1::String, delim::AbstractChar)
    return readdlm(source1, delim, Y, use_mmap=true)
end

"
scan    : The BreastScan struct
source1 : The path to the CSV file
source2 : The path to the CSV file
delim   : The delimination character for the CSV file

Loads two scans (filetype should be a CSV) into the signal field of the BreastScan struct. It performs rotational subtraction with both scans
"
function load_scans!(scan::BreastScan{T, Y, Z}, source1::String, source2::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.signal = readdlm(source1, delim, Y, use_mmap=true) .- readdlm(source2, delim, Y, use_mmap=true)
end

function load_scans(Y::DataType, source1::String, source2::String, delim::AbstractChar)
    return readdlm(source1, delim, Y, use_mmap=true) .- readdlm(source2, delim, Y, use_mmap=true)
end

"
scan    : The BreastScan struct
source1 : The path to the CSV file
delim   : The delimination character for the CSV file

Loads frequencies (filetype should be a CSV) into the frequencies field of the BreastScan struct.
"
function load_frequencies!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.frequencies = readdlm(source1, delim, T, use_mmap=true)
end

"
scan    : The BreastScan struct
source1 : The path to the CSV file
delim   : The delimination character for the CSV file

Loads the antenna locations (filetype should be a CSV) into the antennas field of the BreastScan struct.
"
function load_antennas!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    antennamat = readdlm(source1, delim, T, use_mmap=true)
    scan.antennas = Point3{T}[]
    for i in eachrow(antennamat)
        push!(scan.antennas, Point3{T}(i[1], i[2], i[3]))
    end
end

function load_antennas(T::DataType, source1::String, delim::AbstractChar)
    antennamat = readdlm(source1, delim, T, use_mmap=true)
    antennas = Point3{T}[]
    for i in eachrow(antennamat)
        push!(antennas, Point3{T}(i[1], i[2], i[3]))
    end
    return antennas
end

"
scan    : The BreastScan struct
source1 : The path to the CSV file
delim   : The delimination character for the CSV file

Loads the channel names (filetype should be a CSV) into the channels field of the BreastScan struct.
"
function load_channels!(scan::BreastScan{T, Y, Z}, source1::String, delim::AbstractChar) where {T <: Real, Y <: Number, Z <:Integer}
    scan.channels = readdlm(source1, delim, Z, use_mmap=true)
end
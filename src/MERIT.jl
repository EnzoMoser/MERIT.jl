module MERIT
    #TODO: Make it generic to input dtype
    #TODO: Impliment the time domain



    include("./Beamform.jl")
    include("./Beamformer.jl")
    include("./Visualize.jl")
    using MetaArrays: MetaArray

    #Abstract type for the type heirarchy
    #All scan types should be a subtype of Scans
    abstract type Scan end

    export BreastScan
    export domain_hemisphere, domain_hemisphere!, load_scans!

    #Holds all the info for the breast scans. Y defines the type for the scans
    #T defines the type for the rest of the data structures.
    mutable struct BreastScan{T, Y} <: Scan
        #This is for the points generated from domain_hemisphere
        points::Array{T, 2}
        axes::Tuple
        #DataFrame to hold the data from each scan
        scan::Array{Y, 2}
        BreastScan{T, Y}() where {T <: Real, Y <: Number} = new()
    end




    "A function to return the points of a hemisphere
        resolution: The resolution for the axes
        radius    : The radius of the hemisphere
        
    Returns a Nx3 matrix where N is the number of points produced. Also returns the axes as a range type."
    function domain_hemisphere(resolution::Number, radius::Number)
        
        if radius <= 0.0
            throw(DomainError(radius, "The radius cannot be 0 or negative"))
        end
        
        if resolution <= 0.0
            throw(DomainError(resolution, "The resolution cannot be 0 or negative"))
        end        
        
        if resolution >= 2*radius
            error("The resolution cannot be greater than 2*radius")
        end
        
        points = Vector[Float64[], Float64[], Float64[]]
        
        #Check the numbers of 1s in the matlab
        for x in -radius:resolution:radius
            for y in -radius:resolution:radius
                for z in 0:resolution:radius
                    if(x^2 + y^2 + z^2 <= radius^2)
                        push!(points[1], x)
                        push!(points[2], y)
                        push!(points[3], z)
                    end
                end
            end
        end
        return stack((points[1], points[2], points[3]); dims=2), (-radius:resolution:radius, -radius:resolution:radius, 0:resolution:radius)
    end

    function domain_hemisphere!(scan::BreastScan{<:AbstractFloat, <:Number}, resolution::AbstractFloat, radius::AbstractFloat)
        
        if radius <= 0.0
            throw(DomainError(radius, "The radius cannot be 0 or negative"))
        end
        
        if resolution <= 0.0
            throw(DomainError(resolution, "The resolution cannot be 0 or negative"))
        end        
        
        if resolution >= 2*radius
            error("The resolution cannot be greater than 2*radius")
        end
        
        points = Vector[Float64[], Float64[], Float64[]]
        
        #Check the numbers of 1s in the matlab
        for x in -radius:resolution:radius
            for y in -radius:resolution:radius
                for z in 0:resolution:radius
                    if(x^2 + y^2 + z^2 <= radius^2)
                        push!(points[1], x)
                        push!(points[2], y)
                        push!(points[3], z)
                    end
                end
            end
        end

        scan.points = stack((points[1], points[2], points[3]); dims=2)
        scan.axes = (-radius:resolution:radius, -radius:resolution:radius, 0:resolution:radius)
    end

    function load_scans!(scan::BreastScan{<:AbstractFloat, <:Number}, source1::String, delim::AbstractChar, dtype::Number)
        scan.scan = AxisArray(readdlm(source1, delim, dtype, use_mmap=true))
    end

    function load_scans!(scan::BreastScan{<:AbstractFloat, <:Number}, source1::String, source2::String, delim::AbstractChar, dtype::Number)
        scan.scan = readdlm(source1, delim, dtype, use_mmap=true) - readdlm(source1, delim, dtype, use_mmap=true)
    end
end
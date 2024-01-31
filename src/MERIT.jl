module MERIT
    include("./Beamform.jl")
    include("./Beamformer.jl")
    include("./Visualize.jl")

    #Abstract type for the type heirarchy
    #All scan types should be a subtype of Scans
    abstract type Scans end

    mutable struct BreastScans <: Scans
        #Holds all the info for the breast scans
        
        #DataFrame to hold the data from each scan
        scan::ComplexF64
    end

    export Scans, BreastScans

    "A function to return the points of a hemisphere
        resolution: The resolution for the axes
        radius    : The radius of the hemisphere
        
    Returns a Nx3 matrix where N is the number of points produced. Also returns the axes as a range type."
    function domain_hemisphere(resolution::Float64, radius::Float64)
        
        if radius <= 0.0
            throw(DomainError(radius, "The radius cannot be 0 or negative"))
        end
        
        if resolution <= 0.0
            throw(DomainError(resolution, "The resolution cannot be 0 or negative"))
        end        
        
        if resolution >= 2*radius
            error("The resolution cannot be greater than 2*radius")
        end
        
        points = [[],[],[]]
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
        return Float64.(stack((points[1], points[2], points[3]); dims=2)), (-radius:resolution:radius,-radius:resolution:radius, 0:resolution:radius)
    end
end

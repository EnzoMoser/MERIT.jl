    #Abstract type for the type heirarchy
    #All scan types should be a subtype of Scans
    abstract type Scan end

    #Holds all the info for the breast scans. Y defines the type for the scans
    #T defines the type for the rest of the data structures.
    mutable struct BreastScan{T, Y, Z} <: Scan
        #This is for the points generated from domain_hemisphere
        points::Array{T, 2}
        axes::Tuple
        signal::Array{Y, 2}
        relative_permiativity::T
        antennas::Array{T, 2}
        channels::Array{Z, 2}
        frequencies::Array{T, 2}
        delayFunc::Function
        beamformerFunc::Function
        BreastScan{T, Y, Z}() where {T <: Real, Y <: Number, Z <:Integer} = new()
    end
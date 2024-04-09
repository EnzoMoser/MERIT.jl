#Abstract type for the type heirarchy
#All scan types should be a subtype of Scans
"
This is an abstract data type that allows for some type heirarchy.
If adding more scan types, ensure that each new type is a subset of Scan.
"
abstract type Scan end

#Holds all the info for the breast scans. Y defines the type for the scans
#T defines the type for the rest of the data structures.

"
T : The datatype of the points, antenna locations and frequencies. Can be any real dtype
Y : The datatype of the signal. Can either be some a Complex dtype or a Real dtype
Z : The dataype of the channel locations. Can be any Integer dtype.
"
mutable struct BreastScan{T, Y, Z} <: Scan
    #This is for the points generated from domain_hemisphere
    points::Vector{Point3{T}}
    axes::Tuple
    signal::Array{Y, 2}
    antennas::Vector{Point3{T}}
    channels::Array{Z, 2}
    frequencies::Array{T, 2}
    delayFunc::Function
    beamformerFunc::Function
    BreastScan{T, Y, Z}() where {T <: Real, Y <: Number, Z <:Integer} = new()
end

#
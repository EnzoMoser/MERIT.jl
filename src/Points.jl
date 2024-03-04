#TODO: Include some type of promotion function to promote Point2 to Point3?

using Random
abstract type Point end

mutable struct Point3{T<:Real} <: Point
    x::T
    y::T
    z::T
end

mutable struct Point2{T<:Real} <: Point
    x::T
    y::T
end

# POINT3 FUNCTIONS #

function Base.:+(p1::Point3{T}, p2::Point3{T}) where {T <: Real}
    return Point3{T}(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
end

#TODO: Possibly extend this to Point2?
#TODO: Potentially replace with an inplace map! to reduce alloc count
function Base.:+(pVec::Vector{Point3{T}}, p::Point3{T}) where {T <:Real}
    map((x) -> x + p, pVec)
end


function Base.:-(p1::Point3{T}, p2::Point3{T}) where {T <: Real}
    return Point3{T}(p1.x-p2.x, p1.y-p2.y, p1.z-p2.z)
end

#TODO: Possibly extend this to Point2?
#TODO: Potentially replace with an inplace map! to reduce alloc count
function Base.:-(pVec::Vector{Point3{T}}, p::Point3{T}) where {T <:Real}
    map((x) -> x - p, pVec)
end

function Base.:^(p1::Point3{T}, pow) where {T <: Real}
    return Point3{T}(p1.x ^ pow, p1.y ^ pow, p1.z ^ pow)
end

function Base.sum(p::Point3{T}) where {T <: Real}
    return p.x + p.y + p.z
end

function Base.abs(p::Point3{T}) where{T <: Real}
    return Point3{T}(abs(p.x), abs(p.y), abs(p.z))
end

"""
within_tol(pVec::Vector{Point3{T}}, slice::T, idx, tol)
"""
function within_tol(pVec::Vector{Point3{T}}, slice::T, idx, tol) where {T<:Real}
    if idx > 3 
        throw(DomainError("Illegal Access. There is only 3 fields in Points3"))
    end

    slicePlane = Point3{T}(0,0,0)
    setfield!(slicePlane, idx, slice)
    zDiff = pVec - slicePlane
    zBool = map(x -> abs(getfield(x, idx)) < tol, zDiff)
    return zBool
end

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Point3{T}}) where {T <: Real} = Point3{T}(rand(rng), rand(rng), rand(rng))

Base.:(==)(p1::Point3{T}, p2::Point3{T}) where {T<:Real} = p1.x === p2.x && p1.y === p2.y && p1.z === p2.z

# POINT2 FUNCTIONS #

function Base.:+(p1::Point2{T}, p2::Point2{T}) where {T <: Real}
    return Point2{T}(p1.x+p2.x, p1.y+p2.y)
end

function Base.:-(p1::Point2{T}, p2::Point2{T}) where {T <: Real}
    return Point2{T}(p1.x-p2.x, p1.y-p2.y)
end

function Base.:^(p1::Point2{T}, pow) where {T <: Real}
    return Point2{T}(p1.x ^ pow, p1.y ^ pow)
end

function Base.sum(p::Point2{T}) where {T <: Real}
    return p.x + p.y
end

# Generic Point2/3 Functions #

function Base.length(p::Union{Point2{T}, Point3{T}}) where {T<:Real}
    return fieldcount(typeof(p))
end

Base.iterate(p::Union{Point2{T}, Point3{T}}, state=1) where {T<:Real} = state > fieldcount(typeof(p)) ? nothing : (getfield(p, state), state + 1)


abstract type Point end

struct Point3{T<:Real} <: Point
    x::T
    y::T
    z::T
end

struct Point2{T<:Real} <: Point
    x::T
    y::T
end

function Base.:+(p1::Point3{T}, p2::Point3{T}) where {T <: Real}
    return Point3{T}(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
end

function Base.:-(p1::Point3{T}, p2::Point3{T}) where {T <: Real}
    return Point3{T}(p1.x-p2.x, p1.y-p2.y, p1.z-p2.z)
end
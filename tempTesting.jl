include("src/Points.jl")
using DelimitedFiles

function domainPoints(resolution, radius, T)
    radius = radius + 5e-3
    points = Point3{T}[]
    #Check the numbers of 1s in the matlab
    for x in -T(radius):T(resolution):T(radius)
        for y in -T(radius):T(resolution):T(radius)
            for z in T(0):T(resolution):T(radius)
                if(x^2 + y^2 + z^2 <= radius^2)
                    push!(points, Point3{T}(x, y, z))
                end
            end
        end
    end
    return points
end

function load_antennasPoints(source1::String, delim::AbstractChar, T)
    antennamat = readdlm(source1, delim, T, use_mmap=true)
    antennas = Point3{T}[]
    for i in eachrow(antennamat)
        push!(antennas, Point3{T}(i[1], i[2], i[3]))
    end
    return antennas
end

function load_antennasMat(source1::String, delim::AbstractChar, T)
    antennamat = readdlm(source1, delim, T, use_mmap=true)
    return antennamat
end

function domainMatrix(resolution::Real, radius::Real, dtype)
    
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
    return stack((points[1], points[2], points[3]); dims=2)
end

pointVec = domainPoints(2.5e-3, 7e-2+5e-3, Float32)
pointMat = domainMatrix(2.5e-3, 7e-2+5e-3, Float32)
antennaVec = load_antennasPoints("data/antenna_locations.csv", ',', Float32)
antennaMat = load_antennasMat("data/antenna_locations.csv", ',', Float32)

distancesVec = zeros(Float32, 1, size(antennaVec, 1), size(pointVec, 1))
distancesMat = zeros(Float32, 1, size(antennaVec, 1), size(pointVec, 1))

for i in range(1, size(pointVec, 1))
    for j in range(1, size(antennaVec, 1))
        println("($(i), $(j))")
        pointsAntennaDiff = antennaVec[j] - pointVec[i]
        pointsAntennaDiffSq = pointsAntennaDiff^2
        @inbounds global distancesVec[1, j, i] = sum(pointsAntennaDiffSq)
    end
end

pointsAntennaDifferences = zeros(Float32, 3, size(antennaMat, 1), size(pointMat, 1))
    
#Reshaping and transposing to allow the element-wise operations later on
#to execute appropriately
antennaLoc = antennaMat'
pointsPerm = reshape(transpose(pointMat), (3, 1, :))
    
pointsAntennaDifferences .= (antennaLoc .- pointsPerm) .^ 2

for j in 1:size(pointsPerm, 3)
    for i in 1:size(antennaLoc, 2)
        @inbounds global distancesMat[1, i, j] = pointsAntennaDifferences[1, i, j] + pointsAntennaDifferences[2, i, j] + pointsAntennaDifferences[3, i, j]
    end
end



same = true

for i in range(1, size(distancesMat, 2))
    for j in range(1, size(distancesMat, 3))
        println("($(i), $(j))")
        global same = same && (distancesMat[1, i, j] == distancesVec[1, i, j])
    end
end

println(same)
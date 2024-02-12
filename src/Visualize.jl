using Plots
#! This fucntion is deprecated in favour of the type agnostic funciton below
# function get_slice(image, points, zSlice, axes)

#     #Create a boolean array which is True at all the indices where the z-coord
#     #is within a 1e-6 tolerance of the desired slice value 
#     zDifference = points[:,3] .- zSlice
#     boolZIdx = abs.(zDifference) .< 1e-6
    
#     #Create a -radius:resolution:radius x -radius:resolution:radius array.
#     #Index each coordinate point with the respective axis
#     #Then use the indexes to index into the first matrix and update each location with the intensity
    
#     imageSlice =  image[boolZIdx]
#     pointsSlice = points[boolZIdx, :]

#     if(size(pointsSlice, 1) == 0)
#         println("No points found at this Z-Level!")
#     end


#     intensityGrid = zeros(length(axes[1]), length(axes[2]))
#     indexMatrix = zeros(Int64, size(pointsSlice, 1), 2)
#     for i in range(1, size(pointsSlice, 1))
#         for j in range(1, 2)
#             #Find at which index the x-coord and y-coord is, in the x-axis and y-axis range
#             indexMatrix[i, j] = collect(searchsorted(axes[j], pointsSlice[i, j]))[1]
#         end 
#     end

#     for i in range(1, size(indexMatrix, 1))
#         #Go to the indices for each point and update that location with the intensity/energy from the image matrix
#         # intensityGrid[length(axes[1]) + 1 - indexMatrix[i, 1], indexMatrix[i, 2]] = imageSlice[i]  <-- This was an old implimentation to get this to look exactly like what imagesc in matlab shows. Apparently imagesc flips the image along the x-axis
#         intensityGrid[indexMatrix[i, 1], indexMatrix[i, 2]] = imageSlice[i]
#     end

#     return intensityGrid
# end


#This function should be type agnostic 
function get_slice(image::Array{T}, scan::BreastScan{<:AbstractFloat, <:Number, <:Integer}, zSlice::Real) where {T <: AbstractFloat}

    #Create a boolean array which is True at all the indices where the z-coord
    #is within a 1e-6 tolerance of the desired slice value 
    zSlice = eltype(scan.points)(zSlice)
    zDifference = scan.points[:,3] .- zSlice
    boolZIdx = abs.(zDifference) .< 1e-6
    
    #Create a -radius:resolution:radius x -radius:resolution:radius array.
    #Index each coordinate point with the respective axis
    #Then use the indexes to index into the first matrix and update each location with the intensity
    pointsSlice = scan.points[boolZIdx, :]
    
    intensityGrid = zeros(length(scan.axes[1]), length(scan.axes[2]))
    
    if(size(pointsSlice, 1) == 0)
        println("No points found at this Z-Level!")
        return intensityGrid
    end
    
    imageSlice =  image[boolZIdx]
    indexMatrix = zeros(Int64, size(pointsSlice, 1), 2)
    for i in range(1, size(pointsSlice, 1))
        for j in range(1, 2)
            #Find at which index the x-coord and y-coord is, in the x-axis and y-axis range
            indexMatrix[i, j] = collect(searchsorted(scan.axes[j], pointsSlice[i, j]))[1]
        end 
    end

    for i in range(1, size(indexMatrix, 1))
        #Go to the indices for each point and update that location with the intensity/energy from the image matrix
        # intensityGrid[length(axes[1]) + 1 - indexMatrix[i, 1], indexMatrix[i, 2]] = imageSlice[i]  <-- This was an old implimentation to get this to look exactly like what imagesc in matlab shows. Apparently imagesc flips the image along the x-axis
        intensityGrid[indexMatrix[i, 1], indexMatrix[i, 2]] = imageSlice[i]
    end

    return intensityGrid
end


function plot_scan(imageSlice::Array{T}, scan::BreastScan{<:AbstractFloat, <:Number, <:Integer}, color_scale::String = "Viridis") where {T <: AbstractFloat}
    plotlyjs()
    graphHandle = heatmap(scan.axes[1], scan.axes[2], imageSlice, colorscale=color_scale)
    Base.invokelatest(display, graphHandle)
    readline()
end
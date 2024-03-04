"
This allows you to calculate the Signal-to-Clutter Ratio
"
function SCR(image, points)
end


"
Full Width at Half Maximum

A width along each dimension such that all the points outside this width are less than half the maximum intensity
for that dimension. Or conversely, all the points within this width are greater than half the maximum intensity.
"

#TODO: Reduce allocs by preallocating and using boolBitArray multiple times
#TODO: Reduce allocs by preallocating and using xPoints multiple times for the other axes
function FWHM(scan::BreastScan{<:T, <:Y, <:Z}, image) where {T <: Real, Y <: Number, Z <:Integer}
    #Find the index of the max intensity
    maxIntensityLocation = argmax(image)[1]
    maxIntensity = image[maxIntensityLocation]
    
    #Find its coord location
    pointLocation = scan.points[maxIntensityLocation]


    #Find all the Xs that are close to this point by searching for the Y and Z coords
    #Repeat for Y with the X and Z and for Z with the X and Y
    boolXBitArray = within_tol(scan.points, pointLocation.y, 2, 1e-6) .& within_tol(scan.points, pointLocation.z, 3, 1e-6)
    
    #Finding all Ys that are close to this point by searching for the X and Z coords
    boolYBitArray = within_tol(scan.points, pointLocation.x, 1, 1e-6) .& within_tol(scan.points, pointLocation.z, 3, 1e-6)

    #Finding all Zs that are close to this point by searching for the X and Y coords
    boolZBitArray = within_tol(scan.points, pointLocation.x, 1, 1e-6) .& within_tol(scan.points, pointLocation.y, 2, 1e-6)
    
    fwhmX = fwhm(image[boolXBitArray])
    fwhmY = fwhm(image[boolYBitArray])
    fwhmZ = fwhm(image[boolZBitArray])

    #Really StepRangeLen.step when the range is made with Float64 is Base.TwicePrecision with hi and lo fields. I chose the hi field since ti gives me good enough precision here.
    #But really if it is Float64 it should be step.hi+step.lo. If it was made with Float32, it would be just be axes.step
    #TODO: Change this in the future to choose the correct field based on the type of axes.step
    return (scan.axes[1].step.hi * fwhmX, scan.axes[2].step.hi * fwhmY, scan.axes[3].step.hi * fwhmZ)
    
end

function fwhm(signal)
    maxIntensityIdx = argmax(signal)[1]
    maxIntensity = signal[maxIntensityIdx]

    lessHalfMaxIntensityLocation = findall(x -> (x < maxIntensity/2), signal)
    shiftedLessHalfMaxIntensityLocation = lessHalfMaxIntensityLocation .- maxIntensityIdx
    upperBoundFilter = filter(x -> (x > 0), shiftedLessHalfMaxIntensityLocation)
    upperBound = length(upperBoundFilter) == 0 ? (length(signal) - maxIntensityIdx + 1) : minimum(upperBoundFilter, dims=1) 
    lowerBoundFilter = filter(x -> (x < 0), shiftedLessHalfMaxIntensityLocation)
    lowerBound = length(lowerBoundFilter) == 0 ? -maxIntensityIdx : maximum(lowerBoundFilter, dims=1)
    return upperBound[1] - lowerBound[1] - 1 
end
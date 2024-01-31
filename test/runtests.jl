using MERIT
using Test
using DelimitedFiles
using MAT


function MSE(y_pred, y_acc)
    mse::Float64 = 0

    for i in 1:size(y_pred, 1)
        for j in 1:size(y_pred, 2)
            mse += (y_pred[i, j]-(isnan(y_acc[i, j]) ? 0.0 : y_acc[i, j]))^2        
        end
    end

    return mse/(size(y_pred, 1) * size(y_pred, 2))
end
@testset "MERIT.jl" begin
    # Write your tests here.
    println(pwd())

    pointsM  = matread("../data/tests/points.mat")["points"]
    timesM   = matread("../data/tests/time.mat")["times"]
    imageSliceM = matread("../data/tests/imageSlice.mat")["im_slice"]
    print(size(pointsM))

    frequencies = readdlm("../data/frequencies.csv", ',', Float64)
    antennalocations = readdlm("../data/antenna_locations.csv", ',', Float64)
    channelnames = readdlm("../data/channel_names.csv", ',', Int64)
    scan1 = readdlm("../data/B0_P3_p000.csv", ',', ComplexF64)
    scan2 = readdlm("../data/B0_P3_p036.csv", ',', ComplexF64)
    
    signal = scan1 - scan2
    points , axes = MERIT.domain_hemisphere(2.5e-3, 7e-2 + 5e-3)
    times = MERIT.Beamform.get_delays(channelnames, antennalocations, 8.0, points)
    image = abs.(MERIT.Beamform.beamform(signal, frequencies, points, times))
    imageSlice = MERIT.Visualize.get_slice(image, points, 35e-3, axes)

    #Are the image slices the same size
    @test size(imageSliceM) == size(imageSlice)

    #Calculate the mean square error
    @test MSE(imageSlice, imageSliceM) < 1e-6
end


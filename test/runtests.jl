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

    #TODO: Create tests to see if the types the user specifies are kept throughout the process.

    pointsM  = matread("../data/tests/points.mat")["points"]
    timesM   = matread("../data/tests/time.mat")["times"]
    imageSliceM = matread("../data/tests/imageSlice.mat")["im_slice"]
    print(size(pointsM))

    scan = BreastScan{Float64, ComplexF64, UInt32}()
    domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3, Float64)
    load_scans!(scan,"../data/B0_P3_p000.csv" , "../data/B0_P3_p036.csv", ',', ComplexF64)
    load_frequencies!(scan, "../data/frequencies.csv", ',', Float64)
    load_antennas!(scan, "../data/antenna_locations.csv", ',', Float64)
    load_channels!(scan, "../data/channel_names.csv", ',', UInt32)
    scan.delayFunc = get_delays(Float32(8.0))
    scan.beamformerFunc = DAS
    image = abs.(beamform(scan))
    imageSlice = get_slice(image, scan, 35e-3)

    #Are the image slices the same size
    @test size(imageSliceM) == size(imageSlice)

    #Calculate the mean square error
    @test MSE(imageSlice, imageSliceM) < 1e-6
end


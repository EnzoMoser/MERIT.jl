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

    # #TODO: Create tests to see if the types the user specifies are kept throughout the process.

    # pointsM  = matread("../data/tests/points.mat")["points"]
    # timesM   = matread("../data/tests/time.mat")["times"]
    # imageSliceM = matread("../data/tests/imageSlice.mat")["im_slice"]
    # print(size(pointsM))

    # scan = BreastScan{Float64, ComplexF64, UInt32}()
    # domain_hemisphere!(scan, 2.5e-3, 7e-2)
    # load_scans!(scan,"../data/B0_P3_p000.csv" , "../data/B0_P3_p036.csv", ',')
    # load_frequencies!(scan, "../data/frequencies.csv", ',')
    # load_antennas!(scan, "../data/antenna_locations.csv", ',')
    # load_channels!(scan, "../data/channel_names.csv", ',')
    # scan.delayFunc = get_delays(Float32(8.0))
    # scan.beamformerFunc = DAS
    # image = abs.(beamform(scan))
    # imageSlice = get_slice(image, scan, 35e-3)

    # #Are the image slices the same size
    # @test size(imageSliceM) == size(imageSlice)

    # #Calculate the mean square error
    # @test MSE(imageSlice, imageSliceM) < 1e-6

end


@testset "Points.jl" begin
    dtypes = [Float64, Float32]
    for j in dtypes
        a = rand(Point3{j}, 10000)
        b = rand(Point3{j}, 10000)
        for i = 1:length(a)
            c = a[i] + b[i]
            @test c.x == a[i].x + b[i].x && c.y == a[i].y + b[i].y && c.z == a[i].z + b[i].z
            c = a[i] - b[i]
            @test c.x == a[i].x - b[i].x && c.y == a[i].y - b[i].y && c.z == a[i].z - b[i].z
            @test sum(a[i]) == a[i].x + a[i].y + a[i].z
            @test a[i]^2 == Point3{j}(a[i].x^2, a[i].y^2, a[i].z^2)
        end

    end
end

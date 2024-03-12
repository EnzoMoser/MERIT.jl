module MERIT
    #TODO: Make it generic to input dtype
    #TODO: Impliment the time domain
    using DelimitedFiles

    #From Scans.jl
    export BreastScan

    #From Utilities.jl
    export domain_hemisphere, domain_hemisphere!, load_scans!, load_frequencies!, load_antennas!, load_channels!, load_antennas, load_scans
    
    #From Beamform.jl
    export get_delays, beamform
    
    #From Process.jl
    export delay_signal!

    #From Beamformer.jl
    export DAS

    #From Visualize.jl
    export get_slice, plot_scan

    #From Windows.jl
    export rectangular

    #From Points.jl
    export Point3, Point2, SphericalPoint, point3Vec2Mat, within_tol

    #From Metrics.jl
    export FWHM
    
    #From Testing.jl
    export genAntennaLocations, genChannelNames, genFrequencies, genRandomData

    include("./Points.jl")
    include("./Scans.jl")
    include("./Beamform.jl")
    include("./Beamformer.jl")
    include("./Visualize.jl")
    include("./Process.jl")
    include("./Utilities.jl")
    include("./Windows.jl")
    include("./Metrics.jl")
    #Some helper functions for testing the performance of the library
    include("./Testing.jl")

end
#TODO: Impliment a new delay_signal for the time domain. 
function delay_signal!(delayedSignal::Array{ComplexF64}, signal::Matrix{ComplexF64}, delays::Matrix{Float64}, frequencies::Matrix{Float64})
    #Assuming signals are complex (i.e in the frequency domain)
    #Signals will be of size (numFrequencies, channelNamesLength)
    #If the signals are complex we're in the frequency domain.
    #Delaying in the frequency domain is the same as multiplying by exp(-j*2*pi*f*t)
    #The return value will be of size (numFrequencies x channelNamesLength x NumPoints) (Note we only consider 1 point here)
    
    delayedSignal[:,:,1] .= signal .* exp.(-1im .* 2 .* pi .* (delays .* frequencies))

    # if length(size(delayedSignal)) <= 2
    #     return Utilities.add_dim(delayedSignal)
    # else
    #     return delayedSignal
    # end
end


#TODO: For the time domain T should be a subtype of Real. Since that is more specific than Number, Julia will dispatact
#TODO: that function rather than the one below
#This function requires T to be a subtype of Complex since this is specific to the frequency domain.
function delay_signal!(delayedSignal::Array{T}, signal::Matrix{T}, delays::Matrix{Y}, frequencies::Matrix{Y}) where {T<:Complex, Y<:Real}
    #Assuming signals are complex (i.e in the frequency domain)
    #Signals will be of size (numFrequencies, channelNamesLength)
    #If the signals are complex we're in the frequency domain.
    #Delaying in the frequency domain is the same as multiplying by exp(-j*2*pi*f*t)
    #The return value will be of size (numFrequencies x channelNamesLength x NumPoints) (Note we only consider 1 point here)
    
    delayedSignal[:,:,1] .= signal .* exp.(-1im .* 2 .* pi .* (delays .* frequencies))

    # if length(size(delayedSignal)) <= 2
    #     return Utilities.add_dim(delayedSignal)
    # else
    #     return delayedSignal
    # end
end
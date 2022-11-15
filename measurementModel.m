function [ h ] = measurementModel(parameters,UE,AP,TYPE)

%% compute the distance between UE and APs
distanceUEAP = sqrt( sum( [UE-AP].^2 , 2 ) ); 

%% build the vector/matrix of observation
h = zeros( 1 , parameters.numberOfAP );
for a = 1:parameters.numberOfAP
    switch TYPE   
        case 'TDOA'
            refAP = 2;
            h(a) = distanceUEAP( a ) - distanceUEAP( refAP );
    end
    
end
h(2)=[]; % removing second column (refAP)

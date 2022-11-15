function H=buildJacobianMatrixH( parameters , UE , AP , TYPE )
distanceUEAP=sqrt(sum([UE-AP].^2, 2));
%direction cosine
directionCosineX=(UE(1)-AP(:,1))./distanceUEAP;
directionCosineY=(UE(2)-AP(:,2))./distanceUEAP;

H=zeros(6,2);
for a=1:6
    switch TYPE
        case 'TDOA'
            H(a,:) = [ directionCosineX(a) - directionCosineX(2), directionCosineY(a) - directionCosineY(2)];% considering w as refAp
                       
    end
end
H(2,:) = []; % avoiding refAP - this line would be all 0
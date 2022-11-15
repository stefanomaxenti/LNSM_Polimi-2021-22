function [uHat,numberOfPerformedIterations] = iterativeNLS( parameters , AP , TYPE , Q , rho, index, position)

    % NLS starting point - initial guess
    uHatInit = position;
    uHat = zeros( parameters.NiterMax , 2 );

    for iter = 1:parameters.NiterMax
        %% Step 1 - initial guess
        if iter==1
            uHat(iter,:) = uHatInit;
        end
        %% Step 2 - compute Jacobian matrix
        H = buildJacobianMatrixH( parameters , uHat(iter,:) , AP , TYPE );

        %% Step 3 - compute the observation matrix and evaluate the difference delta rho
        h_uhat = measurementModel( parameters , uHat(iter,:) , AP , TYPE );
        delta_rho = rho - h_uhat;

        %% Step 4 - compute the correction

        delta_u = pinv(H)*delta_rho';

        %% Step 5 - update the estimate
        uHat( iter+1 , : ) = uHat( iter , : ) + .1* delta_u';
        numberOfPerformedIterations = iter + 1;

        %% stopping criterion
        if sum(delta_u.^2)<1e-12
            return
        end       

    end

end
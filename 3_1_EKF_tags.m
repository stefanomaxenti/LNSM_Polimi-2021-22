clear all
clc
close all

set(0,'DefaultTextFontSize',22)
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesFontSize',16)

load('dataset/AP.mat');
% Setting the boolean denoise variable to true to use the offline filtering

denoise = false;
if denoise == true
    load('dataset/rho_TDOA_final_denoise.mat')
end

if denoise == false
    load('dataset/rho_TDOA_final.mat')
end
%% Define the localization scenario
% scenario settings

parameters.numberOfAP = 6;
parameters.positionAP = zeros(6,2); % 6 AP [x,y]
for i = 1:6
    parameters.positionAP(i,1) = AP(i,1);
    parameters.positionAP(i,2) = AP(i,2);
end

AP = AP(:,1:2); % not considering z axis

%% parameters
parameters.simulationTime = 663;
parameters.samplingTime = 0.1; %s

%% Tracking by EKF

for p=1:4
    parameters.simulationTime = size(rho{p,:}, 2); %s
    our_array = rho{p,:};
    TYPE = 'TDOA';
    %initialization
    UE_init = [10, 20];
    UE_init_COV = diag([100^2,100^2]);
    x_hat = NaN( parameters.simulationTime , 2);
    P_hat = NaN( 2 , 2 , parameters.simulationTime );

    R = diag([5,5,5,5,5]);
    Q = diag([0.1, 0.1] );
    F = [1 0 ; 0 1];

    %update over time
    for time = 1 : parameters.simulationTime

        %prediction
        if time == 1
            x_pred =  UE_init';
            P_pred =  UE_init_COV;
        else
            x_pred = F * x_hat(time-1,:)';
            P_pred = F * P_hat(:,:,time-1)*F' + Q;
        end
        H = buildJacobianMatrixH(parameters, x_pred' , AP , TYPE);
        %update
        G = P_pred * H' * inv( H*P_pred*H' + R);
        m = measurementModel ( parameters , x_pred' , AP , TYPE)';
        r = our_array(:,time);
        x_hat(time,:) = x_pred + G * ( our_array(:,time) - measurementModel ( parameters , x_pred' , AP , TYPE)' ) ;
        P_hat(:,:,time) = P_pred - G * H * P_pred;

    end
    ekf_meas = x_hat;
    if denoise == true
        save(strcat('dataset/ekf_denoise/ekf' ,string(p),'.mat'),'ekf_meas');
    end
    if denoise == false
        save(strcat('dataset/ekf/ekf' ,string(p),'.mat'),'ekf_meas');
    end
end
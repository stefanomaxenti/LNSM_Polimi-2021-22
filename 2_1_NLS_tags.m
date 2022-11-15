% PROJECT

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

%% Define the localization scenario.
% Since the AGV moves horizontally, we exclude the Z coordinate.

parameters.numberOfAP = 6;
parameters.positionAP = zeros(6,2); % 6 AP [x,y]
for i = 1:6
    parameters.positionAP(i,1) = AP(i,1);
    parameters.positionAP(i,2) = AP(i,2);
end
AP = AP(:,1:2); % not considering z axis

%% IMPLEMENT NLS
% We initialize the sigma of the TDOA measurments to 0.1 meters and we decide
% to use 1000 iterations for each timestep

for p=1 : size(rho, 1)
    parameters.NiterMax = 1000; % number updates
    our_array = rho{p,:};
    TYPE = 'TDOA';
    R =[]; % R is not used since we are not in WLNS
    rho2 = our_array.';
    % nls_meas contains the position coordinates after each time interval
    nls_meas = zeros( size(rho{p,:}, 2) , 2 );
    % random initial position
    position = [10, 20];

    for i = 1:size(rho{p,:}, 2)
        [ uHat , numberOfPerformedIterations ] = iterativeNLS( parameters , AP , TYPE , R , rho2(i,:), i, position); %this function should return a (NiterMax x 2) vector of the estimates provided by the NLS
        uHat = uHat( 1:numberOfPerformedIterations , : ); % this is the final estimate of NLS at the last iteration
        nls_meas(i,:) = uHat(end,:);
        % We decide to start at the next timestep from the latest found
        % position.
        position = uHat(end,:);
    end
    % We save the nls for tag p
    if denoise == true
        save(strcat('dataset/nls_denoise/nls' ,string(p),'.mat'),'nls_meas');
    end
    if denoise == false
        save(strcat('dataset/nls/nls' ,string(p),'.mat'),'nls_meas');
    end
end
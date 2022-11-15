clear all
clc
close all

% We load all the final datasets
denoise = false;

if denoise == true
    nls1 = load('dataset/nls_denoise/nls1.mat');
    nls2 = load('dataset/nls_denoise/nls2.mat');
    nls3 = load('dataset/nls_denoise/nls3.mat');
    nls4 = load('dataset/nls_denoise/nls4.mat');

    ekf1 = load('dataset/ekf_denoise/ekf1.mat');
    ekf2 = load('dataset/ekf_denoise/ekf2.mat');
    ekf3 = load('dataset/ekf_denoise/ekf3.mat');
    ekf4 = load('dataset/ekf_denoise/ekf4.mat');
end
if denoise == false
    nls1 = load('dataset/nls/nls1.mat');
    nls2 = load('dataset/nls/nls2.mat');
    nls3 = load('dataset/nls/nls3.mat');
    nls4 = load('dataset/nls/nls4.mat');

    ekf1 = load('dataset/ekf/ekf1.mat');
    ekf2 = load('dataset/ekf/ekf2.mat');
    ekf3 = load('dataset/ekf/ekf3.mat');
    ekf4 = load('dataset/ekf/ekf4.mat');
end

% We plot the overall position of the AGV
n_timesteps = max([size(nls1.nls_meas, 1), size(nls2.nls_meas, 1), size(nls3.nls_meas, 1), size(nls4.nls_meas, 1)]);
faulty_tag_timesteps = size(nls1.nls_meas, 1);
coeff = n_timesteps/faulty_tag_timesteps;

for i = 1:n_timesteps-2
    X_nls(i, :) = mean([nls1.nls_meas(round(i/coeff)+1,1), nls2.nls_meas(i,1), nls3.nls_meas(i,1), nls4.nls_meas(i,1)]);
    Y_nls(i, :) = mean([nls1.nls_meas(round(i/coeff)+1,2), nls2.nls_meas(i,2), nls3.nls_meas(i,2), nls4.nls_meas(i,2)]);
    X_ekf(i, :) = mean([ekf1.ekf_meas(round(i/coeff)+1,1), ekf2.ekf_meas(i,1), ekf3.ekf_meas(i,1), ekf4.ekf_meas(i,1)]);
    Y_ekf(i, :) = mean([ekf1.ekf_meas(round(i/coeff)+1,2), ekf2.ekf_meas(i,2), ekf3.ekf_meas(i,2), ekf4.ekf_meas(i,2)]);
end

figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
plot(X_nls, Y_nls, 'b', 'LineWidth', 1)
hold on
plot(X_ekf, Y_ekf, 'r', 'LineWidth', 1)
legend('NLS', 'EKF', 'Location', 'northwest');
xlabel('X coordinates [m]')
ylabel('Y coordinates [m]')
title('Trajectories')
grid on
xlim([5.5 11]);
ylim([20.5 23.5]);

if denoise == true
    saveas(figure1 ,strcat('graph/denoise_comparison_plot.png'));
end
if denoise == false
    saveas(figure1 ,strcat('graph/comparison_plot.png'));
end
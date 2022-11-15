clear all
clc
close all

% We load the final positions for each one of the four tags
% Setting the boolean denoise variable to true to use the offline filtering

denoise = false;

if denoise == true
    ekf1 = load('dataset/ekf_denoise/ekf1.mat');
    ekf2 = load('dataset/ekf_denoise/ekf2.mat');
    ekf3 = load('dataset/ekf_denoise/ekf3.mat');
    ekf4 = load('dataset/ekf_denoise/ekf4.mat');
end
if denoise == false
    ekf1 = load('dataset/ekf/ekf1.mat');
    ekf2 = load('dataset/ekf/ekf2.mat');
    ekf3 = load('dataset/ekf/ekf3.mat');
    ekf4 = load('dataset/ekf/ekf4.mat');
end

load('dataset/AP.mat');

n_timesteps = max([size(ekf1.ekf_meas, 1), size(ekf2.ekf_meas, 1), size(ekf3.ekf_meas, 1), size(ekf4.ekf_meas, 1)]);
faulty_tag_timesteps = size(ekf1.ekf_meas, 1);
% We want to plot iteratively all the location points for each of the four
% tag.
figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
% If we want to plot the AP - maybe not
% for i=1:size(AP,1)
%     plot(AP(i, 1), AP(i,2), '.r')
%     hold on
% end

for i=1:n_timesteps
    if (i < faulty_tag_timesteps)
        plot(ekf1.ekf_meas(i,1), ekf1.ekf_meas(i,2), '.m')
        hold on
    end
    plot(ekf2.ekf_meas(i,1), ekf2.ekf_meas(i,2), '.b')
    hold on
    plot(ekf3.ekf_meas(i,1), ekf3.ekf_meas(i,2), '.r')
    hold on
    plot(ekf4.ekf_meas(i,1), ekf4.ekf_meas(i,2), '.g')
    drawnow
end

grid on
xlabel('X coordinates [m]')
ylabel('Y coordinates [m]')
xlim([5.5 11]);
ylim([20.5 23.5]);
axis equal
title('Trajectories')
legend('Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Location', 'northwest')

uiwait(figure1);

% We apply the same correction as the one described in NLS_plot

coeff = n_timesteps/faulty_tag_timesteps;

figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);

for i=1:n_timesteps-2
    if (i < faulty_tag_timesteps*coeff)
        plot(ekf1.ekf_meas(round(i/coeff)+1,1), ekf1.ekf_meas(round(i/coeff)+1,2), '.m')
        hold on
    end
    plot(ekf2.ekf_meas(i,1), ekf2.ekf_meas(i,2), '.b')
    hold on
    plot(ekf3.ekf_meas(i,1), ekf3.ekf_meas(i,2), '.r')
    hold on
    plot(ekf4.ekf_meas(i,1), ekf4.ekf_meas(i,2), '.g')
    drawnow
end
grid on
xlabel('X coordinates [m]')
ylabel('Y coordinates [m]')
xlim([5.5 11]);
ylim([20.5 23.5]);
%axis equal
title('Trajectories')
legend('Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Location', 'northwest');

if denoise == true
    saveas(figure1 , 'graph/denoise_ekf_plot.png');
end
if denoise == false
    saveas(figure1 , 'graph/ekf_plot.png');
end
clear all
clc
close all

set(0,'DefaultTextInterpreter','latex')

% We start by loading the NLS results from the previous session
% Setting the boolean denoise variable to true to use the offline filtering

denoise = false;
if denoise == true
    nls1 = load('dataset/nls_denoise/nls1.mat');
    nls2 = load('dataset/nls_denoise/nls2.mat');
    nls3 = load('dataset/nls_denoise/nls3.mat');
    nls4 = load('dataset/nls_denoise/nls4.mat');
end
if denoise == false
    nls1 = load('dataset/nls/nls1.mat');
    nls2 = load('dataset/nls/nls2.mat');
    nls3 = load('dataset/nls/nls3.mat');
    nls4 = load('dataset/nls/nls4.mat');
end

% We want to plot iteratively all the location points for each of the four
% tag.

n_timesteps = max([size(nls1.nls_meas, 1), size(nls2.nls_meas, 1), size(nls3.nls_meas, 1), size(nls4.nls_meas, 1)]);
faulty_tag_timesteps = size(nls1.nls_meas, 1);

figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);

for i=1:n_timesteps
    if (i < faulty_tag_timesteps)
        plot(nls1.nls_meas(i,1), nls1.nls_meas(i,2), '.m')
    end
    hold on
    plot(nls2.nls_meas(i,1), nls2.nls_meas(i,2), '.b')
    hold on
    plot(nls3.nls_meas(i,1), nls3.nls_meas(i,2), '.r')
    hold on
    plot(nls4.nls_meas(i,1), nls4.nls_meas(i,2), '.g')
    drawnow()
end
grid on
xlim([5.5 11]);
ylim([20.5 23.5]);
axis equal
xlabel('X coordinates [m]')
ylabel('Y coordinates [m]')
title('Trajectories')
legend('Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Location', 'northwest')

uiwait(figure1);

% We notice that tag1 is much faster than the other and overall the trajectory 
% is the same as the other tags, so our assumption that it stopped working 
% after around 250 timesteps is wrong.
% What probably happens is that it has a different sampling time.
% We estimate it to be around 3 times less, to be more precise 663/262
% which is about 2.5364
% To compensate this behaviour, we delay the plotting of the first tag.

coeff = n_timesteps/faulty_tag_timesteps;

figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);

for i=1:n_timesteps-2
    if (i < faulty_tag_timesteps*coeff)
        plot(nls1.nls_meas(round(i/coeff)+1,1), nls1.nls_meas(round(i/coeff)+1,2), '.m')
        hold on
    end
    plot(nls2.nls_meas(i,1), nls2.nls_meas(i,2), '.b')
    hold on
    plot(nls3.nls_meas(i,1), nls3.nls_meas(i,2), '.r')
    hold on
    plot(nls4.nls_meas(i,1), nls4.nls_meas(i,2), '.g')
    hold on
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
    saveas(figure1 , 'graph/denoise_nls_plot.png');
end

if denoise == false
    saveas(figure1 , 'graph/nls_plot.png');
end
clear all
clc
close all

set(0,'DefaultTextFontSize',22)
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesFontSize',16)

load('dataset/AP.mat');
load('dataset/original_dataset.mat');

% we clip the last two columns of tag2 and tag4 so that they have 663
% columns as tag3
% we clip the first column of all tags because in tag3 all values there are
% NaNs
rho{2,:}(:,664:665) = [];
rho{4,:}(:,664:665) = [];
rho{1,:}(:,1:1) = [];
rho{2,:}(:,1:1) = [];
rho{3,:}(:,1:1) = [];
rho{4,:}(:,1:1) = [];

for i = 1:size(rho,1) % 4 tags
    for j = 1 : size(rho{i,:},2) % all columns for each tag
        for k = 1:size(rho{i,:},1) % TDOA for tag
            if isnan(rho{i,:}(k,j))
                % we replace each NaN with the previous valid value
                rho{i,:}(k,j) = rho{i,:}(k,j-1);
            end
        end
    end
end

% We check for NaN in the final dataset
disp('Final dataset');
for i = 1:size(rho,1)
    n_nan = 0;
    for j=1:size(rho{i,:},1)
        n_nan = n_nan + sum(sum(isnan(rho{i,:}(j, :))));
    end
    disp([num2str(n_nan), ' NaNs found for tag ', num2str(i)]);
end
for i=1:size(rho,1)
    
end
save('dataset/rho_TDOA_final.mat', 'rho')

% We may need some noise filtering.
% We start by using a Savitzky–Golay filter with window size equal to 61
% and polynomial order equal to 19.
% This filter is used to fit successive sub-sets of adjacent (in this case 61) 
% data points with a polynomial by the method of linear least squares.

for i = 1:size(rho,1)
    for j = 1:5
        figure1 = figure;
        plot(rho{i,:}(j,:), 'LineWidth', 1);
        hold on
        rho{i,:}(j,:) = sgolayfilt(rho{i,:}(j,:)', 1, 11)';
        plot(rho{i,:}(j,:), 'LineWidth', 2);
        legend('Original', 'After denoising', 'FontSize', 20)
        grid on
        xlabel('Timesteps', 'FontSize', 20);
        ylabel('TDOA [m]', 'FontSize', 20);
        saveas(figure1 ,strcat('graph/tdoa_denoise_tag_' ,string(i), '_', string(j),'.png'))
    end
end
save('dataset/rho_TDOA_final_denoise.mat', 'rho');
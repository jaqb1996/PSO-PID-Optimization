clear all; close all;
load('history.mat');
Kp_min = 0; Kp_max = 5;
Ki_min = 0; Ki_max = 0.5;
Kd_min = 0; Kd_max = 0.10;
[numParticles, ~, numIter] = size(history);
f = figure(1);
title('Position of particles')
for iter = 1:numIter
    for p = 1:numParticles
        grid on;
        title(sprintf('Position of particles [%i]', iter));
        xlim([Kp_min, Kp_max]);
        ylim([Ki_min, Ki_max]);
        zlim([Kd_min, Kd_max]);
        xlabel('Kp');
        ylabel('Ki');
        zlabel('Kd');
        style = 'bo';
        if whichParticleBest(iter) == p
            style = 'ro';
        end
        plot3(history(p,1,iter), history(p,2,iter), history(p,3,iter), style);
        hold on;
    end
    pause(2);
    if iter ~= num_iter
        clf(f);
    end
end

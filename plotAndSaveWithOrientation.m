function plotAndSaveWithOrientation(x, y, orientation, titleStr, xLabel, yLabel, plotsDir, fileName, suffix)
    figure('Visible', 'off');
    plot(x, y, 'b', 'DisplayName', 'Trajectory');
    hold on;

    % Skipping some points for better visibility
    skip = 20; % Adjust this value to skip more or fewer points
    
    for i = 1:skip:length(x)
        dx = cos(orientation(i));
        dy = sin(orientation(i));
        
        % Verifying the orientation of the arrows
        quiver(x(i), y(i), dx, dy, 'r', 'AutoScale', 'off', 'MaxHeadSize', 0.5);
    end
    
    % Dummy plot for legend
    h = quiver(0,0,0,0,'r', 'AutoScale', 'off', 'MaxHeadSize', 0.5); 
    
    title(titleStr);
    xlabel(xLabel);
    ylabel(yLabel);
    
    % Updated legend with dummy plot
    legend([h], {'Orientation'}, 'Location', 'best');
    hold off;

    saveas(gcf, fullfile(plotsDir, [fileName(1:end-4) suffix]));
    close(gcf);
end
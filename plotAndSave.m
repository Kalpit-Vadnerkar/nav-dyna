function plotAndSave(x, yDatas, legends, titleStr, xLabel, yLabel, plotsDir, fileName, suffix)
    figure('Visible', 'off');
    hold on;
    colors = {'b', 'r', 'g', 'm', 'c', 'k'};  % Specify more colors if needed
    
    for i = 1:length(yDatas)
        plot(x, yDatas{i}, colors{i}, 'DisplayName', legends{i});
    end
    
    title(titleStr);
    xlabel(xLabel);
    ylabel(yLabel);
    legend('Location', 'best');
    hold off;

    saveas(gcf, fullfile(plotsDir, [fileName(1:end-4) suffix]));
    close(gcf);
end
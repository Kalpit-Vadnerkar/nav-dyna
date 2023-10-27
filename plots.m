% Clear workspace and close all figures
clear; close all;

% Load parameters and directories
plotsDir = 'Generated Plots';
baseDir = 'Simulation Results';
initialVelocities = [3:3:15];
maneuvers = {'ISO Double Lane Change', 'SLS', 'SRS', 'LSL', 'LSR', 'RSL', 'RSR'};

% Ensure plots directory exists
if ~exist(plotsDir, 'dir')
    mkdir(plotsDir);
end

% Iterate over initial velocities
for vIdx = 1:length(initialVelocities)
    u0 = initialVelocities(vIdx);
    
    % Iterate over maneuvers
    for m = 1:length(maneuvers)
        maneuver = maneuvers{m};
        maneuverPlotsDir = fullfile(plotsDir, maneuver, ['Velocity_' num2str(u0)]);
        if ~exist(maneuverPlotsDir, 'dir')
            mkdir(maneuverPlotsDir);
        end
        
        if m < length(maneuvers)
            pattern = ['Velo_' num2str(u0) '_Result_*.mat'];
        else
            pattern = ['Velo_' num2str(u0) '_*_Double_Lane_Change_Result.mat'];
        end
        
        resultFiles = dir(fullfile(baseDir, maneuver, ['Velocity_' num2str(u0)], pattern));
        
        % Iterate over found files
        for file = 1:length(resultFiles)
            filepath = fullfile(baseDir, maneuver, ['Velocity_' num2str(u0)], resultFiles(file).name);
            simResult = load(filepath);
            
            % Plot data
            plotData(simResult, u0, maneuver, resultFiles(file).name, maneuverPlotsDir);
        end 
    end
end

% Supporting functions
function dirPath = createDir(dirName)
    if ~exist(dirName, 'dir')
        mkdir(dirName);
    end
    dirPath = dirName;
end

function plotData(simResult, u0, maneuver, fileName, plotsDir)
    % Create time vector (assuming a fixed sample time or calculate it based on your data)
    time = linspace(0, 15, length(simResult.u)); 

    % Plot u, v, r, force, and steer
    plotAndSave(time, {simResult.u/10, simResult.v, simResult.r, simResult.force/100, simResult.theta}, ...
                {'u (m/s)', 'v (m/s)', 'r (rad/s)', 'Force (N)', 'Steer (rad)'}, ...
                ['Results for ' maneuver ' at ' num2str(u0) ' m/s'], ...
                'Time (s)','Values', plotsDir, fileName, '_Data.png');
    
    % Calculate the orientation of the vehicle based on u and v
    % orientation = atan2(simResult.v, simResult.u);

    % Plot x and y for trajectory
    plotAndSave(simResult.xu, {simResult.xy}, {'Trajectory'}, ...
                ['Trajectory for ' maneuver], ...
                'x (m)', 'y (m)', plotsDir, fileName, '_Trajectory.png');

    % Plot u and v for orientation
    plotAndSave(simResult.u/10, {simResult.v}, {'Orientation'}, ...
                ['Orientation for ' maneuver], ...
                'u (m/s)', 'v (m/s)', plotsDir, fileName, '_Orientation.png');

    % Plot x and y for trajectory with orientation
     % plotAndSaveWithOrientation(simResult.xu, simResult.xy, orientation*10, ...
     %             ['Trajectory for ' maneuver], ...
     %             'x (m)', 'y (m)', plotsDir, fileName, '_Trajectory.png');
end
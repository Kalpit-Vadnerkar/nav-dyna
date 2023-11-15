% Clear the workspace and close all figures
clear; close all;

% Load bike parameters and initial velocities
BIKEPRE;  % Load the bike parameters
c_values_array = [0:50:200]; % Acceleration magnitudes 
theta_values_array = (1:0.2:10) * pi/180;  % Steering magnitudes in radians
initial_velocities = [3:3:15];  % Define initial velocities

% Load the Simulink model
model_name = 'BIKENON';
load_system(model_name);

% Directories for input maneuvers and simulation results
input_folder = 'Input Maneuvers';
results_folder = 'Simulation Results';

% Create results folder if it doesn't exist
if ~exist(results_folder, 'dir')
    mkdir(results_folder);
end

% List of maneuvers to simulate
maneuvers = {'ISO Double Lane Change', 'SLS', 'SRS', 'LSL', 'LSR', 'RSL', 'RSR'};

% Process each initial velocity
for v_idx = 1:length(initial_velocities)
    u0 = initial_velocities(v_idx);  % Set current initial velocity

    % Loop over all maneuvers
    for m = 1:length(maneuvers)
        maneuver_dir = fullfile(input_folder, maneuvers{m});

        % Get all steer and force files for this maneuver
        steer_files = dir(fullfile(maneuver_dir, '*_steer.mat'));
        force_files = dir(fullfile(maneuver_dir, '*_force.mat'));

        % Check if same number of steer and force files are present
        if length(steer_files) ~= length(force_files)
            error('Mismatch in number of steer and force files for maneuver: %s', maneuvers{m});
        end

        % Create a sub-directory inside 'Simulation Results' for this maneuver
        result_maneuver_dir = fullfile(results_folder, maneuvers{m}, ['Velocity_', num2str(u0)]);
        if ~exist(result_maneuver_dir, 'dir')
            mkdir(result_maneuver_dir);
        end

        % Loop over all input files for this maneuver
        for i = 1:length(steer_files)
            % Set input files in Simulink model
            set_param([model_name '/From File1'], 'FileName', fullfile(maneuver_dir, steer_files(i).name));
            set_param([model_name '/From File 2'], 'FileName', fullfile(maneuver_dir, force_files(i).name));

            % Run the simulation
            sim(model_name);

            % Save the simulation results
            result_file_name = ['Velo_' num2str(u0) '_Result_' steer_files(i).name(1:end-10) '.mat'];
            save(fullfile(result_maneuver_dir, result_file_name), 'u', 'v', 'r', 'xu', 'xy', 'theta', 'force','ay');
            disp(['Simulation completed for ' steer_files(i).name(1:end-10) ' with initial velocity: ' num2str(u0) ' m/s']);
        end
    end
end

% Close the Simulink model
close_system(model_name, 0);
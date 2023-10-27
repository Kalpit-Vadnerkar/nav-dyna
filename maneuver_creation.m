% Initialization of parameters
dt = 0.01;
total_time = 15;
%theta_values_array = pi/180 * [2, 4, 6, 8, 10];  % Steering magnitudes in radians
theta_values_array = (1:0.1:10.1) * pi/180;
c_values_array = [0, 50, 75, 100, 125, 150, 200]; % Acceleration magnitudes
maneuvers = {'SLS', 'SRS', 'LSL', 'LSR', 'RSL', 'RSR'};
variability = 0.2; % Up to 20% variability in input timing for certain maneuvers
folder_name = 'Input Maneuvers';

% Ensure the root folder exists
if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end

% Generate and save the input maneuvers
for m = 1:length(maneuvers)
    maneuver_dir = fullfile(folder_name, maneuvers{m});
    if ~exist(maneuver_dir, 'dir'), mkdir(maneuver_dir); end
    
    % Determine the number of instances based on maneuver type
    num_instances = ismember(maneuvers{m}, {'SLS', 'SRS'}) * 4 + 1;

    for inst = 1:num_instances
        % Determine the start shift for variable maneuvers
        start_shift = (inst > 1) * rand() * variability * total_time;
        
        for ci = 1:length(c_values_array)
            for ti = 1:length(theta_values_array)
                [theta_ts, c_ts] = generate_realistic_inputs(maneuvers{m}, dt, total_time, ...
                                                            theta_values_array(ti), ...
                                                            c_values_array(ci), start_shift);
                                                            
                % Construct the save name based on maneuver and parameter values
                instance_str = '';
                if inst > 1
                    instance_str = ['instance', num2str(inst), '_'];
                end
                
                theta_str = num2str(theta_values_array(ti) * 180 / pi, '%.2f');
                c_str = num2str(c_values_array(ci));
                
                save_name_prefix = [instance_str, 'c', c_str, '_theta', theta_str];

                % Print paths for debugging
                fprintf('Saving to %s%s\n', maneuver_dir, [save_name_prefix '_steer.mat']);
                
                % Save the generated data
                save(fullfile(maneuver_dir, [save_name_prefix '_steer.mat']), 'theta_ts', "-v7.3");
                save(fullfile(maneuver_dir, [save_name_prefix '_force.mat']), 'c_ts', "-v7.3");
            end
        end
    end
end

% Generate and save the ISO Double Lane Change inputs
double_lane_change_dir = fullfile(folder_name, 'ISO Double Lane Change');
if ~exist(double_lane_change_dir, 'dir'), mkdir(double_lane_change_dir); end

for ci = 1:length(c_values_array)
    for ti = 1:length(theta_values_array)
        [theta_ts, c_ts] = generate_double_lane_change_inputs(dt, total_time, ...
                                                              theta_values_array(ti), ...
                                                              c_values_array(ci));
        
        % Convert numerical values to strings for cleaner filename construction
        theta_str = num2str(theta_values_array(ti) * 180 / pi, '%.2f');
        c_str = num2str(c_values_array(ci));
        
        save_name_prefix = ['c', c_str, '_theta', theta_str];
        
        % Print paths for debugging
        fprintf('Saving to %s%s\n', double_lane_change_dir, [save_name_prefix '_steer.mat']);
        
        % Save the generated data files
        save(fullfile(double_lane_change_dir, [save_name_prefix '_steer.mat']), 'theta_ts', "-v7.3");
        save(fullfile(double_lane_change_dir, [save_name_prefix '_force.mat']), 'c_ts', "-v7.3");
    end
end
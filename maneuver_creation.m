function main()
    % Initialization of parameters
    dt = 0.01;
    total_time = 15;
    theta_values_array = (1:0.1:10.1) * pi / 180;  % Steering magnitudes in radians
    c_values_array = [0:25:201]; % Acceleration magnitudes 
    maneuvers = {'SLS', 'SRS', 'LSL', 'LSR', 'RSL', 'RSR'};
    folder_name = 'Input Maneuvers';

    % Ensure the root folder exists
    check_and_create_dir(folder_name);

    % Generate and save the input maneuvers
    for m = 1:length(maneuvers)
        maneuver_dir = fullfile(folder_name, maneuvers{m});
        check_and_create_dir(maneuver_dir);
        
        for ci = 1:length(c_values_array)
            for ti = 1:length(theta_values_array)
                [theta_ts, c_ts] = generate_realistic_inputs(maneuvers{m}, dt, total_time, ...
                                                             theta_values_array(ti), ...
                                                             c_values_array(ci));
                
                % Construct the save name based on maneuver and parameter values
                theta_str = num2str(theta_values_array(ti) * 180 / pi, '%.2f');
                c_str = num2str(c_values_array(ci));
                save_name_prefix = ['c', c_str, '_theta', theta_str];

                % Save the generated data
                save_data(maneuver_dir, save_name_prefix, theta_ts, c_ts);
            end
        end
    end

    % Generate and save the ISO Double Lane Change inputs
    generate_and_save_double_lane_change(folder_name, dt, total_time, theta_values_array, c_values_array);
end

% Run the main function
%main();
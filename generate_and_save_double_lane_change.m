function generate_and_save_double_lane_change(folder_name, dt, total_time, theta_values_array, c_values_array)
    double_lane_change_dir = fullfile(folder_name, 'ISO Double Lane Change');
    check_and_create_dir(double_lane_change_dir);

    for ci = 1:length(c_values_array)
        for ti = 1:length(theta_values_array)
            [theta_ts, c_ts] = generate_double_lane_change_inputs(dt, total_time, ...
                                                                  theta_values_array(ti), ...
                                                                  c_values_array(ci));
            
            % Convert numerical values to strings for cleaner filename construction
            theta_str = num2str(theta_values_array(ti) * 180 / pi, '%.2f');
            c_str = num2str(c_values_array(ci));
            
            save_name_prefix = ['c', c_str, '_theta', theta_str];
            
            % Save the generated data files
            save_data(double_lane_change_dir, save_name_prefix, theta_ts, c_ts);
        end
    end
end
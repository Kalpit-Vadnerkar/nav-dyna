function save_data(maneuver_dir, save_name_prefix, theta_ts, c_ts)
    save_path_steer = fullfile(maneuver_dir, [save_name_prefix '_steer.mat']);
    save_path_force = fullfile(maneuver_dir, [save_name_prefix '_force.mat']);

    % Print paths for debugging
    fprintf('Saving to %s\n', save_path_steer);
    fprintf('Saving to %s\n', save_path_force);

    save(save_path_steer, 'theta_ts', "-v7.3");
    save(save_path_force, 'c_ts', "-v7.3");
end
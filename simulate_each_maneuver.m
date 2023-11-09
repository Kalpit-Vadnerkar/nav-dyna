function simulate_each_maneuver(model_name, maneuver_dir, result_maneuver_dir, u0)
    % Get all steer and force files for this maneuver
    steer_files = dir(fullfile(maneuver_dir, '*_steer.mat'));
    force_files = dir(fullfile(maneuver_dir, '*_force.mat'));

    % Check if same number of steer and force files are present
    if length(steer_files) ~= length(force_files)
        error('Mismatch in number of steer and force files for maneuver: %s', maneuver_dir);
    end

    % Loop over all input files for this maneuver
    for i = 1:length(steer_files)
        run_simulation(model_name, maneuver_dir, steer_files(i).name, force_files(i).name);
        save_simulation_results(result_maneuver_dir, steer_files(i).name, u0);
    end
end
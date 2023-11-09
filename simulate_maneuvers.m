function simulate_maneuvers(maneuvers, input_folder, results_folder, model_name, u0)
    % Loop over all maneuvers
    for m = 1:length(maneuvers)
        maneuver_dir = fullfile(input_folder, maneuvers{m});
        result_maneuver_dir = fullfile(results_folder, maneuvers{m}, ['Velocity_', num2str(u0)]);
        check_and_create_dir(result_maneuver_dir);
        simulate_each_maneuver(model_name, maneuver_dir, result_maneuver_dir, u0);
    end
end

function save_simulation_results(result_maneuver_dir, steer_file_name, u0)
    % Save the simulation results
    result_file_name = ['Velo_' num2str(u0) '_Result_' steer_file_name(1:end-10) '.mat'];
    save(fullfile(result_maneuver_dir, result_file_name), 'u', 'v', 'r', 'xu', 'xy', 'theta', 'force');
    disp(['Simulation completed for ' steer_file_name(1:end-10) ' with initial velocity: ' num2str(u0) ' m/s']);
end
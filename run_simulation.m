function run_simulation(model_name, maneuver_dir, steer_file_name, force_file_name)
    % Set input files in Simulink model
    set_param([model_name '/From File1'], 'FileName', fullfile(maneuver_dir, steer_file_name));
    set_param([model_name '/From File 2'], 'FileName', fullfile(maneuver_dir, force_file_name));
    
    % Run the simulation
    sim(model_name);
end
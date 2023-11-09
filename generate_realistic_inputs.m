function [theta_ts, c_ts] = generate_realistic_inputs(maneuver_type, dt, total_time, theta_value, c_accel)
    t = 0:dt:total_time;
    theta_values = zeros(size(t));
    c_values = zeros(size(t)); % Initialize with no acceleration

    segment_time = total_time / length(maneuver_type);
    increase_time = segment_time / 3;  
    constant_time = segment_time / 3;  
    decrease_time = segment_time / 3;  

    c_brake = -100; % Braking value in N
    c_coast = 0; % No acceleration or braking
    brake_portion = 1/3; % Braking for the last third of the increasing time

    for i = 1:length(maneuver_type)
        start_idx = max(1, round((i-1) * segment_time / dt) + 1);
        brake_start_idx = min(length(t), start_idx + round(increase_time * (1-brake_portion) / dt));
        increase_end_idx = min(length(t), brake_start_idx + round(increase_time * brake_portion / dt));
        constant_end_idx = min(length(t), increase_end_idx + round(constant_time / dt));
        end_idx = min(length(t), constant_end_idx + round(decrease_time / dt));

        switch maneuver_type(i)
            case 'S'
                % Accelerate - coast - accelerate
                c_values(start_idx:brake_start_idx) = c_accel;
                c_values(brake_start_idx:increase_end_idx) = c_coast;
                c_values(increase_end_idx:end_idx) = c_accel;

            case {'L', 'R'}
                % Brake just before turn
                c_values(brake_start_idx:increase_end_idx) = c_brake;
                % Coast during the turn
                c_values(increase_end_idx:end_idx) = c_coast;

                if maneuver_type(i) == 'L'
                    theta_values(start_idx:brake_start_idx) = linspace(0, theta_value * (1-brake_portion), brake_start_idx - start_idx + 1);
                    theta_values(brake_start_idx:increase_end_idx) = linspace(theta_value * (1-brake_portion), theta_value, increase_end_idx - brake_start_idx + 1);
                    theta_values(increase_end_idx:constant_end_idx) = theta_value;
                    theta_values(constant_end_idx:end_idx) = linspace(theta_value, 0, end_idx - constant_end_idx + 1);
                else
                    theta_values(start_idx:brake_start_idx) = linspace(0, -theta_value * (1-brake_portion), brake_start_idx - start_idx + 1);
                    theta_values(brake_start_idx:increase_end_idx) = linspace(-theta_value * (1-brake_portion), -theta_value, increase_end_idx - brake_start_idx + 1);
                    theta_values(increase_end_idx:constant_end_idx) = -theta_value;
                    theta_values(constant_end_idx:end_idx) = linspace(-theta_value, 0, end_idx - constant_end_idx + 1);
                end
        end
    end

    theta_ts = timeseries(theta_values', t);
    c_ts = timeseries(c_values', t);
end
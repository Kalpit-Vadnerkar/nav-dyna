function [theta_ts, c_ts] = generate_double_lane_change_inputs(dt, total_time, theta_max, c_value)
    % Generates the steering and acceleration time series for the ISO 
    % 3888-1:2018 Double Lane Change maneuver based on given parameters.
    
    % Creating a time vector from 0 to total_time with increments of dt.
    time = 0:dt:total_time-dt;
    
    % Preallocating the theta_ts and c_ts arrays for efficiency.
    theta_ts = zeros(1, length(time));
    c_ts = zeros(1, length(time)) + c_value; % Assuming constant acceleration.

    % Assumed maneuver times based on total_time.
    maneuverStartTime = total_time * 0.2;
    maneuverEndTime = total_time * 0.8;
    
    % Creating a linear space for the maneuver time.
    maneuverTime = maneuverStartTime:dt:maneuverEndTime;
    
    % Generating the steering input theta_ts for the double lane change
    % based on a sinewave.
    theta_ts(time >= maneuverStartTime & time <= maneuverEndTime) = ...
        theta_max * sin(linspace(0, 2*pi, length(maneuverTime)));

     % Convert theta and c arrays into timeseries objects.
    theta_ts = timeseries(theta_ts', time);
    c_ts = timeseries(c_ts', time);
end
% Hulk dynamics parameters
K = 0.061;
T1 = 83.5; % [s]
T2 = 966.3; % [s]
T3 = 543; % [s]
% Steering machine parameters
N = 12; % [deg/s]
PB = 5; % [deg]
deltaMax = 5; % [deg]
% Required course settings
requiredPsi = 15; % [deg]
stepTime = 0; % [s]
% Non-linear function Hb parameters
useHb = true;
b3 = 9.77;
b2 = 2.87;
b1 = -7.32;
b0 = -3.43;
% Using steering machine
useSteeringMachine = false;

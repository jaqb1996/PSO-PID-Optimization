clear all; close all;
% Hulk dynamics parameters
K = 0.061;
T1 = 83.5; % [s]
T2 = 966.3; % [s]
T3 = 543; % [s]
% Parameters of nonlinear spiral curve
b0 = -3.42;
b1 = -7.32;
b2 = 2.87;
b3 = 9.77;
% Steering machine parameters
N = 12; % [deg/s]
PB = 5; % [deg]
deltaMax = 35; % [deg]

rudderAngle = timeseries([0,0,5,5,5,6,7,10], 0:7);

P = 100;
I = 0.3;
D = 0;
simResult = sim('ShipCoureControlModel.slx');

figure;
plot(simResult.tout, simResult.psi);
hold on,
plot(rudderAngle.Time, rudderAngle.Data(:,:));
grid
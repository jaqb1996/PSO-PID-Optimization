clear all; close all;
InitializeShipModelParameters;
P = 0.1;
I = 0.0001;
D = 0;
simResult = sim('ShipCoureControlModel.slx', 'StopTime', '5000');

figure;
plot(simResult.tout, simResult.psi);
hold on,
plot([simResult.tout(1), simResult.tout(end)], [requiredPsi, requiredPsi]);
grid;
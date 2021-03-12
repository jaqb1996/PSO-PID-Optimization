clear all; close all;
InitializeShipModelParameters;
P = 0.0001;
I = 0;
D = 0;
simResult = sim('ShipCoureControlModel.slx', 'StopTime', '2000');

figure;
plot(simResult.tout, simResult.psi);
hold on,
plot([simResult.tout(1), simResult.tout(end)], [requiredPsi, requiredPsi]);
grid;
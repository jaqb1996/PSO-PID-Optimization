clear all; close all;
InitializeShipModelParameters;
P = 1;
I = 0.001;
D = 0;
simResult = sim('ShipCoureControlModel.slx', 10000);

figure;
plot(simResult.tout, simResult.psi);
hold on,
plot([simResult.tout(1), simResult.tout(end)], [requiredPsi, requiredPsi]);
grid;
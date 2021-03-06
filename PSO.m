
%dla 10, 20 => KP = 0.3932; KI = 0.1511; KD = 0.0300; Je_best = 15

%% Inicjalizacja parametrow i poczatkowych wartosci 
clc; clear all; close all
  
InitializeShipModelParameters;

nPop = 5; %wielkosc populacji
n_iter = 20;

StopTime = 5000;

Tp = 10.7; %???????????????

W = 0.73; %wspolczynnik wagowy inercji
c1 = 2.05;  c2 = 2.05;  %stale przyspieszenia okreslajace jak mocno czasteczki daza do swoich PBEST i GBEST

Kp(nPop) = 0; Ki(nPop) = 0; Kd(nPop) = 0; 
Je(nPop) = 0; %wskaznik jakosci

Kp_prim(nPop) = 0; Ki_prim(nPop) = 0; Kd_prim(nPop) = 0; 
Je_prim(nPop) = 0;

Kp_min = 0; Kp_max = 5;
Ki_min = 0; Ki_max = 0.5;
Kd_min = 0; Kd_max = 0.10; % max 0.1??

% PBEST
Kp_best(nPop) = 0; Ki_best(nPop) = 0; Kd_best(nPop) = 0;

% History of positions
useHistory = true;
if useHistory
    history = zeros(nPop, 3, n_iter + 1);
    whichParticleBest = ones(1, n_iter + 1);
end
%% Losowanie pozycji poczatkowej z przestrzeni rozwiazan
for i = 1:nPop
    Kp_rand = Kp_min + (Kp_max - Kp_min)*rand(1,1);
    Ki_rand = Ki_min + (Ki_max - Ki_min)*rand(1,1);
    Kd_rand = Kd_min + (Kd_max - Kd_min)*rand(1,1);
    
    Kp(i) = Kp_rand;    Ki(i) = Ki_rand;    Kd(i) = Kd_rand;
    if useHistory
        history(i,:,1) = [Kp(i), Ki(i), Kd(i)];
    end
end

for i = 1:nPop
    P = Kp(i); I = Ki(i); D = Kd(i);
    simResult = sim('ShipCoureControlModel.slx', StopTime);
    CalculateLoss;
    Je(i) = loss;
end
    
%% Zapis aktualnej pozycji czastki jako najlepszego lokalnego rozwiazania

for i = 1:nPop
    Kp_best(i) = Kp(i);
    Ki_best(i) = Ki(i);
    Kd_best(i) = Kd(i);
end

%% Sprawdzanie jakosci pozycji

Je_best = Je(1); 
Kp_BEST = Kp(1); Ki_BEST = Ki(1); Kd_BEST = Kd(1);

for i = 1:nPop
    if Je(i) < Je_best
        Je_best = Je(i);
        if useHistory
            whichParticleBest(1) = i;
        end
        Kp_BEST = Kp(i); Ki_BEST = Ki(i); Kd_BEST = Kd(i);
    end
end

for cnt_iter = 1:n_iter
    %% Aktualizacja predkosci
    for i = 1:nPop
        rand1 = rand; rand2 = rand; rand3 = rand;
        rand4 = rand; rand5 = rand; rand6 = rand;

        Kp_prim(i) = W*Kp_prim(i) + c1*rand1*(Kp_best(i)-Kp(i)) + c2*rand2*(Kp_BEST-Kp(i));
        Ki_prim(i) = W*Ki_prim(i) + c1*rand3*(Ki_best(i)-Ki(i)) + c2*rand4*(Ki_BEST-Ki(i));
        Kd_prim(i) = W*Kd_prim(i) + c1*rand5*(Kd_best(i)-Kd(i)) + c2*rand6*(Kd_BEST-Kd(i));
        
        if Kp_prim(i) > Kp_max
            Kp_prim(i) = Kp_max - CalculateExcess(Kp_min, Kp_max, Kp_prim(i));
        end
        
        if Kp_prim(i) < Kp_min
            Kp_prim(i) = Kp_min + CalculateUnderflow(Kp_min, Kp_max, Kp_prim(i));
        end

        if Ki_prim(i) > Ki_max
            Ki_prim(i) = Ki_max - CalculateExcess(Ki_min, Ki_max, Ki_prim(i));
        end
        
        if Ki_prim(i) < Ki_min
            Ki_prim(i) = Ki_min + CalculateUnderflow(Ki_min, Ki_max, Ki_prim(i));
        end

        if Kd_prim(i) > Kd_max
            Kd_prim(i) = Kd_max - CalculateExcess(Kd_min, Kd_max, Kd_prim(i));
        end
        
        if Kd_prim(i) < Kd_min
            Kd_prim(i) = Kd_min + CalculateUnderflow(Kd_min, Kd_max, Kd_prim(i));
        end
    end

    %% Aktualizacja polozen
    for i = 1:nPop
        Kp(i) = Kp(i) + Kp_prim(i); 
        Ki(i) = Ki(i) + Ki_prim(i);
        Kd(i) = Kd(i) + Kd_prim(i);
        
        %Dla KP
        if Kp(i) > Kp_max
            Kp(i) = Kp_max - (Kp(i) - Kp_max);

        end                
        if Kp(i) < Kp_min
            Kp(i) = Kp_min + (Kp_min - Kp(i));
        end
        
        %Dla KI
        if Ki(i) > Ki_max
            Ki(i) = Ki_max - (Ki(i) - Ki_max);
        end
        if Ki(i) < Ki_min
            Ki(i) = Ki_min + (Ki_min - Ki(i));
        end

        %Dla KD
        if Kd(i) > Kd_max
            Kd(i) = Kd_max - (Kd(i) - Kd_max);
        end
        if Kd(i) < Kd_min
            Kd(i) = Kd_min + (Kd_min - Kd(i));
        end
        % Add position to history
        if useHistory
            history(i,:,cnt_iter + 1) = [Kp(i), Ki(i), Kd(i)];
        end
    end
    
    %% Sprawdzenie jakosci po aktualizacji
    for i = 1:nPop
        P = Kp(i); I = Ki(i); D = Kd(i);
        try
            simResult = sim('ShipCoureControlModel.slx', StopTime);
            CalculateLoss;
            Je_prim(i) = loss;  
        catch
            warning('Problem with simulation. Assigning loss = inf');
            Je_prim(i) = inf;
        end

     end

    %% Porownanie Je, wyznaczenie pbest i gbest
    if useHistory
        whichParticleBest(cnt_iter + 1) = whichParticleBest(cnt_iter);
    end
    for i = 1:nPop
        if Je_prim(i) < Je(i)
            Je(i) = Je_prim(i);
            Kp_best(i) = Kp(i); Ki_best(i) = Ki(i); Kd_best(i) = Kd(i);
        end
        
        if Je(i) < Je_best
            Je_best = Je(i);
            if useHistory
                whichParticleBest(cnt_iter + 1) = i;
            end
            Kp_BEST = Kp(i); Ki_BEST = Ki(i); Kd_BEST = Kd(i);
        end
    end
    % Show which iteration finished
    cnt_iter
end
%% Save history
if useHistory
    save('history.mat', 'history', 'whichParticleBest');
end
%% Wyniki PID

P = Kp_BEST; I = Ki_BEST; D = Kd_BEST;

simResult = sim('ShipCoureControlModel.slx', StopTime);

figure;
plot(simResult.tout, simResult.psi);
hold on,
plot([simResult.tout(1), simResult.tout(end)], [requiredPsi, requiredPsi]);
grid;
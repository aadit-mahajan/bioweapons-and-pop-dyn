% 1. susceptible 
% 2. latent 
% 3. infected
% 4. recovered
% 5. dead

% consider the values for these parameters to be default for now. 

delta = 0.20;         % recovered to susceptible (rate at which people lose immunity to the disease) 

beta = 0.26;          % susceptible to latent (rate at which susceptible people are infected but dont yet become infectious themselves)

omega = 0.5;          % latent to infected (rate at which latent people start experiencing symptoms)

gamma = 0.77;         % infected to recovered (recovery rate)

lambda = 0.02;        % death rate

seed_population = 10;
tStart = 0;
tEnd = 100;
timespan = [tStart, tEnd];

y0 = [10000, 0, seed_population, 0, 0];

[t, y] = ode45(@(t, y) slirds_model(t, y, delta, beta, omega, gamma, lambda), timespan, y0);

S = y(:, 1);
L = y(:, 2);
I = y(:, 3);
R = y(:, 4);
D = y(:, 5);
% 
% Plot the results
figure;
plot(t, S, 'b', t, L, 'm', t, I, 'r', t, R, 'g', t, D, 'k', 'LineWidth', 2);
legend('Susceptible', 'Latent', 'Infected', 'Recovered', 'Dead');
xlabel('Time');
ylabel('Population');
title('SLIRDS Model - ode45 Simulation');
grid on;


% Analysis of changing the parameters in the simulation
% 1. Changing delta 
% 2. Changing beta 
% 3. Changing omega
% 4. Changing gamma
% 5. Changing lambda
% 6. Changing initial infected population

figure;
delta_vals = linspace(0.2, 0.3, 20);
beta_vals = linspace(0.2, 0.25, 20);
ys = {};
xs = {};
time = {};
for i = 1:20
    [t, y] = ode45(@(t, y) slirds_model(t, y, delta, beta_vals(i), omega, gamma, lambda), timespan, y0);
    xs = [xs, beta_vals(i)];
    ys = [ys, y];
    time = t;
end
hold on 
for i = 1:length(ys)
    y_temp = ys(i); x_temp = xs(i);
    y_temp_vals = y_temp{1, 1}; x_temp_vals = x_temp{1, 1};
    plot(y_temp_vals(1, :), LineWidth=2);
    xlabel('time')
    ylabel('susceptible')
    title('delta effect on Susceptibility')
end
%%
function dydt = slirds_model(t, y, delta, beta, omega, gamma, lambda)

    dy(1) = delta * y(4) - beta * y(1) * y(3);
    dy(2) = delta * y(1) * y(3) - omega * y(2);
    dy(3) = omega * y(2) - gamma * y(3) - lambda * y(5);
    dy(4) = gamma * y(3) - delta * y(4);
    dy(5) = lambda * y(3);

    dydt = [dy(1); dy(2); dy(3); dy(4); dy(5)];

end





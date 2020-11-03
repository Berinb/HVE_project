%Numerical State Space Solution
%Author: Berin Balje 

%% Pararameters
T = 0.1;           % Simulation Time..
x0 =  [0; 0];      % Initial Conditions
tspan = [0, T];    % Time span 

R = 100;               
L = 100e-3;           
C = 50e-6;            
Vi = 100;             % Input Voltage

%% RLC Circuit Dynamic - State-Space Model

% y(1) = d (I_ind);    y(2) = d (V_cap);
%        /dt               /dt
y =@(t,x) [-R/L, -1/L; 1/C, 0]*x + [1/L; 0]*Vi;

%% ODE Solver 
[t, x] = ode45(@(t,x) y(t,x), tspan, x0); 

% Plot Current thru Inductor & Voltage across Capacitor
I_ind = x(:,1);    V_cap = x(:,2);

subplot(2,1,1);
plot(t, V_cap, 'b', 'linewidth',0.75); 
grid on;
title('Series RLC Circuit - Voltage across Capacitor'); 
xlabel('Time (sec)');
ylabel('Voltage (V)');
    
subplot(2,1,2);
plot(t, I_ind, 'r', 'linewidth',0.75);
grid on;
title('Series RLC Circuit - Current thru Inductor'); 
xlabel('Time (sec)');
ylabel('Current (A)');
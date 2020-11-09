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
Rexp=1;
%% RLC Circuit Dynamic Model -> State-Space Model (When Spark gap 1 is conducting)

% y(1) = d (I_ind);    y(2) = d (V_cap);
%        /dt               /dt
y =@(t,x) [-R/L, -1/L; 1/C, 0]*x + [1/L; 0]*Vi;

% ODE Solver 
[t, x] = ode45(@(t,x) y(t,x), tspan, x0); 

% Plot Current thru Inductor & Voltage across Capacitor
I_ind = x(:,1);    V_cap = x(:,2);

figure(1)
subplot(2,1,1);
plot(t, I_ind, 'r', 'linewidth',0.75);
grid on;
title('Series RLC Circuit (Spark Gap 1) Current thru Inductor'); 
xlabel('Time (sec)');
ylabel('Current (A)');

subplot(2,1,2);
plot(t, V_cap, 'b', 'linewidth',0.75); 
grid on;
title('Series RLC Circuit (Spark Gap 1) Voltage across Capacitor'); 
xlabel('Time (sec)');
ylabel('Voltage (V)');


%% RL circuit model -> exponential decay  (When spark gap 2 is conducting)

tau=L/(Rexp);
t2=0:(t(2)-t(1)):tau*6;
I_decay= max(I_ind)*exp(-(t2)/(tau))';
figure(2)
plot(t2,I_decay)
title('Series RL Circuit (Spark Gap 2) Current thru Inductor'); 
xlabel('Time (sec)');
ylabel('Current (A)');
grid on

%% Combining  parts of spark gap 1 and spark gap 2

peakinx=find(I_ind==max(I_ind));
pulse=cat(1,I_ind(1:peakinx),I_decay);
t_pulse = linspace(0,(max(t)+max(t2)),length(pulse));

figure(2)
plot(t_pulse,pulse)




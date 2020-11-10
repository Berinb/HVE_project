% Analytical solution of ODE 
% Author : Muaaz Amjad

%% Symbolic I(t)
syms I(t) 
%% parameters
R = 30;       
Rp = 20;
L =1e-3;           
C = 10e-6;            
Vi = 100000;
tau = L/R;
%% Representing Derivative by creating symbolic function 
Di = diff(I);
%% ODE
ode = L*diff(I,t,2)+ (R+Rp)*diff(I,t)+(1/C)*I(t) == 0;
%% ICs
cond1 = I(0)==0;
cond2 = L*Di(0)==Vi;
conds = [cond1 cond2];
%% Solve ODE for I
iSol(t) = dsolve(ode,conds);
iSol = simplify(iSol);
%% Voltage across capacitor 

v = (1/C)*int(iSol)+Vi;

%% Time array for SG1 ignition
t = linspace(0,5e-3);  % from t = 0 to t = t1 ( rise time of pulse)

%% Exponentially decaying part RL circuit when SG2 is ignited
i_peak = double(max(iSol(t)));
t_fall = linspace(0,3.5e-4);           % computing from t = 0 to 350us
i_exp = i_peak*(exp(-t_fall/tau));

%% Plotting Voltage across capacitor and current through inductor due to SG1 ignition for t = 0 to 5ms
figure(1)
subplot(2,1,2)
plot(t,iSol(t));
title('Inductor current')
xlabel('Time[s]')
ylabel('i(t) [A]')

subplot(2,1,1)
plot(t,v(t))
title('Voltage across capacitor')
xlabel('Time[s]')
ylabel('v(t) [V]')

%% Combining ignition of SG1 at t = 0 and ignition of SG2 at t = 50us

t1 = linspace(0,5e-5);                   % Rise time array of pulse t = 0 to 50us 
figure(2)
hold on 
plot(t1,iSol(t1));
plot(linspace(t1(end),3.5e-4),i_exp);    % fall time array of pulse t = 50us to 350us
hold off 
title(' Current plot for SG1 and SG2 during specific time intervals');
xlabel('time [s]');
ylabel('i(t) [A]');













%% Q and W/R within 5 ms 

% Q = int(iSol,0,5e-3) % copy the answer in the command window and click enter to get the numerical result 
% Q = 0.1000 . From Zeller Q = I_peak*5e-4 = 200*5e-4 = 0.1000


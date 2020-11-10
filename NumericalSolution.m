% Analytical solution of ODE 
% Author : Muaaz Amjad



%% Symbolic I(t)
syms I(t) 
%% parameters
R = 10;       
Rp = 10;
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

%% rise time array 
t = linspace(0,5e-3);  % from t = 0 to t = t1 ( rise time of pulse)

%% Exponentially decaying part RL circuit when SG2 is ignited
i_peak = double(max(iSol(t)));
t_fall = linspace(0,3e-4);
i_exp = i_peak*(exp(-t_fall/tau));

%% Plotting Voltage across capacitor and current through inductor due to SG1 ignition
subplot(2,1,2)
plot(t,iSol(t));
title('Inductor current')
xlabel('Time[s]')
ylabel('i(t) [A]')

subplot(2,1,1)
plot(t,v(t))
title('Voltage across capacitor')
xlabel('Time[s]')
ylabel('v(t)')

%% Combining ignition of SG1 at t = 0 and ignition of SG2 at t = 50us
plot(linspace(t(end),3.5e-4),i_exp);












%% Q and W/R within 5 ms 

% Q = int(iSol,0,5e-3) % copy the answer in the command window and click enter to get the numerical result 
% Q = 0.1000 . From Zeller Q = I_peak*5e-4 = 200*5e-4 = 0.1000


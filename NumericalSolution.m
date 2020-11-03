% Analytical solution of ODE 
% Author : Muaaz Amjad



%% Symbolic I(t)
syms I(t) 
%% parameters

L = 1e-3;
C = 1e-6;
R = 510;
V = 100000;
%% Representing Derivative by creating symbolic function 
Di = diff(I);
%% ODE
ode = L*diff(I,t,2)+ R*diff(I,t)+(1/C)*I(t) == 0;
%% ICs
cond1 = I(0)==0;
cond2 = L*Di(0)==V;
conds = [cond1 cond2];
%% Solve ODE for I
iSol(t) = dsolve(ode,conds);
iSol = simplify(iSol);
%% Plotting 
t = linspace(0,350e-6);  % for a 10/350 pulse. At t = 350us the current amplitude should be 50% of the I_peak
plot(t,iSol(t));

%% Q and W/R within 5 ms 

Q = int(iSol,0,5e-3) % copy the answer in the command window and click enter to get the numerical result 
% Q = 0.1000 . From Zeller Q = I_peak*5e-4 = 200*5e-4 = 0.1000


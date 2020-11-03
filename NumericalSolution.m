%Numerical State Space Solution
%Author: Berin Balje 

%% An attempt to solve the differential equation 
%% Symbolic I(t)
syms I(t) 
%% parameters

L = 1e-6;
C = 1e-6;
Cp= 2e-3;
R = 50;
Rp =50;
V1 = 10000;
%% Representing Derivative by creating symbolic function 
Di = diff(I);
%% ODE
ode = L*diff(I,t,2)+ (R+Rp)*diff(I,t)+(1/C)*I(t) == 0;
%% ICs
cond1 = I(0)==0;
cond2 = L*Di(0)==V1;
conds = [cond1 cond2];
%% Solve ODE for I
iSol(t) = dsolve(ode,conds);
iSol = simplify(iSol);
%% Plotting 
t = linspace(0,350e-6);  % for a 10/350 pulse. At t = 350us the current amplitude should be 50% of the I_peak
figure(1)
plot(t,iSol(t));

%% Q and W/R within 5 ms 

Q = int(iSol,0,5e-3) ;% copy the answer in the command window and click enter to get the numerical result 

%% ode45 Solution (Parasitic effect of components)
syms y(t)
[V] = odeToVectorField(diff(y, 2) == (R+Rp)*diff(y,t)+(1/(C+Cp)*y(t)));
M = matlabFunction(V,'vars', {'t','Y'});
sol = ode45(M,[0 355e-6],[10 0]);
figure(2)
fplot(@(x)deval(sol,x,1), [0, 355e-6])

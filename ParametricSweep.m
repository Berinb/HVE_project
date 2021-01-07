% Parametric Sweep for the Crowbar pulse genereator model
% Author: Berin Balje
% Company: FH Wels

%% Define Range of parameters

%Capacitor and protection Resistances stages
stages = 10;
C = 1e-6*ones(stages,1);
Rp = 1 * ones(stages,1);
U = 100e3 * ones(stages, 1);
%Modify for parallel interconecction
for i=1:length(C)
    C(i)= i*C(1); 
    Rp(i) = Rp(1)/i;
    U(i) = U(1)*i;
end

% L and R
resolution = 100;
L = linspace(10e-10, 10e-6, resolution);
R = linspace(10, 1000, resolution); 

% ODE paremeters
T = 0.1;           % Simulation Time..
x0 =  [0; 0];      % Initial Conditions
tspan = [0, T];    % Time span 

%% Main Loop 
n=1;
for s = 1: stages
    
%Save Matrix 
Save = ones(resolution^2, 4); p=1;
 
    for l = 1: length(L)
        
        for r = 1: length(R)
                       
           % State space RLC model
           y =@(t,x) [-R(r)/L(l), -1/L(l); 1/C(s), 0]*x + [1/L(l); 0]*U(s);
           % ODE Solver 
           [t, x] = ode45(@(t,x) y(t,x), tspan, x0);          
           Ipulse =  x(:,1);
            
           % Find peak current
           Ipeak = max(Ipulse); 
           inx_peak = find(Ipulse == Ipeak);
           %Time when peak is reached
           t_peak = t(inx_peak);
           
           % SAVING if t_peak is smaller than 50micro seconds
           if(t_peak< 50e-6)           
           Save(p,1) = R(r); Save(p,2) = L(l);
           Save(p,3) = Ipeak;  Save(p,4) = t_peak; 
           p=p+1;
           end
           
           disp(n);
           n=n+1;
           
            
        end
          
    end
    
    % Create Excel 
    
      
end




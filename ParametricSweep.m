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
resolution = 5;
L = linspace(10e-10, 10e-6, resolution);
R = linspace(1, 1000, resolution); 

% ODE paremeters
T = 0.1;           % Simulation Time..
x0 =  [0; 0];      % Initial Conditions
t = linspace(0,3.5e-4,500);    % Time span 

%% Main Loop 
n=1;
for s = 1: stages
    
%Save Matrix 
Save = ones(resolution^2, 4); p=1;
 
    for l = 1: length(L)
        
        for r = 1: length(R)
                       
          % Analytical solution of RLC circuit 
           alpha = (1/2)*((R+Rp)/L);
           w0 = 1/(sqrt(L*C));
       if(((alpha^2) - (w0^2)) < 0)      % condition for underdamped solution         
               e1 = - alpha + sqrt((alpha^2) - (w0^2));
               e2 = - alpha - sqrt((alpha^2) - (w0^2));
               Ipulse = (U*(exp(e1*t)-exp(e2*t)))/((e1-e2)*L);
          
               
           % Find peak current
           Ipeak = max(Ipulse); 
           inx_peak = find(Ipulse == Ipeak);
           %Time when peak is reached
           tpeak = t(inx_peak);
           % post processing of 10%,50%,90% 
            i90 = 0.9*Ipeak;      % y1
            [~,inx_90] = find_near(Ipulse(1:inx_peak),i90); 
            t90_all = t(1:inx_peak);
            t90 = t90_all(inx_90);      %x1
            i10 = 0.1*Ipeak;    % y2
           [~,inx_10] = find_near(Ipulse(1:inx_peak),i10); 
           t10_all = t(1:inx_peak);
            t10 = t10_all(inx_10);   %x8
            
            i50 = 0.5*Ipeak;
           [~,inx_50] = find_near(Ipulse(inx_peak:end),i50); 
           t50_all=t(inx_peak:end);
            t50 = t50_all(inx_50);            
            
            x = linspace(0,tpeak+(tpeak*0.5),1000);       
            grad = (i10-i90)/(t10-t90);            
            line = grad*(x-t90) + i90; 
            
            hold on 
            plot(t,Ipulse)
            plot(x,line)
            hold off
            
            % when is line = ipeak. Finding time for line peak to reach
            % Ipeak
            
             [~,inx_linepeak] = find_near(line,Ipeak);
            t100 = x(inx_linepeak);
            
            inx_linezero = find(line == 0);
            t0 = x(1);
            
            % 8/20 us standard timing calculation 
            
            T1 = t100-t0;
            T1_tol = T1 * 0.2;
            T2 = t50-t0;
            T2_tol = T2*0.2;
            
           % SAVING if t_peak is smaller than 50micro seconds
           if((T1 > (T1-T1_tol) && T1 < (T1+T1_tol) ) && (T2 > (T2-T2_tol) && T2 <(T2+T2_tol)))           
           Save(p,1) = R(r); Save(p,2) = L(l);
           Save(p,3) = Ipeak;  Save(p,4) = t_peak; 
           p=p+1;
           end
      end 
           disp(n);
           n=n+1;
           
            
        end
          
    end
    
    % Create Excel 
    xlswrite(num2str(s),Save);
    
      
end




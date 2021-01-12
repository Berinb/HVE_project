    R = 10;
    Rp = 1;
    L = 1e-4;
    C = 1e-6;
    U = 100e3;


    t = linspace(0,10e-5,1000);



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
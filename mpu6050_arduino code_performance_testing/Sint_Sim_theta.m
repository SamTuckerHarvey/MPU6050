% Parameters
T0 = clock;
theta = 1.7*(pi()/180);
OMEGA = 2/1000; % Angular Frequency (Hz)
tlaststep = 0;
Ang = 0;
Angout = [0];
Tout = [0];
A = 45*(pi()/180);


for j = 1:500000
   t = round(etime(clock,T0)*1000); % t = millis();
   Angtheor = A*sin(OMEGA*2*pi()*t);
   AngRate = cos(OMEGA*((2*pi())*t));
   
   if Ang - theta >= (Angtheor) && AngRate <= 0
      Ang = Ang - theta; % Step Angle 
      
      Angout = [Angout Ang];
      Tout = [Tout etime(clock,T0)*1000];
   
   elseif Ang <=(Angtheor + theta) && AngRate >= 0
      Ang = Ang + theta; % Step Angle 
      
      Angout = [Angout Ang];
      Tout = [Tout etime(clock,T0)*1000];
     
   end
   

   
end
    
    
   plot(Tout,Angout,'*')
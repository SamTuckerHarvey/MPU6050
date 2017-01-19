
% Simulation loop
T0 = clock;
theta = 1.7*(pi()/180);
OMEGA = 2/1000; % Angular Frequency (Hz)
tlaststep = 0;
Ang = 0;
Angout = [0];
Tout = [0];

for j = 1:100000
t = etime(clock,T0)*1000; % t = millis();

AngRate = sin(OMEGA*((2*pi())*t));
Tstep = abs((1/AngRate)*theta);

    if t>=Tstep + tlaststep
       if AngRate>0 
           Ang = Ang + theta;
       
       elseif AngRate <= 0
           Ang = Ang - theta;
       end
       
        Angout = [Angout; Ang];
        tlaststep = etime(clock,T0)*1000;
        Tout = [Tout; tlaststep];
    end
end

plot(Tout,Angout)
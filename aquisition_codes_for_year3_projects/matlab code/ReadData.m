% Data Filename
Filename = inputdlg('Enter File Name');
Filename = char(Filename);

% Initialise Serial Connection
PORT = '/dev/cu.usbmodem1411';
Serialobj = serial(PORT);
set(Serialobj,'BaudRate',115200);
fopen(Serialobj);

DATA = zeros(1,100);
DATA = string(DATA);

init = 0;
while init == 0
    if Serialobj.BytesAvailable > 0
   DATA= fscanf(Serialobj); 
    end
    
    if DATA(1) == 'S'
        init = 1;
    end
end    

% Begin Reading Accelerometer
fwrite(Serialobj,'a');
display('Reading Data');

% Data Capture Series Length
n = 250000;
%n = 5000;

MDATA = zeros(n,1);
TIME = zeros(n,6);
TIME(1,:) = clock;
MDATA = string(MDATA);

j = 10^6; % Iterator
pause(5);
while j<=n
    if Serialobj.BytesAvailable > 0
   DATAacc= fscanf(Serialobj);
   MDATA(j) = DATAacc;
    end
    
    j = j+1;
    
end    

% End Serial Communication
EndSerial(Serialobj)

% Data Modification

MDATA(all(MDATA=='0',2),:)=[]; % Remove zero rows (DATA)

% Data separation
YAW = zeros(1,length(MDATA));
PITCH = zeros(1,length(MDATA));
ROLL = zeros(1,length(MDATA));
Telapsed = zeros(1,length(MDATA));

for k = 10:length(MDATA)
    split = strsplit(MDATA(k,:));
    
    YAWstr = split(2);
    PITCHstr = split(3);
    ROLLstr = split(4);
    Telapsedstr = split(5);
    
    YAWchar = char(YAWstr);
    PITCHchar = char(PITCHstr);
    ROLLchar = char(ROLLstr);
    Telapsedchar = char(Telapsedstr);
    
    YAW(k) = str2double(YAWchar);
    PITCH(k) = str2double(PITCHchar);
    ROLL(k) = str2double(ROLLchar);
    Telapsed(k) = str2double(Telapsedchar);
   
end

% Data Plotting 
% figure(1)
% plot(Telapsed,YAW,Telapsed,PITCH,Telapsed,ROLL)
% title('Yaw Pitch and Roll Angles over Time')
% xlabel('Time (s)')
% ylabel('Angle (deg)')
% grid on
% legend('Yaw Angle','Pitch Angle','Roll Angle')

figure(2)
plot(Telapsed,PITCH,Telapsed,ROLL,Telapsed,YAW)
title('Pitch and Roll Angles over Time')
xlabel('Time (s)')
ylabel('Angle (deg)')
grid on
legend('Pitch Angle','Roll Angle','Yaw Angle')


% Save Data to File
save(Filename,'Telapsed','YAW','PITCH','ROLL','Telapsed')

% % Data Filename
% Filename = inputdlg('Enter File Name');
% Filename = char(Filename);

% Initialise Serial Connection
PORT = '/dev/cu.usbmodem1411';
Serialobj = serial(PORT);
set(Serialobj,'BaudRate',115200);
fopen(Serialobj);

DATA = zeros(1,100);
DATA = string(DATA);


disp('Data Reading...')

% Data Capture Series Length
n = (10^6); % Approx 30 min
%n = 5000;

MDATA = zeros(n,1);
TIME = zeros(n,6);
TIME(1,:) = clock;
MDATA = string(MDATA);

T0 = clock();

j = 1; % Iterator
pause(5);
while j <= n
    if Serialobj.BytesAvailable > 0
   DATAacc= fscanf(Serialobj);
   MDATA(j) = DATAacc;
    end
    
    j = j+1;
    
end    

T1 = clock;

disp('Data Aquired')

% End Serial Communication
EndSerial(Serialobj)

% Data Modification

MDATA(all(MDATA=='0',2),:)=[]; % Remove zero rows (DATA)
TIME(all(TIME==0,2),:)=[]; % Remove zero rows (TIME SERIES)

% Data separation
Axnum = zeros(1,length(MDATA));
Aynum = zeros(1,length(MDATA));
Aznum = zeros(1,length(MDATA));

Gxnum = zeros(1,length(MDATA));
Gynum = zeros(1,length(MDATA));
Gznum = zeros(1,length(MDATA));

Telapsednum = zeros(1,length(MDATA));

for k = 10:length(MDATA)
    split = strsplit(MDATA(k,:));
    
    if length(split) >= 7
    
    Ax = split(1);
    Ay = split(2);
    Az = split(3);
    Gx = split(4);
    Gy = split(5);
    Gz = split(6);
    Telapsed = split(7);

    Ax = char(Ax);
    Ay = char(Ay);
    Az = char(Az);
    Gx = char(Gx);
    Gy = char(Gy);
    Gz = char(Gz);
    Telapsed = char(Telapsed);
    
    Axnum(k) = str2double(Ax);
    Aynum(k) = str2double(Ay);
    Aznum(k) = str2double(Az);
    Gxnum(k) = str2double(Gx);
    Gynum(k) = str2double(Gy);
    Gznum(k) = str2double(Gz);
    Telapsednum(k) = str2double(Telapsed);
    end
end

% Conversion to ms-2, deg/s
g = 9.81;
Afactdeg = (8)/32767;
Gfactdeg = 2000/32767;

Axms = Axnum*Afactdeg;
Ayms = Aynum*Afactdeg;
Azms = Aznum*Afactdeg;

Gxdeg = Gxnum*Gfactdeg;
Gydeg = Gynum*Gfactdeg;
Gzdeg = Gznum*Gfactdeg;


ALLDATA = [Axms' Ayms' Azms' Gxdeg' Gydeg' Gzdeg' Telapsednum'];
figure(1)
FigTitles = [string('Ax'),string('Ay'),string('Az'),string('Gx'),string('Gy'),string('Gz')];
FigYlabs = [string('Acceleration (g)'),string('Acceleration (g)'),string('Acceleration (g)'),... 
    string('Angular Velocity (deg/s)'),string('Angular Velocity (deg/s)'),string('Angular Velocity (deg/s)')];
for j = 1:6
subplot(2,3,j)
plot(Telapsednum,ALLDATA(:,j))
xlabel('Time (s)')
ylabel(FigYlabs(j));
title(FigTitles(j));
grid on
end

% Plot Sampling Rate

figure(2)
plot(Telapsednum(1:length(Telapsednum)-1),diff(Telapsednum));
grid on
title('Sampling Period over Time')
ylabel('Sampling Period (s)')
xlabel('Time (s)')

MeanFsampling = 1/(mean(diff(Telapsednum)*10^-3));
disp('Mean Sampling Frequency:')
disp(MeanFsampling);

% % Save Data to File
% save(Filename,'Telapsed','ALLDATA')

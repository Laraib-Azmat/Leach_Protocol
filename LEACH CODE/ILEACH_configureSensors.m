% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%The 'ILEACH_configureSensors' function is responsible for configuring the sensor nodes in the LEACH protocol.
% Model: Structure containing simulation parameters.
    % n: Number of sensor nodes.
    % GX, GY: Arrays containing the x and y coordinates of the sensor nodes.

function Sensors=ILEACH_configureSensors(Model,n,GX,GY)

%A structure defining the configuration of an empty sensor node with
%default values for various parameters.%

%% Configuration EmptySensor
EmptySensor.xd=0;     %x-dimention
EmptySensor.yd=0;       % y-dimention
EmptySensor.G=0;        %The 'G' attribute represents whether the sensor node has been a cluster head in previous periods
EmptySensor.df=0;        %The df attribute is a dead flag, indicating whether the sensor node is alive or dead. A value of 0 usually indicates that the node is alive%
EmptySensor.type='N';    %Type is node.. its not a cluster head
EmptySensor.E=0;         % initial energy level is 0
EmptySensor.id=0;        % unique identifier
EmptySensor.dis2sink=0; %the distance of the sensor node to the sink (or base station)
EmptySensor.dis2ch=0;   %the distance of the sensor node to its cluster head
EmptySensor.MCH=n+1;    %Member of CH % it indicates that the node is not a member of any cluster initially.

%% Configuration Sensors

% creating an array of sensor nodes (Sensors) based on the template EmptySensor.
% The repmat function is used to replicate the EmptySensor structure to create an array of size (n+1) x 1.%

Sensors=repmat(EmptySensor,n+1,1);

%%Loop%%
for i=1:1:n
    %set x location
    Sensors(i).xd=GX(i); 
    %set y location
    Sensors(i).yd=GY(i);
    %Determinate whether in previous periods has been clusterhead or not? not=0 and be=n
    Sensors(i).G=0;
    %dead flag. Whether dead or alive S(i).df=0 alive. S(i).df=1 dead.
    Sensors(i).df=0; 
    %initially there are not each cluster heads 
    Sensors(i).type='N';
    %initially all nodes have equal Energy
    Sensors(i).E=Model.Eo;
    %id
    Sensors(i).id=i;
    Sensors(i).RR=Model.RR;
    
end 

Sensors(n+1).xd=Model.Sinkx; 
Sensors(n+1).yd=Model.Sinky;
Sensors(n+1).E=100;
Sensors(n+1).id=n+1;
end
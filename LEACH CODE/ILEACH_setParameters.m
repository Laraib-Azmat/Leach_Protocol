% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%The ILEACH_setParameters function is responsible for setting up the initial parameters of 
% the LEACH protocol and saving them in the 'Model' structure%


function [Area,Model]=ILEACH_setParameters(n)


%%%%%%%%%%%%%%%%%%%%%%%%% Set Inital PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

%Field Dimensions - x and y maximum (in meters)
Area.x=1000;
Area.y=1000;

%Sink(base station) Motion pattern... Fixed position at center 
Sinkx=0.5*Area.x;
Sinky=Sinkx;

%Optimal Election Probability of a node to become cluster head
p=0.1;

%%%%%%%%%%%%%%%%%%%%%%%%% Energy Model (all values in Joules)%%%%%%%%%%%

%Initial Energy 
Eo=2;

%Eelec=Etx=Erx
ETX=50*0.000000001;         % Energy consumed for transmitting a bit.
ERX=50*0.000000001;         %Energy consumed for receiving a bit.

%Transmit Amplifier types
Efs=10e-12;         %Energy consumption for free space transmission
Emp=0.0013*0.000000000001;          %Energy consumption for multipath channel transmission 

%Data Aggregation Energy
EDA=5*0.000000001;          %represents the energy consumed during the data aggregation process

%Computation of do (distance parameter)
do=sqrt(Efs/Emp);       %The point where the energy consumption in free space is equal to that in a multipath channel.

%%%%%%%%%%%%%%%%%%%%%%%%% Run Time Parameters %%%%%%%%%%%%%%%%%%%%%%%%%
%maximum number of rounds
rmax=200;

%Data packet size
DpacketLen=4000;

%Hello packet size
HpacketLen=100;         %used for neighbor discovery, synchronization, and assisting in the formation and maintenance of clusters

%Number of Packets sended in steady-state phase
NumPacket=10;

%Radio Range
RR=0.5*Area.x*sqrt(2);

% I-LEACH
numRx=fix(sqrt(p*n));       %The number of radio range or number of circular regions
dr=Area.x/numRx;            % the width of each circular region
%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Save in Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Model.n=n;
Model.Sinkx=Sinkx;
Model.Sinky=Sinky;
Model.p=p;
Model.Eo=Eo;
Model.ETX=ETX;
Model.ERX=ERX;
Model.Efs=Efs;
Model.Emp=Emp;
Model.EDA=EDA;
Model.do=do;
Model.rmax=rmax;
Model.DpacketLen=DpacketLen;
Model.HpacketLen=HpacketLen;
Model.NumPacket=NumPacket;
Model.RR=RR;


% I-LEACH
Model.numRx=numRx;
Model.dr=dr;

end
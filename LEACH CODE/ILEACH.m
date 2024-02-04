% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%clearing the command window, clearing workspace%
clear;

 %closing all figures%
close all;
 % turning off warnings%
warning off all;

%The tic function is used to start a timer in MATLAB

tic;

%% Create sensor nodes, Set Parameters and Create Energy Model 
%%%%%%%%%%%%%%%%%%%%%%%%% Initial Parameters %%%%%%%%%%%%%%%%%%%%%%%
n=200;                                  %Number of Nodes in the field
[Area,Model]=ILEACH_setParameters(n);     		%Set Parameters Sensors and Network

%%%%%%%%%%%%%%%%%%%%%%%%% configuration Sensors %%%%%%%%%%%%%%%%%%%%
createRandomSen(Model,Area);            %Create a random scenario
load Locations                          %Load sensor Location
%Sensors are configured using the ILEACH_configureSensors function.%
Sensors=ILEACH_configureSensors(Model,n,X,Y);
% ploter(Sensors,Model);                  %Plot sensors
          %Number of dead nodes
[deadNum,circlex,circley] =ILEACH_plotter(Sensors,Model);

%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters initialization %%%%%%%%%%%%%%%%
countCHs=0;         %counter for Cluster Heads
flag_first_dead=0;  %flag_first_dead


initEnergy=0;       %Initial Energy

%Loop from 1 to all nodes
for i=1:n
      initEnergy=Sensors(i).E+initEnergy;
end

SRP=zeros(1,Model.rmax);    %number of sent routing packets
RRP=zeros(1,Model.rmax);    %number of receive routing packets
SDP=zeros(1,Model.rmax);    %number of sent data packets 
RDP=zeros(1,Model.rmax);    %number of receive data packets 
%total_energy_disipated=zeros(1,Model.rmax); 

Sum_DEAD=zeros(1,Model.rmax);       % Sum of dead nodes for each round
CLUSTERHS=zeros(1,Model.rmax);      % Number of cluster heads for each round
AllSensorEnergy=zeros(1,Model.rmax);    % Total energy of all sensors for each round

%%%%%%%%%%%%%%%%%%%%%%%%% Start Simulation %%%%%%%%%%%%%%%%%%%%%%%%%
global srp rrp sdp rdp  %declearing variables
srp=0;          %counter number of sent routing packets
rrp=0;          %counter number of receive routing packets
sdp=0;          %counter number of sent data packets 
rdp=0;          %counter number of receive data packets 

%Sink broadcast start message to all nodes
Sender=n+1;     %Sink
Receiver=1:n;   %All nodes
Sensors=sendReceivePackets(Sensors,Model,Sender,'Hello',Receiver);

% All sensor send location information to Sink .
 Sensors=disToSink(Sensors,Model);
 Sender=1:n;     %All nodes
 Receiver=n+1;   %Sink
 Sensors=sendReceivePackets(Sensors,Model,Sender,'Hello',Receiver);

%Save metrics
SRP(1)=srp;  %updating routing pakets
RRP(1)=rrp;  
SDP(1)=sdp;     %updating data packets                                                    
RDP(1)=rdp;

x=0;    %variable

%% Main loop program
for r=1:1:Model.rmax      %loop from 1 to number of circles                             

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%
    %This section Operate for each epoch   
    member=[];              %Member of each cluster in per period
    countCHs=0;             %Number of CH in per period
    %counter for bit transmitted to Bases Station and Cluster Heads
    srp=0;          %counter number of sent routing packets
    rrp=0;          %counter number of receive routing packets
    sdp=0;          %counter number of sent data packets to sink
    rdp=0;          %counter number of receive data packets by sink
    %initialization per round
    SRP(r+1)=srp;
    RRP(r+1)=rrp;  
    SDP(r+1)=sdp;
    RDP(r+1)=rdp;   
    pause(0.001)    %pause simulation
    hold off;       %clear current figure to prepare for the next visualization
    packets_TO_BS=0;  % the number of packets sent to the Base Station
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Sensors=resetSensors(Sensors,Model);
    %allow to sensor to become cluster-head. LEACH Algorithm  
    AroundClear=10;         %representing the number of rounds after which a specific action will be taken.
    if(mod(r,AroundClear)==0)  %radius is multiple of AroundClear
        for i=1:1:n     %loop from 1 to all nodes
            Sensors(i).G=0;   %node was not clusturhead in previous round
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot sensors %%%%%%%%%%%%%%%%%%%%%%%
    [deadNum,circlex,circley] =ILEACH_plotter(Sensors,Model);
    
    %Save r'th period When the first node dies
    if (deadNum>=1)      
        if(flag_first_dead==0)
            first_dead=r;       %first dead node
            flag_first_dead=1;
        end  
    end
    
%%%%%%%%%%%%%%%%%%%%%%% cluster head election %%%%%%%%%%%%%%%%%%%
    %Selection Candidate Cluster Head Based on LEACH Set-up Phase
    [TotalCH,Sensors]=ILEACH_selectCH(Sensors,Model,r, circlex,circley); 
    
    %Broadcasting CHs to All Sensor that are in Radio Rage CH.
    for i=1:length(TotalCH)     %loop from 1 to all cluster heads
        
        Sender=TotalCH(i).id;     % cluster head will now be a sedner
        SenderRR=Model.RR;          %range accessed by cluster head 
        Receiver=findReceiver(Sensors,Model,Sender,SenderRR);  %function to find nodes that will receive packets from CH 
        Sensors=sendReceivePackets(Sensors,Model,Sender,'Hello',Receiver);      %function to send data 
            
    end 
    
    %Sensors join to nearest CH 
    Sensors=joinToNearestCH(Sensors,Model,TotalCH);
    
%%%%%%%%%%%%%%%%%%%%%%% end of cluster head election phase %%%%%%

%%%%%%%%%%%%%%%%%%%%%%% plot network status in end of set-up phase
%%%%%%%%%%%%%%%%%%%%%%% this will draw lines from every node to its CH

%     for i=1:n
%         
%         if (Sensors(i).type=='N' && Sensors(i).dis2ch<Sensors(i).dis2sink && ...
%                 Sensors(i).E>0)
%             
%             XL=[Sensors(i).xd ,Sensors(Sensors(i).MCH).xd];
%             YL=[Sensors(i).yd ,Sensors(Sensors(i).MCH).yd];
%             hold on
%             line(XL,YL)
%             
%         end
%         
%     end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% steady-state phase %%%%%%%%%%%%%%%%%
    NumPacket=Model.NumPacket;
    for i=1:1:1%NumPacket 
        
        %Plotter     
        [deadNumo,circlex,circley]=ILEACH_plotter(Sensors,Model);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% All sensor send data packet to  CH 
        for j=1:length(TotalCH)  
            
            Receiver=TotalCH(j).id;     %all clusters will now be member
            Sender=findSender(Sensors,Model,Receiver);  %%function to find new CH
            Sensors=sendReceivePackets(Sensors,Model,Sender,'Data',Receiver);  %sending data
           
        end
        
    end
   

%%%%%%%%%%%% send Data packet from CH to Sink after Data aggregation
    for i=1:length(TotalCH)
            
        Receiver=n+1;               %Sink
        Sender=TotalCH(i).id;       %CH 
        Sensors=sendReceivePackets(Sensors,Model,Sender,'Data',Receiver);  %sending data to sink
       
        
    end
    
%%% send data packet directly from other nodes(that aren't in each cluster) to Sink
    for i=1:n  %%loop to all nodes
        if(Sensors(i).MCH==Sensors(n+1).id)
            Receiver=n+1;               %Sink
            Sender=Sensors(i).id;       %Other Nodes 
            Sensors=sendReceivePackets(Sensors,Model,Sender,'Data',Receiver);%sending data to sink
            

        end
    end
  
%% STATISTICS
     
    Sum_DEAD(r+1)=deadNum;  %dead nodes in each rounds
    
    SRP(r+1)=srp;           %SRP->number of sent routing packets in each round %%srp->number of sent routing packets in the current round.
    RRP(r+1)=rrp;           %receiving routing packets
    SDP(r+1)=sdp;           %sending data packets
    RDP(r+1)=rdp;           %received data packets
    
    CLUSTERHS(r+1)=countCHs;        %the number of cluster heads in each round
    
    alive=0;   %variable alive that initially 0
    SensorEnergy=0;     %variable SensorEnergy that initially 0

    for i=1:n       %loop to all nodes
        if Sensors(i).E>0       %if energy is greater than 0
            alive=alive+1;      %then node will alive
            SensorEnergy=SensorEnergy+Sensors(i).E;     %adding energy
        end
    end
    AliveSensors(r)=alive; % represents the number of alive nodes at the end of the current round.
    
    SumEnergyAllSensor(r+1)=SensorEnergy; %stores the cumulative energy of all nodes
    
    AvgEnergyAllSensor(r+1)=SensorEnergy/alive; %stores the average energy per node up to the current round (r+1).
    
    ConsumEnergy(r+1)=(initEnergy-SumEnergyAllSensor(r+1))/n; %is an array that tracks the average energy consumption per node in each round.
    
    En=0;  % 'En' would represent the sum of squared deviations of the remaining energy of alive nodes from the average energy.
    for i=1:n
        if Sensors(i).E>0
            En=En+(Sensors(i).E-AvgEnergyAllSensor(r+1))^2;     %%node's remaining energy from the average energy.
        end
    end
    
%%calculates the energy heterogeneity

    Enheraf(r+1)=En/alive; % indicates greater heterogeneity in the remaining energy distribution among the nodes.
    
    title(sprintf('Round=%d,Dead nodes=%d', r+1, deadNum))  %set the title of the plot
    
   %dead
   if(n==deadNum)       %all nodes are dead
       
       lastPeriod=r;  %round set to variable lastPeriod
       break;
       
   end


STATISTICS.Alive(r+1)=n-deadNum;        %Records the number of alive nodes in the network
STATISTICS.Energy(r+1)=SumEnergyAllSensor(r+1);         % Records the total energy of all sensors
x=r+1;      %Sets the variable x to the current round number '(r+1)'
end % for r=0:1:rmax


r=1:x-1;        %Creates a vector r representing the rounds from 1 to 'x-1'
figure(2)    %graph of statistics between alive nodes and rounds
plot(r,STATISTICS.Alive(r+1));                          %plotting graph
xlabel 'Rounds';            %x-axis
ylabel 'No of live sensor Nodes';           %y-axis
title('Life time of Sensor Nodes')      %title


figure(3)    %graph showing how increase in rounds will affect the energy of nodes
plot(r,STATISTICS.Energy(r+1));     %plotting graph
xlabel 'Rounds';%x-axis
ylabel 'Energy(in j)';%y-axis
title('Avergae Residual energy ');%title

disp('End of Simulation');      %The disp function is used to display the message "End of Simulation" in the command window.
toc;%toc is used to measure the elapsed time since the start of the timer created by tic

filename=sprintf('leach%d.mat',n) ;         %The sprintf function is then used to create a filename based on the value of n (number of nodes) for saving the simulation results in a MAT file.

%% Save Report
save(filename);

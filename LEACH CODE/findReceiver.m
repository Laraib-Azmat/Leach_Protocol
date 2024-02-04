% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%%This findReceiver function is responsible for determining the set of
%%potential receivers within the communication range of a specified sender.%%

function Receiver=findReceiver(Sensors,Model,Sender,SenderRR)

%%array of nodes that will be receiver
    Receiver=[];
    %% Calculate Distance All Sensor With Sender [ Note that for doing so we need to access the global fig variable]
    n=Model.n;      %number of nodes
    D=zeros(1,n);  %%array to store distance
    
    for i=1:n       %loop from 1 to all nodes
             
        D(i)=sqrt((Sensors(i).xd-Sensors(Sender).xd)^2+ ...
            (Sensors(i).yd-Sensors(Sender).yd)^2);          %distance of all nodes
                      
    end 
    
    %% loop from 1 to all nodes
    for i=1:n
                   
        if (D(i) <= SenderRR & Sender~=Sensors(i).id)  %checking whether node is in range of sender and node is not a CH
            Receiver=[Receiver,Sensors(i).id]; %adding to receiver array
        end
                      
    end     %%end of loop
    
end

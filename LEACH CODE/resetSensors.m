% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%% function is designed to reset certain parameters of the sensor nodes in the network 

function Sensors=resetSensors(Sensors,Model)


    n=Model.n;      %nodes
    for i=1:n                   %loop from 1 to all nodes
        Sensors(i).MCH=n+1;        %reset sink is member of cluster head
        Sensors(i).type='N';        % reset all nodes to normal nodes
        Sensors(i).dis2ch=inf;      %resetting distance to cluster head is infinity
    end
    
end % end of loop
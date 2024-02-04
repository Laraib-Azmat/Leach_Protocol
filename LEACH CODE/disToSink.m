% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 


%%function calculates and assigns the distance of each sensor node to the sink %%

function Sensors=disToSink(Sensors,Model)


    n=Model.n;      %total nodes
    for i=1:n       %Loop from 1 to all nodes
        
        distance=sqrt((Sensors(i).xd-Sensors(n+1).xd)^2 + ...
            (Sensors(i).yd-Sensors(n+1).yd)^2 );            %calculating distance from node to sink
        
        Sensors(i).dis2sink=distance;       % assigning distance
        
    end
    
end %end of loop
% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 


%%The joinToNearestCH function assigns each non-cluster head (N) sensor
%%node to the nearest cluster head (CH) based on the distance criterion%%

function Sensors=joinToNearestCH(Sensors,Model,TotalCH)
 

n=Model.n;          %nodes
m=length(TotalCH);      %total clusters
if(m>1) %checking there is more than one cluster head in the network then
    D=zeros(m,n);   %Array to store distance between node and cluster
    for i=1:n     %loop to all nodes
        for j=1:m   %loop to all CH
            
            D(j,i)=sqrt((Sensors(i).xd-Sensors(TotalCH(j).id).xd)^2+ ...
                (Sensors(i).yd-Sensors(TotalCH(j).id).yd)^2);           %calculating distance and storing in array 
        end   
    end 
    
    %% Finds the minimum distance '(Dmin)' and the corresponding index (idx) for each non-cluster head node to the cluster heads.%%
    [Dmin,idx]=min(D);  
    
    for i=1:n   %%loop to all nodes    
        if (Sensors(i).E>0)   %if node is alive
            %if node is in RR CH and is Nearer to CH rather than Sink
            if (Dmin(i) <= Model.RR && Dmin(i)<Sensors(i).dis2sink )
                Sensors(i).MCH=TotalCH(idx(i)).id;     %making cluster head a member 
                Sensors(i).dis2ch=Dmin(i);
            else
                Sensors(i).MCH=n+1;   %node will be a member
                Sensors(i).dis2ch=Sensors(i).dis2sink;  %setting distance
            end
        end
        
    end 
end

end


% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 


%The 'findSender' function is designed to find a sender node based on the
%Receiver input. %

function Sender=findSender(Sensors,Model,Receiver)


    Sender=[];      %Initializes an empty array Sender to store the IDs of potential sender nodes.
 
    n=Model.n;      %nodes
 
    for i=1:n       %loop from 1 to all nodes

        if (Sensors(i).MCH==Receiver && Sensors(i).id~=Receiver)        %verifying sender
            Sender=[Sender,Sensors(i).id]; %#ok
        end

    end 

end
% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%%function is responsible for simulating the energy consumption of sensor
%%nodes when sending and receiving packets%%

function Sensors=sendReceivePackets(Sensors,Model,Sender,PacketType,Receiver)
            %%%%INput parameters%%%%%
%Sensors: Array of sensor nodes in the network.
%Model: Structure containing parameters and settings for the simulation.
%Sender: ID or array of IDs of nodes sending packets.
%PacketType: Type of packet being sent ('Hello' or 'Data').
%Receiver: ID or array of IDs of nodes receiving packets.


   global srp rrp sdp rdp       %declaring variables
   sap=0;      % Send a packet
   rap=0;      % Receive a packet

   if (strcmp(PacketType,'Hello'))      %strcmp (build in function in MAtlab) used to compare two strings
       PacketSize=Model.HpacketLen;     %Size will equal to length of hello packet 
   else
       PacketSize=Model.DpacketLen;        % otherwise it will be a data packet
   end
   
   %Energy dissipated from Sensors for Send a packet 
   for i=1:length( Sender)          % sink, can b cluster head
       
      for j=1:length( Receiver)    %all the nodes
          

            distance=sqrt((Sensors(Sender(i)).xd-Sensors(Receiver(j)).xd)^2 + ...
               (Sensors(Sender(i)).yd-Sensors(Receiver(j)).yd)^2 );             %distance from sink to node i

            if (distance>Model.do)          %Comparing distance with threshold 

                Sensors(Sender(i)).E=Sensors(Sender(i)).E- ...
                    (Model.ETX*PacketSize + Model.Emp*PacketSize*(distance^4));  %Multipath communication

                % Sent a packet
                if(Sensors(Sender(i)).E>0)      %reachable node
                    sap=sap+1;                 % packet send
                end

            else        %%free space path

                Sensors(Sender(i)).E=Sensors(Sender(i)).E- ...
                    (Model.ETX*PacketSize + Model.Efs*PacketSize*(distance^2)); %% Energy for free space path

                % Sent a packet
                if(Sensors(Sender(i)).E>0)   %reachable node
                    sap=sap+1;                 %packet sent
                end

            end
          
      end
      
   end      %End of loop
   
   %Energy dissipated from sensors for Receive a packet
   for j=1:length( Receiver)
        Sensors(Receiver(j)).E =Sensors(Receiver(j)).E- ...
            ((Model.ERX + Model.EDA)*PacketSize);       % updating node's receiving energy 
         
   end   %end of loop
   
   for i=1:length(Sender)    %loop from sender
       for j=1:length(Receiver)         %to all the nodes

            %Received a Packet
            if(Sensors(Sender(i)).E>0 && Sensors(Receiver(j)).E>0)  % checking both sender and receiver has remeining energy > 0. %% '&&' means when both will be true then overall result will true%%
                rap=rap+1;      %incrementing received packet
            end
       end 
   end  %end of loop
   
    if (strcmp(PacketType,'Hello'))     %comparing string
        srp=srp+sap;                    %incrementing send routing pakets
        rrp=rrp+rap;                    %incrementing receive routing packets
    else       %data packet
        sdp=sdp+sap;                    %incrementing send data pakets
        rdp=rdp+rap;                    % %incrementing send data pakets
    end
   
end

%     else %To Cluster Head
%         
%         for i=1:length( Sender)
%        
%            distance=sqrt((Sensors(Sender(i)).xd-Sensors(Sender(i).MCH).xd)^2 + ...
%                (Sensors(Sender(i)).yd-Sensors(Sender(i).MCH).yd)^2 );   
%        
%            send a packet
%            sap=sap+1;
%            
%            Energy dissipated from Normal sensor
%            if (distance>Model.do)
%            
%                 Sensors(Sender(i)).E=Sensors(Sender(i)).E- ...
%                     (Model.ETX*PacketSize + Model.Emp*PacketSize*(distance^4));
% 
%                 if(Sensors(Sender(i)).E>0)
%                     rap=rap+1;                 
%                 end
%             
%            else
%                 Sensors(Sender(i)).E=Sensors(Sender(i)).E- ...
%                     (Model.ETX*PacketSize + Model.Emp*PacketSize*(distance^2));
% 
%                 if(Sensors(Sender(i)).E>0)
%                     rap=rap+1;                 
%                 end
%             
%            end 
%        end
  
% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%%The ILEACH_plotter function is responsible for visualizing the state of
%%the sensor network in the LEACH simulation.%%

function [deadNum,circlex,circley]=ILEACH_plotter(Sensors,Model)


    deadNum=0;  %initially no dead nodes
    n=Model.n;   % number of nodes  
    numRX=Model.numRx;      %The number of radio range

%%Arrays will be used to store the coordinates of circular regions for
%%communication range visualization%

    circlex=zeros(numRX,numRX);
    circley=zeros(numRX,numRX);

%% Loop

    for i=1:1:numRX         %from center to any point
        for j=1:1:numRX
            %'(j-1)*Model.dr)' and '(i-1)*Model.dr)' placing the circular region in a grid-like pattern%
            circlex(i,j)=(Model.dr/2)+((j-1)*Model.dr);     % ensuring that circle will be exactly at center
            circley(i,j)=(Model.dr/2)+((i-1)*Model.dr);     %calculating radius    
        end
    end
   
    r=Model.dr/2;
    angle=0:pi/100:2*pi;    % circumference of a circle.
    xp=r*cos(angle);    %x-coordinate
    yp=r*sin(angle);    %y-coordinate
    for i=1:1:numRX
         for j=1:1:numRX
            plot(circlex(i,j)+xp,circley(i,j)+yp,'g');  % plotting circles using color green
            hold on;                % ensures that subsequent plots are overlaid on the same figure.
            axis('equal');          % ensures that the axes are equally spaced 
         end
    end    
    
    %% Loop from 1 to all nodes %%

    for i=1:n
        %check dead node
        if (Sensors(i).E>0)             %indicating that the node is alive
            
            if(Sensors(i).type=='N' )    % normal node

                % 'ko' -> black circle, 'markerSize' -> size will be 5, 'markerFaxeColor'-> black filled circle
                plot(Sensors(i).xd,Sensors(i).yd,'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
               % text(Sensors(i).xd+1,Sensors(i).yd-1,num2str(i));
            else %Sensors.type=='C' Cluster      
                plot(Sensors(i).xd,Sensors(i).yd,'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'r');   %filled with red
              %  text(Sensors(i).xd+1,Sensors(i).yd-1,num2str(i));
            end
            
        else        % dead node
            deadNum=deadNum+1;      % increment dead node
            plot(Sensors(i).xd,Sensors(i).yd,'ko', 'MarkerSize',5, 'MarkerFaceColor', 'w');     %filled with white
           % text(Sensors(i).xd+1,Sensors(i).yd-1,num2str(i));
        end
       
     hold on; %ensures that each sensor node is added to the existing figure without erasing the previous plots%
        
    end 
    % For Sink
    plot(Sensors(n+1).xd,Sensors(n+1).yd,'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');  %'bo' blue circle %filled with blue
    text(Sensors(n+1).xd+1,Sensors(n+1).yd-1,'Sink');  %adding text to sink
    axis square         %esures that the axes are equally spaced, maintaining the aspect ratio

end
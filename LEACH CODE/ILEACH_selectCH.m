% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%The 'ILEACH_selectCH' function is responsible for selecting Cluster Heads (CHs)

function [CH,Sensors]=ILEACH_selectCH(Sensors,Model,rowx,circlex,circley)

    CH=[];          %empty array showing initially no cluster head
    countCHs=0;     %number of cluster head is 0
    n=Model.n;      %number of nodes
    numRx=Model.numRx;      %number of circles
    dr=Model.dr;            % the width of each circular region
    
    CH_selected_arr=zeros(numRx, numRx);    %pre allocated space for 2D array of size equal to number of circles
    
    for i=1:1:n         %loop from 1 to all nodes
        
        % these are the circle (x,y) for this node
        row_circle_of_node=-1;      %starting with no row
        col_circle_of_node=-1;      %starting with no column
        br=0;       %break condition for loop
        
        % checking in which circle this node lies
        for row=1:1:numRx       %from 1 to all circles in row
            for column=1:1:numRx        %from 1 to all circles in column
                if(sqrt((Sensors(i).xd - circlex(row,column))^2 + (Sensors(i).yd - circley(row,column))^2) <= dr/2)
                    row_circle_of_node=row;     %node in circle that is horizontly placed in position..
                    col_circle_of_node=column;   %node in circle that is vertically placed in position..
                    
                    br=1;       %break and check for next node
                    break       %go out of the loop
                end
            end
            if(br==1)
                break        %go out of the loop
            end
        end
        
        
        % if this node is not in any circle then also skip
        if(br==0)
            continue        %skip the loop .. check for other
        end
        
        
        % if CH of this circle has already been chosen, then skip
        if(CH_selected_arr(row_circle_of_node, col_circle_of_node) == 1)
            continue
        end
        
        %checking node has energy >0 and not previosly choosen as cluster head        
        if(Sensors(i).E>0 && Sensors(i).G<=0) 
            %Generates a random number between 0 and 1.
            temp_rand=rand; 
            %Election of Cluster Heads
            if(temp_rand<= (Model.p/(1-Model.p*mod(rowx,round(1/Model.p)))))       %if node have high probability to be a cluster head             
                countCHs=countCHs+1;        %count node as cluster head

                TotalCH(countCHs).id=i; %adding in array of total CH                
                Sensors(i).type='C';        %setting type of that node as cluster
                Sensors(i).G=round(1/Model.p)-1;    %'G'  field is updated to control the periodicity of cluster head selection.

                % mark this cirle now that it has a CH
                CH_selected_arr(row_circle_of_node, col_circle_of_node) = 1;
                
            end
        end
    end 
     
    
    
end
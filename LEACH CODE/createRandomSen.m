% LEACH PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

%The createRandomSen function generates random sensor node locations within
%the specified field dimensions and saves them in a file named 'Locations'.%


function createRandomSen(Model,Area)


    n=Model.n;          % Number of sensor nodes
    x=Area.x;           % Maximum x dimension of the sensor field
   y=Area.y;           % Maximum y dimension of the sensor field
   
%The use of zeros is a common practice in MATLAB to preallocate memory for
%an array before populating it with values.%

   X=zeros(1,n);       % X-coordinates of sensor nodes
    Y = zeros(1, n);    % Y-coordinates of sensor nodes

     % Generate random sensor node locations
    for i=1:1:n             %Loop from 1 to n
        X(i)=rand()*x;    %rand is a function name Random that genrate a random value for x
        Y(i)=rand()*y;     %rand is a function name Random that genrate a random value for y 
    end
     % Save sensor node locations in the 'Locations' file
    save ('Locations','X','Y');
    %The file can be loaded later for further use in the simulation.

end
%% path_planning.m
%
% DESCRIPTION:
%   This code takes a biary image path and outputs the sequence of x,y 
%   points that should be traversed. This method uses the nearest neighbor
%   algorithm and is greedy.
%
% INPUT: 
%   img: A binary image containg the path to traverse
% 
% OUTPUT: 
%   path: A nx2 array. Each row contains the y,x points to traverse. 
%         The first point is path(1,:) and the last point is path(end,:)  


function path = path_planning(img)

    %Flip Image - because matricies and images are indexed differently (maybe) 
    img = flip(img,1);

    % Find points
    [row,col] = find(img==1);
    points = [row,col];

    % Ordered Path 
    path = [];

    % points left to analyzse
    x_pool = points(:,1); %X cordinates
    y_pool = points(:,2); %Y cordinates
    [x_pool,order] = sort(x_pool);
    pool = [x_pool,y_pool(order)]; %Order points

    % Start at the leftmost point
    [~,idx] = min(pool(:,2));
    path = [pool(idx,:)];
    pool(idx,:) = []; % remove points alread examined


    % Nearest Neighbor Search
     while ~isempty(pool)

        % Find the closest point
        cost = vecnorm((path(end,:)-pool)')';
        [~,idx] = min(cost);

        path = [path;pool(idx,:)]; % add nearest point to path
        pool(idx,:) = []; % remove the point from the pool


         
     end


end
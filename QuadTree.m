function [R] = QuadTree(x,y,Nlevels,crit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function receives as input four parameters, namely:          %%
% A vector containing the x-axis coordinates of P points;           %%
% A vector containing the y-axis coordinates of P points;           %%
% The maximum number of levels that the algorithm will reach;       %%
% Number of points accepted inside each rectangle                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=0; % Start level
lenX = ceil(max(x)-min(x));
lenY = ceil(max(y)-min(y));
vec=0; %Initializing the vector of decimals with the first possible value
binvec = de2bi(vec,'left-msb'); % Convert the vec to its binary representation
i=1;    %Initialize the i with the first loop index
stopM=0; % Switch used for stopping multiplying by 4
nM = 0; % Counter of multiplications by 4
nMax = 0; %Initialize the maximum level
set=0;  % Switch used to detect that a maximum level has been reached
m=0; % Used to detect how many levels need to return
R = zeros(4,5); % Matrix used to store the rectangles information

while i <= length(vec)  % Start the loop
    
    t = find(binvec(i,2:2:end)==1); % From the binary value of vec, detect the position X of the rectangle
    a = lenX*sum(0.5.^t);
    b = a + lenX/2^n;   % Compute the width of the rectangle, based on the level n and the start coordinate X

    t = find(binvec(i,1:2:end)==1); % From the binary value of vec, detect the position Y of the rectangle
    c = lenY*sum(0.5.^t);
    d = c + lenY/2^n; % Compute the height of the rectangle, based on the level n and the start coordinate Y

    K = length(find(x >= a & x <= b & y >= c & y <= d));  % Compute how many points fall inside each rectangle
    R(i,1:5) = [a,b-a,c,d-c,K]; % Store the information about the rectangle i in the matrix R

        if K > crit && n < Nlevels

           if nM == Nlevels
                stopM = 1;
           end

           n = n+1;

           if n > nMax
               nMax = n;
               set=1;
           end

           if stopM == 0 && set == 1
               vec = vec*4;
               nM = nM+1;
               set=0;
           end

           if rem(vec(i),4) == 0
               vec(end+1)=vec(i)+1*4^(nMax-n);
               vec(end+1)=vec(i)+2*4^(nMax-n);
               vec(end+1)=vec(i)+3*4^(nMax-n);
               vec = sort(vec);
               binvec = de2bi(vec,'left-msb');
           end

           if i > 1
                m = ceil(sum(xor(binvec(i,1:size(binvec,2)),binvec(i-1,1:size(binvec,2))))/2)-1;
                if rem(vec(i),4) == 0
                    m = 0;
                end
           end

        elseif K> crit && n == Nlevels

            i=i+1;
            if i > length(vec)
               break;
            end
            m = ceil(sum(xor(binvec(i,1:size(binvec,2)),binvec(i-1,1:size(binvec,2))))/2)-1;
        else

            i = i+1;
            if i > length(vec)
                break;
            end
            m = ceil(sum(xor(binvec(i,1:size(binvec,2)),binvec(i-1,1:size(binvec,2))))/2)-1;

        end

        n=n-m; 
end

end
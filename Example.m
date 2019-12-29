%% Program Init

clear all; close all; clc;

%% Variables Init

lenX = 8;   % Length of the x-axis (in meters)
lenY = 8;   % Length of the y-axis (in meters)
np = 1000;   % Number of points generated randomly
x=rand(1,np)*lenX;  % Draw np points randomly inside the map
y=rand(1,np)*lenY;  
Nlevels = 6; %Maximum number of levels
crit = 2; %Threshold (Maximum number of points in a cell)

%% Using a quad-tree method for counting the points

R = QuadTree(x,y,Nlevels,crit);

%% Plotting the Results

figure(1);
for i = 1:size(R,1)
    rectangle('Position',[R(i,1),R(i,3),R(i,2),R(i,4)]);
    hold on;
end
axis([0,lenX,0,lenY]);
scatter(x,y,'filled');   % Display the points in the screen
title('Adaptive QuadTree distribution of points');
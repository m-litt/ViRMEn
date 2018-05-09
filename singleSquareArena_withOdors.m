function code = singleSquareArena_withOdors
% this is modified from singleSquareArena to include odors
% singleSquareArena   Code for the ViRMEn experiment singleSquareArena.
%   code = singleSquareArena   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.

% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    
vr = initializeDAQ_withOdors(vr);

% set and calculate properties of each odor
% set and calculate properties of each odor
lowestFlowFraction = .01; % this is the lowest possible flow rate
vr.odor1sourceLocation = [str2double(vr.exper.variables.wallThickness), str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
vr.odor2sourceLocation = [str2double(vr.exper.variables.wallThickness), str2double(vr.exper.variables.arenaLength) - str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
x=[0,sqrt(2*str2double(vr.exper.variables.arenaLength)^2)]; % min and max position for the 2D arena
% x=[0,str2double(vr.exper.variables.arenaLength)]; % y position only for the linear track
y=[1,lowestFlowFraction].*100; % max and min flow fraction
vr.flowVsDistanceConstants = polyfit(x,y,1); % constants c1 and c2 for flow = c1/x + c2
clear x y lowestFlowFraction;

% set properties of the reward
vr.timeSolenoid = 16; % in milliseconds
% vr.lastEndZoneRewarded = 4; % previous reward delivery location. 1 is south end, 2 is north end, 4 is a trick to give a reward when the VR starts
vr.numRewards = 0;
vr.startTime = now;
vr.numRewards = 0;

vr.startTime = now;
% vr.turnSpeed = eval(vr.exper.variables.turnSpeed);
% vr.scaling = [7 2.8]; % forward gain, angular gain for ball movement, 2 ball revolutions / 1 world revolution
% vr.scaling = [7 1.9]; % 3 ball revolutions / 1 world revolution
% vr.scaling = [7 5.6]; % 1 ball revolution / 1 world revolution
vr.scaling = [7 3.8]; % 1.5 ball revolutions / 1 world revolution

% give reward initially
vr.counterReward = 1;
vr.inCorner = 0;

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

if vr.counterReward
    reward(vr,vr.timeSolenoid)
    vr.counterReward=0;
end

% deliver air and odors
controlAirflow_squareArena(vr);
% deliver reward for endzone task
% vr = alternateEndZoneReward(vr);

% % if the mouse stands in that corner, teleport him away randomly
% if vr.position(1) > 22 && vr.position(2) > 22
%     if vr.inCorner == 0
%         vr.inCorner = 1;
%         tic
%     end
%     if toc > 15;
%         vr.position(1) = randi(17)+4;
%         vr.position(2) = randi(17)+4;
%         vr.position(4) = randi(floor(2*pi*100))/100;
%         vr.inCorner = 0;
%     end
% end

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)



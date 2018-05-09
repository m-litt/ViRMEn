function vr = initializeDAQ_Training(vr)

% reset the daq in case it is still occupied
daqreset;

%INPUTS
vr.ballMovement = analoginput('nidaq','dev1'); % for smoothing, record the ball movement continuously in the background
addchannel(vr.ballMovement,0:1); % designate ball movement input channel
set(vr.ballMovement,'samplerate',1000,'samplespertrigger',inf); % set sampling rate of ball movement
start(vr.ballMovement); % start acquiring movement data

%OUPUTS
vr.moveRecordingSession = daq.createSession('ni'); % designate ball movement logging channel
% vr.moveRecordingSession.IsContinuous = true;
vr.ballYaw = addAnalogOutputChannel(vr.moveRecordingSession, 'Dev1','ao1','Voltage');
vr.ballX = addAnalogOutputChannel(vr.moveRecordingSession, 'Dev1','ao2','Voltage');
vr.ballY = addAnalogOutputChannel(vr.moveRecordingSession, 'Dev1','ao3','Voltage');
vr.waterSession = daq.createSession('ni'); % designate water reward channel
% vr.waterSession.IsContinuous = false;
vr.waterReward = addAnalogOutputChannel(vr.waterSession, 'Dev1','ao0','Voltage');
% % vr.waterSession.prepare();

% taken from Brad's:
% vr.moveRecordingAndAirflowSession = daq.createSession('ni');
% vr.ballYaw = addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev1','ao1','Voltage');
% vr.ballX   = addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev1','ao2','Voltage');
% vr.ballY   = addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev1','ao3','Voltage');
% addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev2', 'ao0', 'Voltage');
% addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev2', 'ao1', 'Voltage');
% addAnalogOutputChannel(vr.moveRecordingAndAirflowSession, 'Dev2', 'ao2', 'Voltage');
% 
% vr.waterSession = daq.createSession('ni'); % designate water reward channel
% vr.waterReward = addAnalogOutputChannel(vr.waterSession, 'Dev1','ao0','Voltage');

%LISTENER %added by ML 4/24/18
% vr.lh = addlistener(vr.moveRecordingSession,'DataRequired',@queueMoreData);
% vr.lh2 = addlistener(vr.waterSession,'DataRequired2',@queueMoreData);

%Variables to be used for output
vr.ballForwardChannel = 2;
vr.ballRotationChannel = 1;

% scale the DAQ position outputs to range linearly within the arena
% dimensions.  For example, one end of the arena should be +9V and the
% other should be -9V, and the middle should be 0V.  These particular
% values are for when the arena exists in only positive x and y dimensions.
vr.xScaling = 18/str2double(vr.exper.variables.arenaWidth);
vr.xOffset = -9; %Use all of dynamice range -10 V to 10V, offset to start at -9
vr.yScaling = 18/str2double(vr.exper.variables.arenaLength);
vr.yOffset = -9;%Use all of dynamice range -10 V to 10V, offset to start at -9
vr.angleScaling = 9/pi;

% set voltage for solenoid reward command
vr.highVoltage = 9;
vr.lowVoltage = 0;



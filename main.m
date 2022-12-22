clear; clc; close all;

%% Iclude Path and M.Files
addpath('VrepConnection');

%% Start API Connection
vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
id = vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
if (id < 0)
    disp('Failed connecting to remote API server');
    vrep.delete();
    return;
end

fprintf('Connection %d to remote API server open.\n', id);

%% GetObjectHandle 
    [~,camera] = vrep.simxGetObjectHandle(id,'Vision_sensor',vrep.simx_opmode_blocking);

%% Start
% to make sure that streaming data has reached to client at least once
vrep.simxGetPingTime(id);
vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);

%% Simulation
[~,resolution,image] = vrep.simxGetVisionSensorImage2(id,camera,0,vrep.simx_opmode_streaming);
for t = 1:500
    [~,resolution,image] = vrep.simxGetVisionSensorImage2(id,camera,0,vrep.simx_opmode_buffer);
    imshow(image)
    pause(0.01)
end

%% End Simulation
% Now send some data to V-REP in a non-blocking fashion:
vrep.simxAddStatusbarMessage(id,'This is a Message from MATLAB!',vrep.simx_opmode_oneshot);
% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
vrep.simxGetPingTime(id);
vrep.simxFinish(id);

%% END
disp('Connection ended');
vrep.delete();
clear; clc;
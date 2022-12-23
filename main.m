clear; clc; close all;
%% Include Path and M.Files
addpath('VrepConnection');
%add python path
reloadPy()

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

%% Get Objects Handle 
%Camera
% [~,Camera] = vrep.simxGetObjectHandle(id,'Vision_sensor',vrep.simx_opmode_blocking);
%Joints
Joints = -ones(1,6);
JointNames={'UR10_joint1','UR10_joint2','UR10_joint3','UR10_joint4','UR10_joint5','UR10_joint6'};
for i = 1:6
    [~,Joints(i)] = vrep.simxGetObjectHandle(id, JointNames{i}, vrep.simx_opmode_oneshot_wait); 
end
%Frame 1
[~, Frame1] = vrep.simxGetObjectHandle(id,'Frame1', vrep.simx_opmode_oneshot_wait);
%Gripper
[~,EE] = vrep.simxGetObjectHandle(id,'EE',vrep.simx_opmode_oneshot_wait);
[~,baxter_sensor] = vrep.simxGetObjectHandle(id,'BaxterVacuumCup_sensor',vrep.simx_opmode_oneshot_wait);
%conveyor_sensor 
[~,conveyor_sensor] = vrep.simxGetObjectHandle(id,'conveyor__sensor', vrep.simx_opmode_oneshot_wait);
%cube
[~,Cuboid0] = vrep.simxGetObjectHandle(id,'Cuboid0',vrep.simx_opmode_oneshot_wait);

%% Start
% to make sure that streaming data has reached to client at least once
vrep.simxGetPingTime(id);
vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);
%DH Parameters of UR10
a = [0, -0.612, -0.5723, 0, 0, 0];
d = [0.1273, 0, 0, 0.163941, 0.1157, 0.0922];
alpha = [1.570796327, 0, 0, 1.570796327, -1.570796327, 0];
offset = [0, -pi/2, 0,-pi/2, 0, 0]; %??
%Using Peter Corke robotics toolbox
for i= 1:6
  L(i) = Link([ 0 d(i) a(i) alpha(i) 0 offset(i)], 'standard');   %?? 
end
Robot = SerialLink(L);
Robot.name = 'UR10';
JointsStartingPos = [0, 0, 0, 0, 0, 0];

%% Simulation
% [~,~,~] = vrep.simxGetVisionSensorImage2(id,Camera,0,vrep.simx_opmode_streaming);
[~,~,~] = vrep.simxReadProximitySensor(id,conveyor_sensor,vrep.simx_opmode_streaming);

%Initialize Joint Position
RotateJoints(id, vrep, Joints, JointsStartingPos);
%Pick
% color = PickNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor);
%Place
go_to_xyz(Robot,Joints,id,vrep,0.8,0,0.9)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.8)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.7)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.6)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.5)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.45)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.4)
go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.35)

%baxter sensor
[~,state,~] = vrep.simxReadProximitySensor(id,baxter_sensor,vrep.simx_opmode_streaming);

%get the cuboid
vrep.simxSetObjectIntParameter(id,Cuboid0,3003,1,vrep.simx_opmode_oneshot);
vrep.simxSetObjectParent(id,Cuboid0,EE,true,vrep.simx_opmode_oneshot);

go_to_xyz(Robot,Joints,id,vrep,0.9,0,0.4)
go_to_xyz(Robot,Joints,id,vrep,0.7,0,0.5)
go_to_xyz(Robot,Joints,id,vrep,0.8,0,0.6)
go_to_xyz(Robot,Joints,id,vrep,0.5,0,0.7)

%release the cuboid
vrep.simxSetObjectIntParameter(id,Cuboid0,3003,0,vrep.simx_opmode_oneshot);
vrep.simxSetObjectParent(id,Cuboid0,-1,true,vrep.simx_opmode_oneshot);

%% End Simulation
% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive.
vrep.simxGetPingTime(id);
vrep.simxFinish(id);

%% END
disp('Connection ended');
vrep.delete();
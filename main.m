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
[~,Camera] = vrep.simxGetObjectHandle(id,'Vision_sensor',vrep.simx_opmode_blocking);
%Joints
Joints = -ones(1,6);
JointNames={'UR10_joint1','UR10_joint2','UR10_joint3','UR10_joint4','UR10_joint5','UR10_joint6'};
for i = 1:6
    [~,Joints(i)] = vrep.simxGetObjectHandle(id, JointNames{i}, vrep.simx_opmode_oneshot_wait); 
end
%Frame 1
[~, Frame1] = vrep.simxGetObjectHandle(id,'Frame1', vrep.simx_opmode_oneshot_wait);
%Gripper
[~,Gripper] = vrep.simxGetObjectHandle(id, 'RG2_openCloseJoint', vrep.simx_opmode_oneshot_wait);
[~, Gripper_sensor] = vrep.simxGetObjectHandle(id,'RG2_attachProxSensor', vrep.simx_opmode_oneshot_wait);
[~,EE] = vrep.simxGetObjectHandle(id,'EE',vrep.simx_opmode_oneshot_wait);
[~,baxter_sensor] = vrep.simxGetObjectHandle(id,'BaxterVacuumCup_sensor',vrep.simx_opmode_oneshot_wait);
%conveyor_sensor 
[~, conveyor_sensor] = vrep.simxGetObjectHandle(id,'conveyor__sensor', vrep.simx_opmode_oneshot_wait);

%% Start
% to make sure that streaming data has reached to client at least once
vrep.simxGetPingTime(id);
vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);
%DH Parameters of UR10
a = [0, -0.612, -0.5723, 0, 0, 0];
d = [0.1273, 0, 0, 0.163941, 0.1157, 0.0922];
alpha = [pi/2, 0, 0, pi/2, -pi/2, 0];
offset = [0, -pi/2, 0,-pi/2, 0, 0]; %??
%Using Peter Corke robotics toolbox
for i= 1:6
  L(i) = Link([ 0 d(i) a(i) alpha(i) 0 offset(i)], 'standard');   %?? 
end
Robot = SerialLink(L);
Robot.name = 'UR10';
JointsStartingPos = [0, 0, 0, 0, 0, 0];
%% Simulation
vrep.simxGetVisionSensorImage2(id,Camera,0,vrep.simx_opmode_streaming);
[~,state,~] = vrep.simxReadProximitySensor(id,conveyor_sensor,vrep.simx_opmode_streaming);
[~,state,~] = vrep.simxReadProximitySensor(id,Gripper_sensor,vrep.simx_opmode_streaming);

%Initialize Joint Position
RotateJoints(id, vrep, Joints, JointsStartingPos);

CubeCounter = 0;
while (vrep.simxGetConnectionId(id) == 1)
    [~,state,~,Cuboid,~] = vrep.simxReadProximitySensor(id,conveyor_sensor,vrep.simx_opmode_streaming);
    if (state == 1)
        result = 0;
          %pick
        OpenGripper(id,vrep,Gripper,0.1);
        [p,color] = GotoNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor);
        fprintf('coordinate: [%i,%i,%i]\n',p(1),p(2),p(3));
        fprintf('color: %s\n',color);
        CloseGripper(id,vrep, Gripper,0.1);
        %go to starting point
        RotateJoints(id, vrep, Joints, JointsStartingPos,1);
%         while (result == 0)
%             OpenGripper(id,vrep,Gripper,0.1);
%             [p,color] = GotoNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor);
%             fprintf('coordinate: [%i,%i,%i]\n',p(1),p(2),p(3));
%             fprintf('color: %s\n',color);
%             CloseGripper(id,vrep, Gripper,0.02);
%             %go to starting point
%             RotateJoints(id, vrep, Joints, JointsStartingPos, 1);
%             [~,result,~,~,~] = vrep.simxReadProximitySensor(id,Gripper_sensor,vrep.simx_opmode_buffer);
%         end
        %CubeCounter = CubeCounter+1;
        %place
        GotoBasket(Robot,Joints,id,vrep,color);
        %release the cuboid
        OpenGripper(id,vrep, Gripper,0.02);
        pause(0.5);
        CloseGripper(id,vrep, Gripper,0.1);
        %go to starting point
        RotateJoints(id, vrep, Joints, JointsStartingPos);
    end
end
    
%% End Simulation
% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive.
vrep.simxGetPingTime(id);
vrep.simxFinish(id);

%% END
disp('Connection ended');
vrep.delete();
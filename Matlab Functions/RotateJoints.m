function RotateJoints(id, vrep, Joints, TargetPos, adjustEE)
    vrep.simxAddStatusbarMessage(id,'moving joints.',vrep.simx_opmode_oneshot);
    for i= 1:6
        if (TargetPos(i) > pi) 
            TargetPos(i) = TargetPos(i) - 2*pi; 
        elseif (TargetPos(i) < -pi)
            TargetPos(i) = TargetPos(i) + 2*pi; 
        end
    end 
    %current joint positions
    currentPos = -ones(1,6);    
    for i = 1:6
        [~, currentPos(i)] = vrep.simxGetJointPosition(id, Joints(i), vrep.simx_opmode_oneshot_wait);
        %add gaussian noise?
    end
    TargetPos(1) = TargetPos(1) + pi/2; %??
    if (nargin == 5 && adjustEE) 
        TargetPos(5) =  TargetPos(5) + pi;
    end
    TargetPost_5 = TargetPos(5);
    TargetPos(5) = currentPos(5);
    % set joint new positions
    Threshold = 0.001;% threshold to check if the EE has reached its destination
    for i = [1 2 3 4 6]
        vrep.simxSetJointTargetPosition(id, Joints(i),TargetPos(i),vrep.simx_opmode_oneshot);
    end
    currentPos = -ones(1,6);
    while (max(abs(currentPos - TargetPos)) > Threshold)                        
    %Get current joint angles for each joint
        for i = 1:6
            [~,currentPos(i)] = vrep.simxGetJointPosition(id,Joints(i),vrep.simx_opmode_oneshot_wait);
        end 
    end
    vrep.simxSetJointTargetPosition(id, Joints(5), TargetPost_5,vrep.simx_opmode_oneshot);
    %wait until joints reach their destination
    currentPos_5 = -1;
    while (max(abs(currentPos_5 -  TargetPost_5)) > Threshold)                        
       [~,currentPos_5] = vrep.simxGetJointPosition(id,Joints(5),vrep.simx_opmode_oneshot_wait);
    end
    vrep.simxAddStatusbarMessage(id,'joints moved.',vrep.simx_opmode_oneshot);

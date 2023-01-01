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
    % set joint new positions
    TargetPos(1) = TargetPos(1) + pi/2; %??
    if (nargin == 5 && adjustEE) 
        TargetPos(5) =  TargetPos(5) + pi;
    end
    for i = 1:6
        vrep.simxSetJointTargetPosition(id, Joints(i),TargetPos(i),vrep.simx_opmode_oneshot);
    end
    %wait until joints reach their destination
    currentPos = -ones(1,6);
    Threshold = 0.01;% threshold to check if the EE has reached its destination
    while (max(abs(currentPos - TargetPos)) > Threshold)                        
    %Get current joint angles for each joint
        for i = 1:6
            [~,currentPos(i)] = vrep.simxGetJointPosition(id,Joints(i),vrep.simx_opmode_oneshot_wait);
        end 
    end
    vrep.simxAddStatusbarMessage(id,'joints moved.',vrep.simx_opmode_oneshot);

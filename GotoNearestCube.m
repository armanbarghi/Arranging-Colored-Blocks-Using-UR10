function [p,color] = GotoNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor)
    % get position of nearest cube
    [x,y,color] = GetPositionFromPy(id,Camera,conveyor_sensor,vrep);
    z = 0.6;
    p = [x,y,z];
    T = transl(p);
    theta_x = 0;
    theta_y = pi;
    theta_z = pi/2;
    T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true);
    q0 = [1.2807    0.6263    1.5280   -0.5836    1.5708    0.2901];
    TargetPos = Robot.ikunc(T,q0); %1*6 vector
    RotateJoints(id, vrep, Joints, TargetPos, 1);
end
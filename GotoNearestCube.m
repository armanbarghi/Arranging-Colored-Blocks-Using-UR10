function [p,rotation,color] = GotoNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor)
    % get position of nearest cube
    [x,y,rotation,color] = GetPositionFromPy(id,Camera,conveyor_sensor,vrep);
    z = 0.412;
    p = [x,y,z];
    fprintf('coordinate: [%i,%i,%i] m\n',p(1),p(2),p(3));
    fprintf('rotation: %i degree\n',rotation*180/pi);
    fprintf('color: %s\n',color);
    T = transl(p);
    theta_x = 0;%rad2deg(2*pi*rand)
    theta_y = 0;%rad2deg(2*pi*rand)
    theta_z = 0;%rad2deg(2*pi*rand)
    T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true);
    q0 = [1.2807    0.6263    1.5280   -0.5836    1.5708    0.2901];
    TargetPos = Robot.ikunc(T,q0);%1*6 vector
    TargetPos(6) = TargetPos(6) + rotation;
    RotateJoints(id, vrep, Joints, TargetPos);
end
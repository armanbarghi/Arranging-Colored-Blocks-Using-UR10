function color = PickNearestCube(Robot,Joints,id,vrep,Camera,conveyor_sensor)
    % G=EulerZYX(Targtheta)*ROT('Z',pi/2)*ROT('X',pi);
    % RG2GripperOffset = [0 0 0.34]; 
    % G(1:3, 4)= TargPos + RG2GripperOffset; % XYZ
    % G=double(G); 
    % get position of nearest cube
    [x,y,color] = GetPositionFromPy(id,Camera,conveyor_sensor,vrep)
%     x = 0.9
%     y = 0
    z = 0.4
    p = [x;y;z]';
    T = transl(p);
    theta_x = 0;%rad2deg(2*pi*rand)
    theta_y = 0;%rad2deg(2*pi*rand)
    theta_z = 0;%rad2deg(2*pi*rand)
    T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true);
    TargetPos = Robot.ikunc(T);%1*6 vector
    %TargetPos = Robot.ikcon(T);
    %TargetPos = Robot.ikunc(G); 
    RotateJoints(id, vrep, Joints, TargetPos);
%     z = 0.4
%     p = [x;y;z]';
%     T = transl(p);
%     T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true);
%     TargetPos = Robot.ikunc(T);%1*6 vector
%     RotateJoints(id, vrep, Joints, TargetPos);
end
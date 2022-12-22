function TargetPos = GetNearestCubeposition(Robot)
    % G=EulerZYX(Targtheta)*ROT('Z',pi/2)*ROT('X',pi);
    % RG2GripperOffset = [0 0 0.34]; 
    % G(1:3, 4)= TargPos + RG2GripperOffset; % XYZ
    % G=double(G); 
    % move joints to random position and should be replaced with opencv code
    x = -0.5 + rand;
    y = -0.5 + rand;
    z = 0.25 + rand;
    p = [x;y;z]';
    T = transl(p);
    theta_x = rad2deg(2*pi*rand)
    theta_y = rad2deg(2*pi*rand)
    theta_z = rad2deg(2*pi*rand)
    T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true)
    TargetPos = Robot.ikunc(T);%1*6 vector
    % TargetPos = Robot.ikcon(T);
    %TargetPos = Robot.ikunc(G); 
end
function PlaceCubeInBasket(Robot,Joints,id,vrep,color)
    if (color == "r")
        x = 0.9
        y = 0
    elseif (color == "b")
        x = 0
        y = 0.9
    elseif (color == "g")
        x = 0.9
        y = 0
    end
    z = 0.3
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
end
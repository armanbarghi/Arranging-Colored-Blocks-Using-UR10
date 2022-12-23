function go_to_xyz(Robot,Joints,id,vrep,x,y,z)
    p = [x,y,z];
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


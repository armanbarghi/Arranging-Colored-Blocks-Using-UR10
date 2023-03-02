function GotoBasket(id,vrep,Robot,Joints,color)
    if (color == "r")
        x = 0.9;
        y = 0;
        q0 = [0.183179583509881,-0.775348672092911,-0.806940374152456,-3.13009985821662,1.57079576624034,1.38761680537454];
    elseif (color == "b")
        x = 1e-3;
        y = 0.9;
        q0 = [1.75295294140876,-0.775370542707123,-0.807144366715457,-3.12975030300675,1.57097879989488,-0.182020583276003];
    elseif (color == "g")
        x = -0.9;
        y = 0;
        q0 = [0 0 0 0 0 0];
    end
    z = 0.8;
    p = [x,y,z];
    T = transl(p);
%      theta_x = 0;%rad2deg(2*pi*rand)
%     theta_y = 0;%rad2deg(2*pi*rand)
%     theta_z = 0;%rad2deg(2*pi*rand)
%     T(1:3,1:3) = RotationMatrix(theta_z,theta_y,theta_x,'ZYX',true);
    
    TargetPos = Robot.ikunc(T,q0);
    RotateJoints(id, vrep, Joints, TargetPos, 1);
end
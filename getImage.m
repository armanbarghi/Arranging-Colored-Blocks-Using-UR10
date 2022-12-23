function image = getImage(id,Camera,vrep)
    for t = 1:50
        [~,~,image] = vrep.simxGetVisionSensorImage2(id,Camera,0,vrep.simx_opmode_buffer);
        pause(0.01)
    end
end
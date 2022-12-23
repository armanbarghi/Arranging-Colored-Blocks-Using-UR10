function [x,y,color] = GetPositionFromPy(id,Camera,conveyor_sensor,vrep)
    result = 0;
    while (result == 0)
        [~,result,~,~,~] = vrep.simxReadProximitySensor(id,conveyor_sensor,vrep.simx_opmode_buffer);
    end
    image = getImage(id,Camera,vrep);
    imwrite(image,'image.png')
    temp = py.getposition.callme();    
    while (temp{1} == -10000 && temp{2} == -10000 && temp{3} == "-10000")
        image = getImage(id,Camera,vrep);
        imwrite(image,'image.png')
        
        temp = py.getposition.callme();
    end
    x = -double(temp{1}) / 650 * 0.59 + 0.295;
    y = double(temp{2}) / 650 * 0.59 - 0.8 - 0.5086;
    color = temp{3};
    delete 'image.png'
end
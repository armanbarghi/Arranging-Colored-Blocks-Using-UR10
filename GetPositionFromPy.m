function [x,y] = GetPositionFromPy(id,Camera,conveyor_sensor,vrep)
    result = 0;
    while (result == 0)
        [~,result,~,~,~] = vrep.simxReadProximitySensor(id,conveyor_sensor,vrep.simx_opmode_buffer);
    end
    image = getImage(id,Camera,vrep);
%     imshow(image);
    imwrite(image,'image.png')
    temp = py.getposition.callme();    
    while (temp{1} == 10000 && temp{2} == 10000)
        image = getImage(id,Camera,vrep);
        imwrite(image,'image.png')
        %imshow(image);
        temp = py.getposition.callme();
    end
    x = -double(temp{1}) / 650 * 0.59 + (0.295 + 0.00013);
    y = double(temp{2}) / 650 * 0.59 - (0.85 + 0.0087);
    delete 'image.png'
end
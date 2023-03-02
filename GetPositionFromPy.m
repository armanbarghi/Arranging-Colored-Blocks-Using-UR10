function [x,y,rotation,color] = GetPositionFromPy(id,vrep,Camera,ConveyorSensor)
    result = 0;
    while (result == 0)
        [~,result,~,~,~] = vrep.simxReadProximitySensor(id,ConveyorSensor,vrep.simx_opmode_buffer);
    end
    image = GetImage(id,vrep,Camera);
    imwrite(image,'image.png')
    temp = py.GetPosition.callme();
    while (temp{1} == -10000 && temp{2} == -10000 && temp{4} == "-10000")
        image = GetImage(id,vrep,Camera);
        imwrite(image,'image.png')
        temp = py.GetPosition.callme();
    end
    rotation = temp{3};
    x = (-double(temp{1}) * 0.59 / 256 + 0.59 / 2) * 0.8;
    y = double(temp{2}) * 0.59 / 256 - 0.59/4 - 0.55 - 0.52;
    color = temp{4};
    delete 'image.png'
end
# Arranging-Colored-Blocks-in-The-Production-Line-Based-on-Image-Processing-Using-UR10-Robot

The goal of this project is to automate the separation of colored blocks in a production line using a UR10 robot. To achieve this, we have set up a simulation environment in CoppeliaSim. A camera has been installed above the conveyor belt to capture frames, which are then processed using OpenCV to determine the color, position, and rotation of each cube.
To move the robot's joints to the correct position for pick-and-place operation, we calculate the angles using inverse kinematics equations in MATLAB based on the cube's information. These angles are then sent to the CoppeliaSim environment. Finally, a PID controller is used to guide the robot's end effector to the desired position, where it can perform the pick-and-place operation.

<p align="center">
  <img src="https://user-images.githubusercontent.com/49754064/223809965-c96430d3-8097-46d3-a2ef-50ce69a804e6.gif"/>
</p>

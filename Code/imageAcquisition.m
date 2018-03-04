%% Compiling .mex

mex -setup C++
run('D:\OneDrive\Belgeler\MATLAB\Add-Ons\Collections\Kinect 2 Interface for Matlab\code\jrterven-Kin2-afeec4f\compile_cpp_files.m');

%% Depth and Colored image acquisition

clear all; close all; clc;

k2 = Kin2('color', 'depth', 'infrared');

pause(2)
tic
frame = 0;
valid = 0;

while (frame < 100000000)    
    validData = k2.updateData;
    
    if validData
        
        depth = k2.getDepth;
        color = k2.getColor;
        
        
        valid = valid + 1;

    end
    
    frame = frame + 1;
end

valid_frame_percentage = valid/100


k2.delete;
toc

%% 

clear all;

k2 = Kin2('color','depth','body')

pause(4)

validData = k2.updateData;

color = k2.getColor;
ptDepth = k2.mapCameraPoints2Depth(color)
depth = k2.getDepth;
ptColor = k2.mapDepthPoints2Color(depth);
bodies = k2.getBodies;
deneme = bodies(1).Position
posDepth = k2.mapCameraPoints2Depth(bodies(1).Position)
posColor = k2.mapCameraPoints2Color(bodies(1).Position)

k2.delete;

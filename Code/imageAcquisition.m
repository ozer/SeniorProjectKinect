%% Compiling .mex

mex -setup C++
run('D:\OneDrive\Belgeler\MATLAB\Add-Ons\Collections\Kinect 2 Interface for Matlab\code\jrterven-Kin2-afeec4f\compile_cpp_files.m');

%% Depth and Colored image acquisition

clear all; close all; clc;

k2 = Kin2('color', 'depth', 'body');

pause(2)
tic
frame = 1;
valid = 0;
euler = zeros(25, 3);

while (true)
    validData = k2.updateData;
    
    if validData
        
        depth = k2.getDepth;
        color = k2.getColor;
        
        ptDepth = k2.mapCameraPoints2Depth(color);
        ptColor = k2.mapDepthPoints2Color(depth);
        bodies = k2.getBodies;
        positions_1 = bodies(1).Position;
        
        break
        
    end
    
end

% The Quaternion is described as: zyxw, the EuA is described as: xyz
for i = 1:25
    euler(i, :) = spinCalc('QtoEA321', transpose(bodies.Orientation(:,i)), 1, 1);
    euler_transpose = transpose(euler);
end


k2.delete;
toc
%%

clear all;

k2 = Kin2('color','depth','body')

pause(4)

validData = k2.updateData;

color = k2.getColor;
ptDepth = k2.mapCameraPoints2Depth(color);
depth = k2.getDepth;
bodies = k2.getBodies;
deneme = bodies(1).Position;
ptColor = k2.mapDepthPoints2Color(bodies(1).Position');
posDepth = k2.mapCameraPoints2Depth(bodies(1).Position');
posColor = k2.mapCameraPoints2Color(bodies(1).Position');
posDepthToColor = k2.mapDepthPoints2Color(bodies(1).Position');


k2.delete;

%% Body Joint video for angle orientation

clear all; close all; clc;

k2 = Kin2('color', 'depth', 'body');

pause(2)
tic
frame = 1;
valid = 0;
euler = zeros(25, 3);
while frame < 151
    while (true)
        validData = k2.updateData;
        
        if validData
            
            bodies = k2.getBodies;
            positions_1 = bodies(1).Position;
            frame = frame + 1;
            
            break
            
        end
        
    end
end

k2.delete;
toc

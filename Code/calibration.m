clear all; close all; clc;

rgbImage = videoinput('kinect', 1);
depthImage = videoinput('kinect', 2);

srcDepth = getselectedsource(depthImage);

start([rgbImage depthImage]);

[imgColor, ts_color, metaData_Color] = getdata(rgbImage);
[imgDepth, ts_depth, metaData_Depth] = getdata(depthImage);

image_sym = fliplr(imgColor(:, :, 1:3));

imwrite(uint8(image_sym), 'rgb_1_23.png');

%% Calibration

stereoCameraCalibrator('folder1','folder2',58,'millimeters');
%% Camera Intrinsics
M = 300; N = 400;

fx = 366.3814870652361;
fy = 366.3814866524901;
cx = 255.7188008480681;
cy = 210.3457972491764;

k2 = 0.087746424445;
k4 = -0.26525282252;
k6 = 0.09448294462;

%projection correction (-1 is for Matlab indexes, for c++ == 0)
x = (M-cx-1)/fx;
y = (N-cy-1)/fy;

%distorsion correction 
x0= x;
y0= y;
for j=1:4
    r2 = x^2+y^2;
    p = 1/(1+k2*r2+k4*r2^2+k6*r2^3);
    x=x0*p;
    y=y0*p;
end

X = x*depth*0.001;
Y = -y*depth*0.001;
Z = depth*0.001

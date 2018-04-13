clear all; close all; clc;

rgbImage = videoinput('kinect', 1);
depthImage = videoinput('kinect', 2);

srcDepth = getselectedsource(depthImage);

start([rgbImage depthImage]);

while (true)
    start([rgbImage depthImage]);
    [imgColor, ts_color, metaData_Color] = getdata(rgbImage);
    image_sym = fliplr(imgColor(:, :, 1:3));
    
    figure(1);
    imshow(uint8(image_sym));

end


%% Create color and depth kinect videoinput objects.
clear all; close all; clc;

colorVid = videoinput('kinect', 1);
depthVid = videoinput('kinect', 2);

depthSource = getselectedsource(depthVid);
depthSource.EnableBodyTracking = 'on';

config = triggerinfo(depthVid);

triggerconfig(depthVid,config(2));

depthVid.FramesPerTrigger = 1;
depthVid.FrameGrabInterval = 5; 

pause(5);

meta = []

for i=1:30
    start(depthVid);
    trigger(depthVid);
    [~,~,metaData] = getdata(depthVid);
    meta = [meta; metaData];
end

delete(depthVid);

% Look at the device-specific properties on the depth source device,
% which is the depth sensor on the Kinect V2.
% Set 'EnableBodyTracking' to on, so that the depth sensor will
% return body tracking metadata along with the depth frame.
% depthSource = getselectedsource(depthVid);
% depthSource.EnableBodyTracking = 'on';
% 
% % Acquire 100 color and depth frames.
% framesPerTrig = 100;
% depthVid.FramesPerTrigger = framesPerTrig;
% depthVid.TriggerRepeat = 10;
% 
% % Start the depth and color acquisition objects.
% % This begins acquisition, but does not start logging of acquired data.
% pause(5);
% start([depthVid]);
% 
% % Get images and metadata from the color and depth device objects.
% [~, ~, metadata] = getdata(depthVid);

% wait(depthVid);
% These are the order of joints returned by the kinect adaptor.
%    SpineBase = 1;
%    SpineMid = 2;
%    Neck = 3;
%    Head = 4;
%    ShoulderLeft = 5;
%    ElbowLeft = 6;
%    WristLeft = 7;
%    HandLeft = 8;
%    ShoulderRight = 9;
%    ElbowRight = 10;
%    WristRight = 11;
%    HandRight = 12;
%    HipLeft = 13;
%    KneeLeft = 14;
%    AnkleLeft = 15;
%    FootLeft = 16;
%    HipRight = 17;
%    KneeRight = 18;
%    AnkleRight = 19;
%    FootRight = 20;
%    SpineShoulder = 21;
%    HandTipLeft = 22;
%    ThumbLeft = 23;
%    HandTipRight = 24;
%    ThumbRight = 25;


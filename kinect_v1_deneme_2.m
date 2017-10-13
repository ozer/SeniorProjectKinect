clear all; close all; clc;
imaqreset;

% utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
%     'html', 'KinectForWindows');
% addpath(utilpath);

depthVid = videoinput('kinect', 2);

triggerconfig(depthVid, 'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid), 'TrackingMode', 'Skeleton');

viewer = vision.DeployableVideoPlayer();

start(depthVid);
himg = figure;

while ishandle(himg)
    trigger(depthVid);
    [depthMap, ~, depthMetaData] = getdata(depthVid);
    imshow(depthMap, [0 4096]);
    %%disp(depthMetaData.FrameNumber);

    if sum(depthMetaData.IsSkeletonTracked) > 0
        skeletonJoints = depthMetaData.JointDepthIndices(:, :, ...
            depthMetaData.IsSkeletonTracked);
                
        if skeletonJoints(8,2) < skeletonJoints(5,2)
            disp('Özer kolunu kaldýrdý');
        end
        
        hold on;
        plot(skeletonJoints(:,1), skeletonJoints(:,2), '*');
        hold off;
        
    end
end

stop(depthVid);


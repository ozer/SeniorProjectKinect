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
    delete(findall(gcf,'type','annotation'));
    
    if sum(depthMetaData.IsSkeletonTracked) > 0
        skeletonJoints = depthMetaData.JointDepthIndices(:, :, ...
            depthMetaData.IsSkeletonTracked);
        skeletonJointDepth = depthMetaData.JointWorldCoordinates(:, :, ...
            depthMetaData.IsSkeletonTracked);
        
        if ( skeletonJoints(8,2) + 10 < skeletonJoints(5,2) || skeletonJoints(12,2) + 10 < skeletonJoints(9,2) )
            annotation('textbox', [.2 .5 .3 .3], 'String', 'Hand is raised'...
                , 'FitBoxToText', 'on');
            
            hold on;
            plot(skeletonJoints(:,1), skeletonJoints(:,2), '*');
            hold off;
            
        end
        if ( skeletonJointDepth(8,3) < skeletonJointDepth(5,3) || skeletonJointDepth(12,3) < skeletonJointDepth(9,3) )
            annotation('textbox', [.2 .6 .3 .3], 'String', 'Hand is on the front'...
                , 'FitBoxToText', 'on');
            
            hold on;
            plot(skeletonJoints(:,1), skeletonJoints(:,2), '*');
            hold off;
            
        end
    end
end
stop(depthVid);


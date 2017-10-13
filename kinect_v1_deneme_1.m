clear all; close all; clc;

utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);

colorVid = videoinput('kinect',1,'RGB_640x480');
depthVid = videoinput('kinect',2,'depth_640x480');

triggerconfig([colorVid depthVid],'manual');
colorVid.FramesPerTrigger = 300;
depthVid.FramesPerTrigger = 300;

% Start the color and depth device. This begins acquisition, but does not
% start logging of acquired data.
start([colorVid depthVid]);

% Trigger the devices to start logging of data.
trigger([colorVid depthVid]);

% Retrieve the frames and check if any Skeletons are tracked
[frameDataColor] = getdata(colorVid);
[frameDataDepth, timeDataDepth, metaDataDepth] = getdata(depthVid);

% Stop the devices
stop([colorVid depthVid]);

% Get the VIDEOSOURCE object from the depth device's VIDEOINPUT object.
depthSrc = getselectedsource(depthVid);
depthSrc.TrackingMode = 'Skeleton';

anyPositionsTracked = any(metaDataDepth(270).IsPositionTracked ~= 0)
anySkeletonsTracked = any(metaDataDepth(270).IsSkeletonTracked ~= 0)

% See which skeletons were tracked.
trackedSkeletons = find(metaDataDepth(270).IsSkeletonTracked)

jointCoordinates = metaDataDepth(270).JointWorldCoordinates(:, :, trackedSkeletons)
% Skeleton's joint indices with respect to the color image
jointIndices = metaDataDepth(270).JointImageIndices(:, :, trackedSkeletons)

% Pull out the 95th color frame
image = frameDataColor(:, :, :, 270);

% Find number of Skeletons tracked
nSkeleton = length(trackedSkeletons);

% Plot the skeleton
util_skeletonViewer(jointIndices, image, nSkeleton);
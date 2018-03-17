#pragma once

#include "Kinect.h"
#include <gl/GL.h>
#include <gl/GLU.h>

#define width = 1920;
#define height = 1080;

class Device
{
public:

	IKinectSensor* sensor;
	IDepthFrameSource* depthSource = NULL;
	IDepthFrameReader* depthReader;
	IBodyFrameSource* bodySource = NULL;
	IBodyFrameReader* bodyReader;

	Device();

	void getDepth();

	bool initKinect();

	~Device();

};


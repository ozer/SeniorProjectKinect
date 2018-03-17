#include "stdafx.h"
#include "Device.h"

Device::Device()
{
	printf("Device class initilization... \n");

}

bool Device::initKinect() {

	if (FAILED(GetDefaultKinectSensor(&sensor))) {

		printf("Kinect sensor has been initialized successfully ! \n");

		return false;

	}

	if (sensor) {

		printf("We got the kinect sensor ! \n");

		sensor->get_DepthFrameSource(&depthSource);

		sensor->get_BodyFrameSource(&bodySource);

		bodySource->OpenReader(&bodyReader);

		depthSource->OpenReader(&depthReader);

		bodySource->Release();

		depthSource->Release();

		return true;
	}
	else {

		return false;

	}

}

void Device::getDepth() {

	IBodyFrame* bodyfra;

	HRESULT hr = bodyReader->AcquireLatestFrame(&bodyfra);

}


Device::~Device()
{
	printf("Device is killed !");
}

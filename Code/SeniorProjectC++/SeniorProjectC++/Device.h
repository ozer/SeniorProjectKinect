#pragma once

#include "Kinect.h"
#include <gl/GL.h>
#include <gl/GLU.h>
#include <fstream>
#include <ostream>
#include <sstream>
#include <string>
#include <chrono>
#include <Windows.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <future>

using namespace std;
using namespace cv;


#define width = 1920;
#define height = 1080;
#define BODY_LIMIT 6

template<typename T>
void safeRelease(T& ptr) { if (ptr) { ptr->Release(); ptr = nullptr; } }

class Device
{
public:

	IKinectSensor* sensor;
	IDepthFrameSource* depthSource = NULL;
	IColorFrameSource* colorSource = NULL;
	IColorFrameReader* colorReader;
	IDepthFrameReader* depthReader;
	IBodyFrameSource* bodySource = NULL;
	IBodyFrameReader* bodyReader = nullptr;
	ICoordinateMapper* mapper = NULL;

	static const int color_w_ = 1920;
	static const int color_h_ = 1080;

	UINT64 *trackingId;

	uint64_t numMs;

	string fileName = "metaData.csv";

	ofstream fileHandler;

	int m_depthWidth = 0, m_depthHeight = 0;

	HRESULT hResult = S_OK;
	Joint joints[JointType_Count];
	BOOLEAN tracked;

	Device();

	bool initKinect();

	void getDepth();

	void getRGB();

	void getBody();

	void recordBodyData();

	void recordColorData();

	void processJoints();

	void saveData();

	void saveFrame(IColorFrame *frame);

	void imageAcquisitionToCalibrate();

	void writeCSV(Joint *joints);

	void captureAndShow();

	~Device();

};


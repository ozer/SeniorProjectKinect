#include "stdafx.h"
#include "Device.h"
#include <iostream>
#include <thread>

using namespace std;

Device::Device()
{
	printf("Device class initilization... \n");

}

bool Device::initKinect() {

	fileHandler.open("metaData.csv");

	if (fileHandler.fail()) {

		cerr << "Error Opening file ! \n" << endl;

		return false;
	}
	else {
		printf("CSV file is opened successfully ! \n");

		fileHandler << "Time" << ";";
		fileHandler << "Head" << ";";
		fileHandler << "Neck" << ";";
		fileHandler << "Spine Shoulder" << ";";
		fileHandler << "Spine Mid" << ";";
		fileHandler << "Spine Base" << ";";
		fileHandler << "R Shoulder" << ";";
		fileHandler << "L Shoulder" << ";";
		fileHandler << "R Elbow" << ";";
		fileHandler << "L Elbow" << ";";
		fileHandler << "R Wrist" << ";";
		fileHandler << "L Wrist" << ";";
		fileHandler << "R Hand" << ";";
		fileHandler << "L Hand" << ";";
		fileHandler << "R Hand Tip" << ";";
		fileHandler << "L Hand Tip" << ";";
		fileHandler << "R Thumb" << ";";
		fileHandler << "L Thumb" << ";";
		fileHandler << "R Hip" << ";";
		fileHandler << "L Hip" << ";";
		fileHandler << "R Knee" << ";";
		fileHandler << "L Knee" << ";";
		fileHandler << "R Ankle" << ";";
		fileHandler << "L Ankle" << ";";
		fileHandler << "R Foot" << ";";
		fileHandler << "L Foot" << ";";
		fileHandler << "\n";
	}


	hResult = GetDefaultKinectSensor(&sensor);

	if (FAILED(hResult)) {

		printf("Kinect sensor has not been initialized successfully ! \n");

		return false;

	}

	hResult = sensor->Open();

	if (FAILED(hResult)) {

		printf("Kinect sensor could not be opened successfully ! \n");

		return false;

	}

	hResult = sensor->get_CoordinateMapper(&mapper);

	if (FAILED(hResult)) {

		printf("Coordinate mapper object has not been initialized successfully ! \n");

		return false;

	}

	hResult = sensor->get_DepthFrameSource(&depthSource);

	if (FAILED(hResult)) {

		printf("Depth Source has not been initialized successfully ! \n");

		return false;

	}

	hResult = sensor->get_ColorFrameSource(&colorSource);

	if (FAILED(hResult)) {

		printf("Color Source has not been initialized successfully ! \n");

		return false;

	}

	hResult = sensor->get_BodyFrameSource(&bodySource);

	if (FAILED(hResult)) {

		printf("Body Source has not been initialized successfully ! \n");

		return false;

	}

	hResult = bodySource->OpenReader(&bodyReader);

	if (FAILED(hResult)) {

		printf("Body Reader has not been initialized successfully ! \n");

		return false;

	}

	hResult = colorSource->OpenReader(&colorReader);

	if (FAILED(hResult)) {

		printf("Color Reader has not been initialized successfully ! \n");

		return false;

	}

	hResult = depthSource->OpenReader(&depthReader);

	if (FAILED(hResult)) {

		printf("Depth reader has not been initialized successfully ! \n");

		return false;

	}

	safeRelease(bodySource);

	safeRelease(colorSource);

	safeRelease(depthSource);

	printf("Everything looks fine ! \n");


}

void Device::getDepth() {

	IDepthFrame* depthfra = NULL;

	hResult = depthReader->AcquireLatestFrame(&depthfra);
	
	if (SUCCEEDED(hResult)) {

		printf("Depth image acquisition has done successfully ! \n");

		safeRelease(depthfra);

	}
	else {

		printf("Depth image acquisition has been failed ! \n");

	}

}

void Device::getRGB() {

	IColorFrame* colorfra = NULL;

	hResult = colorReader->AcquireLatestFrame(&colorfra);

	if (SUCCEEDED(hResult)) {

		printf("RGB image acquisition has done successfully ! \n");

	}
	else {

		printf("RGB image acquisition has been failed ! \n");

	}

}

void Device::getBody() {

	IBodyFrame* bodyfra = NULL;

	IBody* bodies[BODY_COUNT] = {0};

	hResult = bodyReader->AcquireLatestFrame(&bodyfra);

	if (SUCCEEDED(hResult)) {

		printf("Body image acquisition has done successfully ! \n");

		hResult = bodyfra->GetAndRefreshBodyData(_countof(bodies), bodies);

		if (SUCCEEDED(hResult)) {

			printf("Hey ! \n ");

			printf("%d \n", _countof(bodies));

			for (int bodyIndex = 0; bodyIndex < BODY_COUNT; bodyIndex++) {

				IBody *body = bodies[bodyIndex];

				//Get the tracking status for the body, if it's not tracked we'll skip it
				tracked = false;
				hResult = body->get_IsTracked(&tracked);
				if (FAILED(hResult) || tracked == false) {

					printf("Tracked Status 0\n");

					continue;

				}

				hResult = body->GetJoints(_countof(joints), joints);

				if (SUCCEEDED(hResult)) {

					printf("Heeeey we got some joints ! \n ");

					const CameraSpacePoint &leftHandPos = joints[JointType_HandLeft].Position;
					const CameraSpacePoint &rightHandPos = joints[JointType_HandRight].Position;
					const CameraSpacePoint &headPos = joints[JointType_Head].Position;



					if (leftHandPos.Y > rightHandPos.Y) {

						printf("Left hand is at higher position then right hand ! \n");

					}

					for (unsigned int bodyIndex = 0; bodyIndex < _countof(bodies); bodyIndex++) {
						safeRelease(bodies[bodyIndex]);
					}

					safeRelease(bodyfra);

				}
			
			}
		
		}

	}
	else {

		printf("Body image acquisition has been failed ! \n");

	}

}

void Device::recordBodyData() {

	printf("We are going to acquire body frames \n");

	while (bodyReader != nullptr)
	{

		IBodyFrame* bodyfra;

		hResult = bodyReader->AcquireLatestFrame(&bodyfra);

		if (SUCCEEDED(hResult)) {

			IBody* bodies[BODY_COUNT] = { 0 };

			printf("Body Frame has been captured \n ");

			hResult = bodyfra->GetAndRefreshBodyData(_countof(bodies), bodies);

			if (SUCCEEDED(hResult)) {

				printf("Get and refresh body data succeeded ! \n ");

				// Processing the body and joints !!

				for (int bodyIndex = 0; bodyIndex < BODY_COUNT; bodyIndex++) {

					IBody *body = bodies[bodyIndex];

					//Get the tracking status for the body, if there is not any body tracked we will skip it

					tracked = false;

					hResult = body->get_IsTracked(&tracked);

					if (FAILED(hResult) || tracked == false) {

						printf("Tracked Status 0\n");

						continue;

					}

					printf("Body index counter : %d \n", bodyIndex);

					hResult = body->GetJoints(_countof(joints), joints);

					if (SUCCEEDED(hResult)) {

						printf("Heeeey we got some joints ! \n ");

						writeCSV(joints);

					}

				}

				// Releasing body data extracted from body frame

				for (unsigned int bodyIndex = 0; bodyIndex < _countof(bodies); bodyIndex++) {
					safeRelease(bodies[bodyIndex]);
				}

				// Releasing body frame

				safeRelease(bodyfra);

			}

			if (FAILED(hResult)) {

				printf("Get and refresh body data is failed ! \n");

			}

		}

	}

	printf("Out of while loop ! \n");

}

void Device::captureAndShow() {

	IColorFrame* colorfra;

	hResult = this->colorReader->AcquireLatestFrame(&colorfra);

	if (SUCCEEDED(hResult)) {

		printf("Camera acquired color frame ! \n");

		saveFrame(colorfra);

	}

	// safeRelease(colorfra);

}

void Device::recordColorData() {

	printf("We are going to acquire color frames \n");

	while (colorReader != nullptr) {

		IColorFrame* colorfra;

		hResult = colorReader->AcquireLatestFrame(&colorfra);

		if (SUCCEEDED(hResult)) {

			printf("Camera acquired color frame ! \n");

			//saveFrame(colorfra);
			saveFrameNew(colorfra);
		}

		safeRelease(colorfra);

	}

}

void Device::imageAcquisitionToCalibrate() {

	if (colorReader != nullptr) {

		IColorFrame* colorFrame;

		hResult = colorReader->AcquireLatestFrame(&colorFrame);

		if (SUCCEEDED(hResult)) {

			printf("Camera acquired color frame ! /n");

			saveFrame(colorFrame);

		}

		safeRelease(colorFrame);

	}
		

}

void Device::writeCSV(Joint *joints) {

	printf("Starting to write to the csv file \n");

	const CameraSpacePoint &leftHandPos = joints[JointType_HandLeft].Position;
	const int leftHandTrackingState = joints[JointType_HandLeft].TrackingState;

	const CameraSpacePoint &rightHandPos = joints[JointType_HandRight].Position;
	const int rightHandTrackingState = joints[JointType_HandRight].TrackingState;

	const CameraSpacePoint &rightHandTip = joints[JointType_HandTipRight].Position;
	const CameraSpacePoint &leftHandTip = joints[JointType_HandTipLeft].Position;

	const CameraSpacePoint &spineBase = joints[JointType_SpineBase].Position;
	const CameraSpacePoint &spineMid = joints[JointType_SpineMid].Position;
	const CameraSpacePoint &spineShoulder = joints[JointType_SpineShoulder].Position;

	const CameraSpacePoint &headPos = joints[JointType_Head].Position;
	const CameraSpacePoint &neckPos = joints[JointType_Neck].Position;

	const CameraSpacePoint &rightShoulderPos = joints[JointType_ShoulderRight].Position;
	const CameraSpacePoint &leftShoulderPos = joints[JointType_ShoulderLeft].Position;

	const CameraSpacePoint &rightElbow = joints[JointType_ElbowRight].Position;
	const CameraSpacePoint &leftElbow = joints[JointType_ElbowLeft].Position;

	const CameraSpacePoint &rightWrist = joints[JointType_WristRight].Position;
	const CameraSpacePoint &leftWrist = joints[JointType_WristLeft].Position;

	const CameraSpacePoint &rightAnkle = joints[JointType_AnkleRight].Position;
	const CameraSpacePoint &leftAnkle = joints[JointType_AnkleLeft].Position;

	const CameraSpacePoint &rightFoot = joints[JointType_FootRight].Position;
	const CameraSpacePoint &leftFoot = joints[JointType_FootLeft].Position;

	const CameraSpacePoint &rightHip = joints[JointType_HipRight].Position;
	const CameraSpacePoint &leftHip = joints[JointType_HipLeft].Position;

	const CameraSpacePoint &rightKnee = joints[JointType_KneeRight].Position;
	const CameraSpacePoint &leftKnee = joints[JointType_KneeLeft].Position;

	const CameraSpacePoint &rightThumb = joints[JointType_ThumbRight].Position;
	const CameraSpacePoint &leftThumb = joints[JointType_ThumbLeft].Position;

	cout << "Successfull Frame ! " << endl;

	// First, We get the world milliseconds since 1970.

	chrono::milliseconds ms = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	// uint64_t num = ms.count();

	this->numMs = ms.count();

	// 1 Write ms to the csv
	fileHandler << this->numMs << ";";

	// 2 Write Head position to the csv

	fileHandler << headPos.X << " " << headPos.Y << " " << headPos.Z << ";";

	// 3 Write Neck position to the csv

	fileHandler << neckPos.X << " " << neckPos.Y << " " << neckPos.Z << ";";

	// 4 Write Spine Shoulder to the csv

	fileHandler << spineShoulder.X << " " << spineShoulder.Y << " " << spineShoulder.Z << ";";

	// 5 Write Spine Mid to the csv

	fileHandler << spineMid.X << " " << spineMid.Y << " " << spineMid.Z << ";";

	// 6 Write Spine Base to the csv

	fileHandler << spineBase.X << " " << spineBase.Y << " " << spineBase.Z << ";";

	// 7 Write right shoulder to the csv

	fileHandler << rightShoulderPos.X << " " << rightShoulderPos.Y << " " << rightShoulderPos.Z << ";";

	// 8 Write left shoulder to the csv

	fileHandler << leftShoulderPos.X << " " << leftShoulderPos.Y << " " << leftShoulderPos.Z << ";";

	// 9 Write right elbow to the csv

	fileHandler << rightElbow.X << " " << rightElbow.Y << " " << rightShoulderPos.Z << ";";

	// 10 Write left elbow to the csv

	fileHandler << leftElbow.X << " " << leftElbow.Y << " " << leftElbow.Z << ";";

	// 11 Write right wrist to the csv

	fileHandler << rightWrist.X << " " << rightWrist.Y << " " << rightWrist.Z << ";";

	// 12 Write left wrist to the csv

	fileHandler << leftWrist.X << " " << leftWrist.Y << " " << leftWrist.Z << ";";

	// 13 Write right hand to the csv

	fileHandler << rightHandPos.X << " " << rightHandPos.Y << " " << rightHandPos.Z << ";";

	// 14 Write left hand to the csv

	fileHandler << leftHandPos.X << " " << leftHandPos.Y << " " << leftHandPos.Z << ";";

	// 15 Write right hand tips to the csv

	fileHandler << rightHandTip.X << " " << rightHandTip.Y << " " << rightHandTip.Z << ";";

	// 16 Write left hand tips to the csv

	fileHandler << leftHandTip.X << " " << leftHandTip.Y << " " << leftHandTip.Z << ";";

	// 17 Write right thumb to the csv

	fileHandler << rightThumb.X << " " << rightThumb.Y << " " << rightThumb.Z << ";";

	// 18 Write left thumb to the csv

	fileHandler << leftThumb.X << " " << leftThumb.Y << " " << leftThumb.Z << ";";

	// 19 Write right hip to the csv

	fileHandler << rightHip.X << " " << rightHip.Y << " " << rightHip.Z << ";";

	// 20 Write left hip to the csv

	fileHandler << leftHip.X << " " << leftHip.Y << " " << leftHip.Z << ";";

	// 21 Write right knee to the csv

	fileHandler << rightKnee.X << " " << rightKnee.Y << " " << rightKnee.Z << ";";

	// 22 Write left knee to the csv

	fileHandler << leftKnee.X << " " << leftKnee.Y << " " << leftKnee.Z << ";";

	// 23 Write right ankle to the csv

	fileHandler << rightAnkle.X << " " << rightAnkle.Y << " " << rightAnkle.Z << ";";

	// 24 Write left ankle to the csv

	fileHandler << leftAnkle.X << " " << leftAnkle.Y << " " << leftAnkle.Z << ";";

	// 25 Write right foot to the csv

	fileHandler << rightFoot.X << " " << rightFoot.Y << " " << rightFoot.Z << ";";

	// 26 Write left food to the csv

	fileHandler << leftFoot.X << " " << leftFoot.Y << " " << leftFoot.Z << ";";

	// Alt satýra geçme

	fileHandler << "\n";

}


void Device::saveFrame(IColorFrame *frame) {

	chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	IFrameDescription *frameDesc;

	INT frame_width;
	INT frame_height;

	Mat colorImage;

	frame->get_FrameDescription(&frameDesc);

	frameDesc->get_Height(&frame_height);

	frameDesc->get_Width(&frame_width);

	safeRelease(frameDesc);

	frame_width = abs(frame_width);

	frame_height = abs(frame_height);

	ColorImageFormat imageFormat = ColorImageFormat_None;

	hResult = frame->get_RawColorImageFormat(&imageFormat);

	cv::Mat color_mat(this->color_h_, this->color_w_, CV_8UC4);

	const int buf_size = color_h_ * color_w_ * sizeof(uint8_t) * 4;

	chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	hResult = frame->CopyConvertedFrameDataToArray(buf_size, color_mat.data, ColorImageFormat_Bgra);

	// cv::imshow("Color", color_mat);

	// cv::waitKey(10);

	string mmm = to_string(this->numMs);

	cv::imwrite("images/1"+mmm+".jpg", color_mat);

	chrono::milliseconds end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	std::cout << "Time difference in microseconds = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << std::endl;

}

void Device::saveFrameNew(IColorFrame *frame) {

	chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	cout << "Got color frame: \n";
	INT64 nTime = 0;
	IFrameDescription* pFrameDescription = NULL;
	int nWidth = 0;
	int nHeight = 0;
	ColorImageFormat imageFormat = ColorImageFormat_None;
	UINT nBufferSize = 0;
	RGBQUAD *pBuffer = NULL;

	hResult = frame->get_RawColorImageFormat(&imageFormat);

	if (imageFormat == ColorImageFormat_Bgra)
	{
		hResult = frame->AccessRawUnderlyingBuffer(&nBufferSize, reinterpret_cast<BYTE**>(&pBuffer));
		cout << "Frame color Format 1 \n";
	}
	else if (m_pColorRGBX)
	{
		pBuffer = m_pColorRGBX;
		nBufferSize = cColorWidth * cColorHeight * sizeof(RGBQUAD);
		hResult = frame->CopyConvertedFrameDataToArray(nBufferSize, reinterpret_cast<BYTE*>(pBuffer), ColorImageFormat_Bgra);
		cout << "Frame color Format 2 \n";
	}
	else
	{
		hResult = E_FAIL;
	}
	 
	BYTE* bytepImage = reinterpret_cast<BYTE*>(pBuffer);
	Mat image = Mat(1080, 1920, CV_8UC4, reinterpret_cast<void*>(bytepImage));

	string mmm = to_string(this->numMs);
	cv::imwrite("images/1" + mmm + ".jpg", image);

	chrono::milliseconds end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	std::cout << "Time difference in microseconds = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << std::endl;

}

void Device::drawJoints() {

		if(bodyReader != nullptr){

			IBodyFrame* bodyfra;

			hResult = bodyReader->AcquireLatestFrame(&bodyfra);

			if (SUCCEEDED(hResult)) {

				IBody* bodies[BODY_COUNT] = { 0 };

				printf("Body Frame has been captured \n ");

				hResult = bodyfra->GetAndRefreshBodyData(_countof(bodies), bodies);

				if (SUCCEEDED(hResult)) {

					printf("Get and refresh body data succeeded ! \n ");

					// Processing the body and joints !!

					for (int bodyIndex = 0; bodyIndex < BODY_COUNT; bodyIndex++) {

						IBody *body = bodies[bodyIndex];

						//Get the tracking status for the body, if there is not any body tracked we will skip it

						tracked = false;

						hResult = body->get_IsTracked(&tracked);

						if (FAILED(hResult) || tracked == false) {

							printf("Tracked Status 0\n");

							continue;

						}

						printf("Body index counter : %d \n", bodyIndex);

						hResult = body->GetJoints(_countof(joints), joints);

						if (SUCCEEDED(hResult)) {

							printf("Heeeey we got some joints ! \n ");

							// Joints 

							const CameraSpacePoint &leftHandPos = joints[JointType_HandLeft].Position;
							const int leftHandTrackingState = joints[JointType_HandLeft].TrackingState;

							const CameraSpacePoint &rightHandPos = joints[JointType_HandRight].Position;
							const int rightHandTrackingState = joints[JointType_HandRight].TrackingState;

							const CameraSpacePoint &rightHandTip = joints[JointType_HandTipRight].Position;

							const CameraSpacePoint &spineBase = joints[JointType_SpineBase].Position;
							const CameraSpacePoint &spineMid = joints[JointType_SpineMid].Position;
							const CameraSpacePoint &spineShoulder = joints[JointType_SpineShoulder].Position;

							const CameraSpacePoint &headPos = joints[JointType_Head].Position;
							const CameraSpacePoint &neckPos = joints[JointType_Neck].Position;

							const CameraSpacePoint &rightShoulderPos = joints[JointType_ShoulderRight].Position;
							const CameraSpacePoint &rightElbow = joints[JointType_ElbowRight].Position;
							const CameraSpacePoint &rightWrist = joints[JointType_WristRight].Position;

							const CameraSpacePoint &leftShoulderPos = joints[JointType_ShoulderLeft].Position;

							ColorSpacePoint headPlot;
							ColorSpacePoint neckPlot;
							ColorSpacePoint rightShoulderPlot;
							ColorSpacePoint spineMidPlot;
							ColorSpacePoint spineBasePlot;
							ColorSpacePoint rightElbowPlot;
							ColorSpacePoint rightWristPlot;
							ColorSpacePoint rightHandPlot;
							ColorSpacePoint rightHandTipPlot;
							// Head, Neck, Spine Mid, Spine Base, Right Shoulder, Right Elbow, Right Wrist, Right Hand, Right Hand Tip

							mapper->MapCameraPointToColorSpace(headPos, &headPlot);
							mapper->MapCameraPointToColorSpace(neckPos, &neckPlot);
							mapper->MapCameraPointToColorSpace(spineMid, &spineMidPlot);
							mapper->MapCameraPointToColorSpace(spineBase, &spineBasePlot);
							mapper->MapCameraPointToColorSpace(rightShoulderPos, &rightShoulderPlot);
							mapper->MapCameraPointToColorSpace(rightElbow, &rightElbowPlot);
							mapper->MapCameraPointToColorSpace(rightWrist, &rightWristPlot);
							mapper->MapCameraPointToColorSpace(rightHandPos, &rightHandPlot);
							mapper->MapCameraPointToColorSpace(rightHandTip, &rightHandTipPlot);


							if (colorReader != nullptr) {

								printf("We got the color reader ! /n");

								IFrameDescription *frameDesc;

								INT frame_width;
								INT frame_height;

								IColorFrame *colorFrame = nullptr;

								colorReader->AcquireLatestFrame(&colorFrame);

								colorFrame->get_FrameDescription(&frameDesc);

								frameDesc->get_Height(&frame_height);

								frameDesc->get_Width(&frame_width);

								frame_width = abs(frame_width);

								frame_height = abs(frame_height);

								ColorImageFormat imageFormat = ColorImageFormat_None;

								hResult = colorFrame->get_RawColorImageFormat(&imageFormat);

								Mat color_mat(this->color_h_, this->color_w_, CV_8UC4);

								const int buf_size = color_h_ * color_w_ * sizeof(uint8_t) * 4;

								chrono::milliseconds end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

								chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

								hResult = colorFrame->CopyConvertedFrameDataToArray(buf_size, color_mat.data, ColorImageFormat_Bgra);

								rectangle(color_mat, cv::Rect((int)headPlot.X - 5, (int)headPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)neckPlot.X - 5, (int)neckPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)spineMidPlot.X - 5, (int)spineMidPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)spineBasePlot.X - 5, (int)spineBasePlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)rightShoulderPlot.X - 5, (int)rightShoulderPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)rightElbowPlot.X - 5, (int)rightElbowPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)rightWristPlot.X - 5, (int)rightWristPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)rightHandPlot.X - 5, (int)rightHandPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);
								rectangle(color_mat, cv::Rect((int)rightHandTipPlot.X - 5, (int)rightHandTipPlot.Y - 5, 10, 10), cv::Scalar(0, 0, 255), 2);

								imwrite("images/Joints.jpg", color_mat);

								safeRelease(colorFrame);

							}

							// writeCSV(joints);

						}

					}

					// Releasing body data extracted from body frame

					for (unsigned int bodyIndex = 0; bodyIndex < _countof(bodies); bodyIndex++) {
						safeRelease(bodies[bodyIndex]);
					}

					// Releasing body frame

					safeRelease(bodyfra);

				}

				if (FAILED(hResult)) {

					printf("Get and refresh body data is failed ! \n");

				}

			}
			
		}

}

Device::~Device()
{
	printf("Device is killed !");

	delete(&sensor);

	fileHandler.close();

}

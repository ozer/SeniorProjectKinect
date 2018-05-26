#include "stdafx.h"
#include "Device.h"
#include <iostream>
#include <thread>

using namespace std;

// Constructor.
Device::Device()
{
	printf("Device class initilization... \n");

}

bool Device::initKinect() {

	// Open CSV file.
	fileHandler.open("metaData.csv");

	// Do not initiate to recording due to an error about writing to the file.
	if (fileHandler.fail()) {
		cerr << "Error Opening file ! \n" << endl;
		return false;
	}
	else {
		printf("CSV file is opened successfully ! \n");

		// Creating the columns to the CSV file.
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
		fileHandler << "Frame No." << ";";
		fileHandler << "\n";
	}

	// Getting the Kinect sensor and initializing the sources and the readers of the sensors of the Kinect device.
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

	// Releasing the unnecessary source objects.
	safeRelease(bodySource);
	safeRelease(colorSource);
	safeRelease(depthSource);
	printf("Everything looks fine ! \n");
	return true;
}

void Device::recordBodyData() {
	printf("We are going to acquire body frames \n");
	while (bodyReader != nullptr)
	{
		IBodyFrame* bodyfra = nullptr;
		// Acquire the body frame.
		hResult = bodyReader->AcquireLatestFrame(&bodyfra);
		if (SUCCEEDED(hResult) && bodyfra != nullptr) {
			IBody* bodies[BODY_COUNT] = { 0 };
			// Extract bodies from the body frame.
			hResult = bodyfra->GetAndRefreshBodyData(_countof(bodies), bodies);
			if (SUCCEEDED(hResult)) {
				// Processing the body and joints !!
				for (int bodyIndex = 0; bodyIndex < BODY_COUNT; bodyIndex++) {
					IBody *body = bodies[bodyIndex];
					//Get the tracking status for the body, if there is not any body tracked we will skip it
					tracked = false;
					hResult = body->get_IsTracked(&tracked);
					if (FAILED(hResult) || tracked == false) {
						continue;
					}
					// Extract the joints from the body.
					hResult = body->GetJoints(_countof(joints), joints);
					if (SUCCEEDED(hResult)) {
						printf("We tracked some joints ! \n");
						// First, We get the world milliseconds since 1970.
						chrono::milliseconds ms = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
						this->numMs = ms.count();
						// Write the joints to the csv file.
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

void Device::recordColorData() {
	printf("We are going to acquire color frames \n");
	// Check the reader is ready to capture frame
	while (colorReader != nullptr) {
		// Initialize an empty frame
		IColorFrame* colorfra = nullptr;
		// Capture a color frame
		colorResult = colorReader->AcquireLatestFrame(&colorfra);
		// Initialize a chrono variable to calculate the execution time to search for improvements
		std::chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
		std::chrono::milliseconds end;
		// If the frame captured successfully,
		if (SUCCEEDED(colorResult)) {
			// Initialize the frame descriptor to get the dimensions of the captured frame.
			IFrameDescription *frameDesc;
			INT frame_width;
			INT frame_height;
			// Initialize an empty image which we ll fill it with RGB values below.
			Mat colorImage;
			// Acquire the information about the captured color frame.
			colorfra->get_FrameDescription(&frameDesc);
			frameDesc->get_Height(&frame_height);
			frameDesc->get_Width(&frame_width);
			// Releasing the frame descriptor.
			safeRelease(frameDesc);
			// Constructing the RGB image using OpenCV.
			frame_width = abs(frame_width);
			frame_height = abs(frame_height);
			ColorImageFormat imageFormat = ColorImageFormat_None;
			hResult = colorfra->get_RawColorImageFormat(&imageFormat);
			cv::Mat color_mat(this->color_h_, this->color_w_, CV_8UC4);
			const int buf_size = color_h_ * color_w_ * sizeof(uint8_t) * 4;
			hResult = colorfra->CopyConvertedFrameDataToArray(buf_size, color_mat.data, ColorImageFormat_Bgra);
			// If the construction is successfully done,
			if (SUCCEEDED(colorResult)) {
				// Get milliseconds to write with its value
				string milliSecondsString = to_string(this->numMs);
				std::cout << "Milliseconds : " << milliSecondsString << endl;
				// Write the image inside the directory named images using OpenCV.
				cv::imwrite("images/" + milliSecondsString + ".jpg", color_mat);
				// End the timer and get the execution time in the milliseconds.
				end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
				std::cout << "Time difference in recording RGB Image in microseconds = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << std::endl;
			}
			else {
				std::cout << "RGB Image could not be extracted so writing operation has been passed !" << endl;
			}
			// Releasing the color frame.
			safeRelease(colorfra);
		}
	}
}

void Device::writeCSV(Joint *joints) {

	printf("Starting write joints data to the CSV file \n");

	// Initialize a chrono variable to calculate the execution time to search for improvements
	chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

	// Acquiring the locations ( X, Y, Z ) of each of the 25 joints on the body respect to the main coordination space of the Kinect sensor.
	const CameraSpacePoint &leftHandPos = joints[JointType_HandLeft].Position;
	const CameraSpacePoint &rightHandPos = joints[JointType_HandRight].Position;
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

	std::cout << "Successfull Frame ! " << endl;

	// Writing to the csv file.
	fileHandler << to_string(this->numMs) << ";";
	fileHandler << headPos.X << " " << headPos.Y << " " << headPos.Z << ";";
	fileHandler << neckPos.X << " " << neckPos.Y << " " << neckPos.Z << ";";
	fileHandler << spineShoulder.X << " " << spineShoulder.Y << " " << spineShoulder.Z << ";";
	fileHandler << spineMid.X << " " << spineMid.Y << " " << spineMid.Z << ";";
	fileHandler << spineBase.X << " " << spineBase.Y << " " << spineBase.Z << ";";
	fileHandler << rightShoulderPos.X << " " << rightShoulderPos.Y << " " << rightShoulderPos.Z << ";";
	fileHandler << leftShoulderPos.X << " " << leftShoulderPos.Y << " " << leftShoulderPos.Z << ";";
	fileHandler << rightElbow.X << " " << rightElbow.Y << " " << rightElbow.Z << ";";
	fileHandler << leftElbow.X << " " << leftElbow.Y << " " << leftElbow.Z << ";";
	fileHandler << rightWrist.X << " " << rightWrist.Y << " " << rightWrist.Z << ";";
	fileHandler << leftWrist.X << " " << leftWrist.Y << " " << leftWrist.Z << ";";
	fileHandler << rightHandPos.X << " " << rightHandPos.Y << " " << rightHandPos.Z << ";";
	fileHandler << leftHandPos.X << " " << leftHandPos.Y << " " << leftHandPos.Z << ";";
	fileHandler << rightHandTip.X << " " << rightHandTip.Y << " " << rightHandTip.Z << ";";
	fileHandler << leftHandTip.X << " " << leftHandTip.Y << " " << leftHandTip.Z << ";";
	fileHandler << rightThumb.X << " " << rightThumb.Y << " " << rightThumb.Z << ";";
	fileHandler << leftThumb.X << " " << leftThumb.Y << " " << leftThumb.Z << ";";
	fileHandler << rightHip.X << " " << rightHip.Y << " " << rightHip.Z << ";";
	fileHandler << leftHip.X << " " << leftHip.Y << " " << leftHip.Z << ";";
	fileHandler << rightKnee.X << " " << rightKnee.Y << " " << rightKnee.Z << ";";
	fileHandler << leftKnee.X << " " << leftKnee.Y << " " << leftKnee.Z << ";";
	fileHandler << rightAnkle.X << " " << rightAnkle.Y << " " << rightAnkle.Z << ";";
	fileHandler << leftAnkle.X << " " << leftAnkle.Y << " " << leftAnkle.Z << ";";
	fileHandler << rightFoot.X << " " << rightFoot.Y << " " << rightFoot.Z << ";";
	fileHandler << leftFoot.X << " " << leftFoot.Y << " " << leftFoot.Z << ";";

	// Passing to the new line.
	fileHandler << "\n";

	// End the timer and get the execution time in the milliseconds.
	chrono::milliseconds end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
	std::cout << "Time difference in writing CSV in microseconds = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << std::endl;

}

// Converting joint locations to the X, Y pixel coordinates.
cv::Point Device::changeCoordinates(Joint joint[JointType_Count], int type) {
	// Initialize the ColorSpacePoint to fill it with the X,Y coordinates of the given joint.
	ColorSpacePoint colorSpacePoint = { 0 };
	// Convert the locations of the given joint to the Color Space ( X, Y )
	mapper->MapCameraPointToColorSpace(joint[type].Position, &colorSpacePoint);
	// Casting X, Y values to the integer type
	int x = static_cast<int>(colorSpacePoint.X);
	int y = static_cast<int>(colorSpacePoint.Y);
	// Returning the Pixel Point of the given location to draw the location on the RGB image.
	return cv::Point(x, y);
}

// Draw joint function which captures body and color frame respectively and then, draw the joints on the RGB image.
// This function does not only displays the mapping of the joints on a RGB image but also records it to the hard disk.
void Device::drawJoints() {
		while(bodyReader != nullptr){
			IBodyFrame* bodyfra;
			hResult = bodyReader->AcquireLatestFrame(&bodyfra);
			if (SUCCEEDED(hResult)) {
				IBody* bodies[BODY_COUNT] = { 0 };
				printf("Body Frame has been captured \n ");
				hResult = bodyfra->GetAndRefreshBodyData(_countof(bodies), bodies);
				// Extract the data of the bodies from the body frame.
				if (SUCCEEDED(hResult)) {
					printf("Get and refresh body data succeeded ! \n ");
					// Processing the body and joints !!
					for (int bodyIndex = 0; bodyIndex < BODY_COUNT; bodyIndex++) {
						IBody *body = bodies[bodyIndex];
						//Get the tracking status for the body, if there is not any body tracked we will skip it
						tracked = false;
						hResult = body->get_IsTracked(&tracked);
						// Check the body is tracked or not.
						if (FAILED(hResult) || tracked == false) {
							printf("Tracked Status 0\n");
							continue;
						}
						// Get joints of the body.
						hResult = body->GetJoints(_countof(joints), joints);
						if (SUCCEEDED(hResult)) {
							chrono::milliseconds ms = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
							this->numMs = ms.count();
							printf("We tracked some joints ! \n");
							if (colorReader != nullptr) {
								printf("We got the color reader ! /n");
								IFrameDescription *frameDesc;
								INT frame_width;
								INT frame_height;
								IColorFrame *colorFrame = nullptr;
								colorResult = colorReader->AcquireLatestFrame(&colorFrame);
								if (SUCCEEDED(colorResult)) {
									colorFrame->get_FrameDescription(&frameDesc);
									frameDesc->get_Height(&frame_height);
									frameDesc->get_Width(&frame_width);
									frame_width = abs(frame_width);
									frame_height = abs(frame_height);
									ColorImageFormat imageFormat = ColorImageFormat_None;
									hResult = colorFrame->get_RawColorImageFormat(&imageFormat);
									Mat color_mat(this->color_h_, this->color_w_, CV_8UC4);
									const int buf_size = color_h_ * color_w_ * sizeof(uint8_t) * 4;
									chrono::milliseconds begin = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());
									hResult = colorFrame->CopyConvertedFrameDataToArray(buf_size, color_mat.data, ColorImageFormat_Bgra);
									// Line the joints
									line(color_mat, changeCoordinates(joints, JointType_Head), changeCoordinates(joints, JointType_Neck), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_Neck), changeCoordinates(joints, JointType_SpineShoulder), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_SpineShoulder), changeCoordinates(joints, JointType_ShoulderRight), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_SpineShoulder), changeCoordinates(joints, JointType_ShoulderLeft), cv::Scalar(69, 140, 204), 2);

									line(color_mat, changeCoordinates(joints, JointType_ShoulderRight), changeCoordinates(joints, JointType_ElbowRight), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_ElbowRight), changeCoordinates(joints, JointType_HandRight), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_HandRight), changeCoordinates(joints, JointType_HandTipRight), cv::Scalar(69, 140, 204), 2);

									line(color_mat, changeCoordinates(joints, JointType_ShoulderLeft), changeCoordinates(joints, JointType_ElbowLeft), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_ElbowLeft), changeCoordinates(joints, JointType_HandLeft), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_HandLeft), changeCoordinates(joints, JointType_HandTipLeft), cv::Scalar(69, 140, 204), 2);

									line(color_mat, changeCoordinates(joints, JointType_SpineShoulder), changeCoordinates(joints, JointType_SpineMid), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_SpineMid), changeCoordinates(joints, JointType_SpineBase), cv::Scalar(69, 140, 204), 2);

									line(color_mat, changeCoordinates(joints, JointType_SpineBase), changeCoordinates(joints, JointType_HipRight), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_HipRight), changeCoordinates(joints, JointType_KneeRight), cv::Scalar(69, 140, 204), 2);
									// line(color_mat, changeCoordinates(joints, JointType_KneeRight), changeCoordinates(joints, JointType_AnkleRight), cv::Scalar(69, 140, 204), 2);
									// line(color_mat, changeCoordinates(joints, JointType_AnkleRight), changeCoordinates(joints, JointType_FootRight), cv::Scalar(69, 140, 204), 2);

									line(color_mat, changeCoordinates(joints, JointType_SpineBase), changeCoordinates(joints, JointType_HipLeft), cv::Scalar(69, 140, 204), 2);
									line(color_mat, changeCoordinates(joints, JointType_HipLeft), changeCoordinates(joints, JointType_KneeLeft), cv::Scalar(69, 140, 204), 2);
									// line(color_mat, changeCoordinates(joints, JointType_KneeLeft), changeCoordinates(joints, JointType_AnkleLeft), cv::Scalar(69, 140, 204), 2);
									// line(color_mat, changeCoordinates(joints, JointType_AnkleLeft), changeCoordinates(joints, JointType_FootLeft), cv::Scalar(69, 140, 204), 2);

									chrono::milliseconds end = chrono::duration_cast<chrono::milliseconds>(chrono::system_clock::now().time_since_epoch());

									std::cout << "Time difference in charting and showing RGB Image in microseconds = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << std::endl;

									imshow("Skeletons", color_mat);
									waitKey(5);
									Sleep(40);
									
									string mmm = to_string(this->numMs);
								}
								// Releasing the color frame
								safeRelease(colorFrame);
							}
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

// Deconstructor.
Device::~Device()
{
	printf("Device is killed !");

	delete(&sensor);

	fileHandler.close();

}

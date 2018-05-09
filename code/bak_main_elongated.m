clear all;

result_dir = '/Users/ishan/Dropbox/Columbia/sem2/visual/project/data/results_data_ishan/';
PoseNumKeyPoints = 18;
FaceNumKeyPoints = 70;

IndexLipPointLeft = 54;
IndexLipPointRight = 48;

IndexEyePointLeft = 44;
IndexEyebrowPointLeft = 24;
IndexEyePointRight = 37;
IndexEyebrowPointRight = 19;

IndexEarRight = 16;
IndexEyeRight = 14;
IndexEarLeft = 17;
IndexEyeLeft = 15;



BaseKeyPointsFace = GetKeyPoints([result_dir 'base.mov/'], FaceNumKeyPoints, 'face');
SmileKeyPoints = GetKeyPoints([result_dir 'base_smile.mov/'], FaceNumKeyPoints, 'face');
OKeyPoints = GetKeyPoints([result_dir 'base_o.mov/'], FaceNumKeyPoints, 'face');
EyebrowRaiseKeyPoints = GetKeyPoints([result_dir 'base_eyebrow.mov/'], FaceNumKeyPoints, 'face');

BaseKeyPointsBody = GetKeyPoints([result_dir 'base.mov/'], PoseNumKeyPoints, 'pose');
RightTurnKeyPoints = GetKeyPoints([result_dir 'base_right.mov/'], PoseNumKeyPoints, 'pose');
LeftTurnKeyPoints = GetKeyPoints([result_dir 'base_left.mov/'], PoseNumKeyPoints, 'pose');




% Smile detection
[BaseLipPointLeftX, BaseLipPointLeftY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexLipPointLeft);
[BaseLipPointRightX, BaseLipPointRightY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexLipPointRight);

BaseLipXDistance = abs(BaseLipPointRightX - BaseLipPointLeftX);
BaseLipXDistanceMedian = median(BaseLipXDistance);

[SmileLipPointLeftX, SmileLipPointLeftY] = getXYGivenZeroBaseIndex(SmileKeyPoints, IndexLipPointLeft);
[SmileLipPointRightX, SmileLipPointRightY] = getXYGivenZeroBaseIndex(SmileKeyPoints, IndexLipPointRight);

SmileLipXDistance = abs(SmileLipPointRightX - SmileLipPointLeftX);
SmileLipXDistanceMedian = median(SmileLipXDistance);

ThresholdSmile = BaseLipXDistanceMedian + (0.4*(SmileLipXDistanceMedian - BaseLipXDistanceMedian));

% O detection
[OLipPointLeftX, OLeftLipPointRightY] = getXYGivenZeroBaseIndex(OKeyPoints, IndexLipPointLeft);
[OLipPointRightX, OLipPointRightY] = getXYGivenZeroBaseIndex(OKeyPoints, IndexLipPointRight);

OLipXDistanceMedian = median(abs(OLipPointRightX - OLipPointLeftX));

ThresholdO = BaseLipXDistanceMedian - abs(0.4*(OLipXDistanceMedian - BaseLipXDistanceMedian));



% Eyebrow Raise detection
[BaseEyePointLeftX, BaseEyePointLeftY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexEyePointLeft);
[BaseEyePointRightX, BaseEyePointRightY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexEyePointRight);
[BaseEyebrowPointLeftX, BaseEyebrowPointLeftY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexEyebrowPointLeft);
[BaseEyebrowPointRightX, BaseEyebrowPointRightY] = getXYGivenZeroBaseIndex(BaseKeyPointsFace, IndexEyebrowPointRight);

[RaiseEyePointLeftX, RaiseEyePointLeftY] = getXYGivenZeroBaseIndex(EyebrowRaiseKeyPoints, IndexEyePointLeft);
[RaiseEyePointRightX, RaiseEyePointRightY] = getXYGivenZeroBaseIndex(EyebrowRaiseKeyPoints, IndexEyePointRight);
[RaiseEyebrowPointLeftX, RaiseEyebrowPointLeftY] = getXYGivenZeroBaseIndex(EyebrowRaiseKeyPoints, IndexEyebrowPointLeft);
[RaiseEyebrowPointRightX, RaiseEyebrowPointRightY] = getXYGivenZeroBaseIndex(EyebrowRaiseKeyPoints, IndexEyebrowPointRight);


BaseEyebrowLeftYDistanceMedian = median(BaseEyePointLeftY - BaseEyebrowPointLeftY);
RaiseEyebrowLeftYDistanceMedian = median(RaiseEyePointLeftY - RaiseEyebrowPointLeftY);

BaseEyebrowRightYDistanceMedian = median(BaseEyePointRightY - BaseEyebrowPointRightY);
RaiseEyebrowRightYDistanceMedian = median(RaiseEyePointRightY - RaiseEyebrowPointRightY);

ThresholdLeftEyebrowRaise = BaseEyebrowLeftYDistanceMedian + (0.4 * (RaiseEyebrowLeftYDistanceMedian - BaseEyebrowLeftYDistanceMedian));
ThresholdRightEyebrowRaise = BaseEyebrowRightYDistanceMedian + (0.4 * (RaiseEyebrowRightYDistanceMedian - BaseEyebrowRightYDistanceMedian));


% Right Turn Detection
[BaseEarLeftX, BaseEarLeftY] = getXYGivenZeroBaseIndex(BaseKeyPointsBody, IndexEarLeft);
[BaseEyeLeftX, BaseEyeLeftY] = getXYGivenZeroBaseIndex(BaseKeyPointsBody, IndexEyeLeft);

BaseEyeEarLeftXDistanceMedian = median(abs(BaseEyeLeftX - BaseEarLeftX));

[RightTurnEarLeftX, RightTurnEarLeftY] = getXYGivenZeroBaseIndex(RightTurnKeyPoints, IndexEarLeft);
[RightTurnEyeLeftX, RightTurnEyeLeftY] = getXYGivenZeroBaseIndex(RightTurnKeyPoints, IndexEyeLeft);

RightTurnEyeEarLeftXDistanceMedian = median(abs(RightTurnEyeLeftX - RightTurnEarLeftX));

ThresholdRightTurnLeftEarEyeDistance = BaseEyeEarLeftXDistanceMedian + (0.4 * abs(RightTurnEyeEarLeftXDistanceMedian - BaseEyeEarLeftXDistanceMedian));

% Left Turn Detection
[BaseEarRightX, BaseEarRightY] = getXYGivenZeroBaseIndex(BaseKeyPointsBody, IndexEarRight);
[BaseEyeRightX, BaseEyeRightY] = getXYGivenZeroBaseIndex(BaseKeyPointsBody, IndexEyeRight);

BaseEyeEarRightXDistanceMedian = median(abs(BaseEyeRightX - BaseEarRightX));

[LeftTurnEarRightX, LeftTurnEarRightY] = getXYGivenZeroBaseIndex(LeftTurnKeyPoints, IndexEarRight);
[LeftTurnEyeRightX, LeftTurnEyeRightY] = getXYGivenZeroBaseIndex(LeftTurnKeyPoints, IndexEyeRight);

LeftTurnEyeEarRightXDistanceMedian = median(abs(LeftTurnEyeRightX - LeftTurnEarRightX));

ThresholdLeftTurnRightEarEyeDistance = BaseEyeEarRightXDistanceMedian + (0.4 * abs(LeftTurnEyeEarRightXDistanceMedian - BaseEyeEarRightXDistanceMedian));





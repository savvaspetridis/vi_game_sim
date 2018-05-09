clear all;

result_dir = '/Users/ishan/Dropbox/Columbia/sem2/visual/project/data/results_data_katy/';
data_dir = '/Users/ishan/Dropbox/Columbia/sem2/visual/project/data/data_katy/';
PoseNumKeyPoints = 18;
FaceNumKeyPoints = 70;

IndexLipPointLeft = 54;
IndexLipPointRight = 48;

IndexLipPointTop = 51;
IndexLipPointBottom = 57;

IndexEyePointLeftTop = 44;
IndexEyePointLeftBottom = 46;

IndexEyebrowPointLeft = 24;
IndexEyebrowPointRight = 19;

IndexEyePointRightTop = 37;
IndexEyePointRightBottom = 41;


IndexEarRight = 16;
IndexEyeRight = 14;


IndexEarLeft = 17;
IndexEyeLeft = 15;


ThresholdSmile = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_smile.mov/', 'face', FaceNumKeyPoints, IndexLipPointLeft, IndexLipPointRight, 'X', 'elongate', 0.3);

% ThresholdO = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_o.mov/', 'face', FaceNumKeyPoints, IndexLipPointLeft, IndexLipPointRight, 'X', 'contract', 0.4, 1);
ThresholdO = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_o.mov/', 'face', FaceNumKeyPoints, IndexLipPointBottom, IndexLipPointTop, 'Y', 'elongate', 0.5);

ThresholdLeftEyebrowRaise = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_eyebrow.mov/', 'face', FaceNumKeyPoints, IndexEyePointLeftBottom, IndexEyebrowPointLeft, 'Y', 'elongate', 0.7);

ThresholdRightEyebrowRaise = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_eyebrow.mov/', 'face', FaceNumKeyPoints, IndexEyePointRightBottom, IndexEyebrowPointRight, 'Y', 'elongate', 0.7);

ThresholdRightTurnLeftEarEyeDistance = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_right.mov/', 'pose', PoseNumKeyPoints, IndexEarLeft, IndexEyeLeft, 'X', 'elongate');

ThresholdLeftTurnRightEarEyeDistance = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_left.mov/', 'pose', PoseNumKeyPoints, IndexEarRight, IndexEyeRight, 'X', 'elongate');

ThresholdLeftEyeBlink = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_left_eye.mov/', 'face', FaceNumKeyPoints, IndexEyePointLeftTop, IndexEyePointLeftBottom, 'Y', 'contract', 1, 0.9);

ThresholdRightEyeBlink = GetThresholdFromPoints(result_dir, 'base.mov/', 'base_right_eye.mov/', 'face', FaceNumKeyPoints, IndexEyePointRightTop, IndexEyePointRightBottom, 'Y', 'contract', 1, 0.9);



% TestVideo

% test_move_name = {'trial_1_face.mov/', 'trial_2_face.mov/', 'trial_3_reverse.mov/'};
test_move_name = {'katy_all_gestures.mov/', 'katy_path_1_try_1.mov/', 'katy_path_2.mov/'};
% test_move_name = {'katy_path_2.mov/'};

% test_move_name = {'test_1.mov/', 'test_2.mov/', 'test_3.mov/', 'test_4.mov/'};
% test_move_name = {'test_2.mov/', 'test_3.mov/', 'test_4.mov/'};
% test_move_name = {'test_path_1.mov/', 'test_path_2.mov/', 'test_path_3.mov/'};
% test_move_name = {'test_path_3.mov/'};



for move_num = 1 : size(test_move_name, 2)

    DistanceSmile = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexLipPointLeft, IndexLipPointRight, 'X');
    PresenceSmile = DistanceSmile >= ThresholdSmile;
    PresenceSmile = medfilt1(single(PresenceSmile))==1;


%     DistanceO = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexLipPointLeft, IndexLipPointRight, 'X');
%     PresenceO = DistanceO < ThresholdO;
%     PresenceO = medfilt1(single(PresenceO), 5)==1;
    
    DistanceO = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexLipPointBottom, IndexLipPointTop, 'Y');
    PresenceO = DistanceO >= ThresholdO;
    PresenceO = medfilt1(single(PresenceO), 3)==1;


    DistanceLeftEyebrowRaise = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexEyePointLeftTop, IndexEyebrowPointLeft, 'Y');
    PresenceLeftEyebrowRaise = DistanceLeftEyebrowRaise >= ThresholdLeftEyebrowRaise;
    PresenceLeftEyebrowRaise = medfilt1(single(PresenceLeftEyebrowRaise), 5)==1;

    DistanceRightEyebrowRaise = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexEyePointRightTop, IndexEyebrowPointRight, 'Y');
    PresenceRightEyebrowRaise = DistanceRightEyebrowRaise >= ThresholdRightEyebrowRaise;
    PresenceRightEyebrowRaise = medfilt1(single(PresenceRightEyebrowRaise), 5)==1;

    DistanceRightTurnLeftEarEyeDistance = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'pose', PoseNumKeyPoints, IndexEarLeft, IndexEyeLeft, 'X');
    PresenceRightTurn = DistanceRightTurnLeftEarEyeDistance >= ThresholdRightTurnLeftEarEyeDistance;
    PresenceRightTurn = medfilt1(single(PresenceRightTurn), 5)==1;


    DistanceLeftTurnRightEarEyeDistance = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'pose', PoseNumKeyPoints, IndexEarRight, IndexEyeRight, 'X');
    PresenceLeftTurn = DistanceLeftTurnRightEarEyeDistance >= ThresholdLeftTurnRightEarEyeDistance;
    PresenceLeftTurn = medfilt1(single(PresenceLeftTurn), 5)==1;


    DistanceLeftEyeBlink = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexEyePointLeftTop, IndexEyePointLeftBottom, 'Y');
    PresenceLeftEyeBlink = DistanceLeftEyeBlink < ThresholdLeftEyeBlink;
    PresenceLeftEyeBlink = medfilt1(single(PresenceLeftEyeBlink), 3)==1;


    DistanceRightEyeBlink = GetDistanceBWPoints(result_dir, test_move_name{move_num}, 'face', FaceNumKeyPoints, IndexEyePointRightTop, IndexEyePointRightBottom, 'Y');
    PresenceRightEyeBlink = DistanceRightEyeBlink < ThresholdRightEyeBlink;
    PresenceRightEyeBlink = medfilt1(single(PresenceRightEyeBlink), 3)==1;

    PresenceEyebrowRaise = PresenceLeftEyebrowRaise & PresenceRightEyebrowRaise;
    PresenceEyebrowRaiseMedian = medfilt1(single(PresenceEyebrowRaise), 5);

    % Gather Frame Captions
    Captions = {};
    for i = 1 : size(PresenceSmile, 1)
        str = '';
        if PresenceSmile(i,:) 
            str = [str 'Smile, '];
        end

        if PresenceO(i,:) 
            str = [str 'O Mouth, '];
        end

        if PresenceLeftEyebrowRaise(i,:) && PresenceRightEyebrowRaise(i,:)
            str = [str 'EyebrowRaise, '];
        end

        if PresenceRightTurn(i,:) 
            str = [str 'Right Head Turn, '];
        end

        if PresenceLeftTurn(i,:) 
            str = [str 'Left Head Turn, '];
        end

        if PresenceLeftEyeBlink(i,:) 
            str = [str 'Left Eye Blink, '];
        end

        if PresenceRightEyeBlink(i,:) 
            str = [str 'Right Eye Blink, '];
        end

        Captions{i} = str;
    end

    PresenceMatrix = [PresenceSmile PresenceO PresenceEyebrowRaise PresenceRightTurn PresenceLeftTurn PresenceLeftEyeBlink PresenceRightEyeBlink];
    

    mkdir([data_dir test_move_name{move_num}(1:end-1) '_output/']);
    dest_path = [data_dir test_move_name{move_num}(1:end-1) '_output/'];
    dlmwrite([dest_path 'presence.txt'], PresenceMatrix);


    % Print Video Frames, and write video
    vid_path = [data_dir test_move_name{move_num}];
    
    v = VideoReader(vid_path(1:end-1), 'FrameRate');

    writerObj = VideoWriter([dest_path 'out.avi']);
    writerObj.FrameRate = v.FrameRate;
    open(writerObj);
   
    frame_num = 1;

    while(hasFrame(v))

        disp(['print frame ' num2str(frame_num)]);

        frame = readFrame(v);

        RGB = insertText(frame,[0 0],Captions{frame_num}, 'FontSize',24);

        imwrite(RGB,[dest_path 'Frame_' int2str(frame_num) '.jpg']);

    %     write_frame = im2frame(RGB);
        writeVideo(writerObj, RGB);

        frame_num = frame_num + 1;
    end

    close(writerObj);
    
end

  

% Process Json to Matlab mat file
frameNumIndexInName = 5;
numKeyPoints = 18;
saveBodyKeyPointsAsMat(bodyKeyPointDataSavePath, processed_vid_dir, frameNumIndexInName, numKeyPoints);

% Save Videos as individual frames
saveAllVidFrames(processed_vid_dir);
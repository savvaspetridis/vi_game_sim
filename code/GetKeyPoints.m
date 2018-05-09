function KeyPoints = GetKeyPoints(processed_vid_dir, numKeyPoints, type),


    KeyPoints = ReadJsonFiles(processed_vid_dir, numKeyPoints, type);
    
end
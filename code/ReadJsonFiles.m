function bodyKeyPoints = ReadJsonFiles(JsonFilesDir, numKeyPoints, type),

    addpath('../importPackages/jsonlab-1.5');
    
    JsonFiles=dir(strcat(JsonFilesDir, '*.json'));
    numFiles = length(JsonFiles);
    
    %x,y cordinate and confidence, thus *3.
    bodyKeyPoints = zeros(numFiles, numKeyPoints *3);
    
    for i = 1 : numFiles
        
        
        currentFileName = JsonFiles(i).name;
        currentFileNameSplit = strsplit(currentFileName, '_');
        
        frameIndex = str2num(currentFileNameSplit{size(currentFileNameSplit, 2) -1});
        

                       
        JsonObject = loadjson(strcat(JsonFilesDir, currentFileName));
        

        person_index = findPersonIndex(JsonObject);
        
        if(person_index == -1)
            continue;
        end
        
        
        %+1 since frameIndex starts from 0;
        if strcmp(type, 'face')
            bodyKeyPoints(frameIndex + 1, :) = cell2mat(JsonObject.people{person_index}.face_keypoints);
        elseif strcmp(type, 'pose')
            bodyKeyPoints(frameIndex + 1, :) = cell2mat(JsonObject.people{person_index}.pose_keypoints);

        end
       
    end 
    
    zero_index = ~bodyKeyPoints;
    bodyKeyPoints(zero_index) = NaN;
    
end

function index = findPersonIndex(JsonObject),
    index = 1;
    if(length(JsonObject) <= 0 || length(JsonObject.people) <= 0)
        index = -1;
        return;
    end
    
end
function Distance = GetDistanceBWPoints(ResultDir, Vid, VidType, NumKeyPoints, IndexKeyPoint1, IndexKeyPoint2, Direction)

    KeyPoints1 = GetKeyPoints([ResultDir Vid], NumKeyPoints, VidType);
    [KeyPoints1X, KeyPoints1Y] = getXYGivenZeroBaseIndex(KeyPoints1, IndexKeyPoint1);
    
    KeyPoints2 = GetKeyPoints([ResultDir Vid], NumKeyPoints, VidType);
    [KeyPoints2X, KeyPoints2Y] = getXYGivenZeroBaseIndex(KeyPoints2, IndexKeyPoint2);
    
    
    if strcmp(Direction, 'X')
        Distance = abs(KeyPoints1X - KeyPoints2X);
    elseif strcmp(Direction, 'Y')
        Distance = abs(KeyPoints1Y - KeyPoints2Y);
    end
    
    
end
function Threshold = GetThresholdFromPoints(ResultDir, Vid1, Vid2, VidType, NumKeyPoints, IndexKeyPoint1, IndexKeyPoint2, Direction, GestureType, ElongateThreshold, ContractThreshold)

    if ~ (1 == exist('ElongateThreshold', 'var'))
        ElongateThreshold = 0.4;
    end

    if ~ (1 == exist('ContractThreshold', 'var'))
        ContractThreshold = 0.75;
    end
    
    DistanceVid1 = GetDistanceBWPoints(ResultDir, Vid1, VidType, NumKeyPoints, IndexKeyPoint1, IndexKeyPoint2, Direction);
    DistanceVid1Median = median(DistanceVid1);
    
    DistanceVid2 = GetDistanceBWPoints(ResultDir, Vid2, VidType, NumKeyPoints, IndexKeyPoint1, IndexKeyPoint2, Direction);
    DistanceVid2Median = median(DistanceVid2);
    
    
    if strcmp(GestureType, 'elongate')
        Threshold = DistanceVid1Median + abs(( ElongateThreshold *(DistanceVid2Median - DistanceVid1Median)));
        
    elseif strcmp(GestureType, 'contract')
        Threshold = DistanceVid1Median - abs( ContractThreshold *(DistanceVid2Median - DistanceVid1Median));
    end
    
end
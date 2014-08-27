classdef classification
    %CLASSIFICATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        EDGES_KNEE = [0.0050 0.0086 0.0133 0.0232 0.0374 0.1200];
        
        AVERAGE_MOVEMENT_VECTOR_LENGTH = 12;
        AVERAGE_TRUNK_FEATURE_VECTOR_LENGTH = 5;
        AVERAGE_UPPER_FEATURE_VECTOR_LENGTH = 3;
        AVERAGE_LOWER_FEATURE_VECTOR_LENGTH = 4;
        AVERAGE_LOWER_FEATURE_VECTOR_LENGTH_WITH_FOOT = 6;
        
        BOW_NUM_OF_JOINTS = 7;
        BOW_NUM_OF_WORDS = 21;
    end
    
    methods
    end
    
end


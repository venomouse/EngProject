classdef bodyPartEnum
    %BODYPARTENUM Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        NUMOFLIMBS = 5;
        NUMOFJOINTS = 20;
        
        HEAD = 1;
        RIGHTHAND = 2;
        LEFTHAND = 3;
        RIGHTLEG = 4;
        LEFTLEG = 5;
        
        DIM_HEAD = 3;
        DIM_REST = 4;
        
        SUBSPACE_DIST = 0;
        PHASESPACE_DIST = 1;
    end
    
    methods
    end
    
end


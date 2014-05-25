classdef Patient

    properties(Constant)
        AIMS_UPPER = 1;
        AIMS_LOWER = 2;
        AIMS_TRUNK = 3;
        AIMS_OVERALL = 4;
        SIT = 1;
        STAND = 0;
    end
    properties
        label; 
        sitNotStand;
        movement;
        aims;
        fileName;
    end
    
    methods
        function P = Patient(label, sitNotStand, movement, aims, fileName)
            P.label = label;
            P.sitNotStand = sitNotStand;
            P.movement = movement;
            P.aims = aims;
            P.fileName = fileName;
        end
    end
    
end


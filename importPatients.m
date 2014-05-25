
standingFSClipMap = containers.Map();
 
data = [UpperHalfGrade, LowerHalfGrade, TrunkGrade, OverallGrade ];

for i = 1:length(Clipname)
    p = Patient(Clipname{i}, 0, 'fh', data(i,:), DataFileName{i});
    standingFSClipMap(Clipname{i}) = p;
end
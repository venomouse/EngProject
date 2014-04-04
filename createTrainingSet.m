clear all
load 13_3_2014_patient6_beforeMed
vars = who;
trainLength = 400;

for i =1:length(vars)
    data = eval(vars{i});
    if (size(data,1) < trainLength)
        eval(['clearvars ' vars{i}] );
    else
        if (size(data,1) - trainLength > trainLength)
            eval([vars{i} ' = ' vars{i} '(' num2str(trainLength) ':end,:);']);
        else
            eval([vars{i} ' = ' vars{i} '( end - ' num2str(trainLength) ':end,:);']);
        end
    end
end
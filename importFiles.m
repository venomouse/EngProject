dirfiles = dir;

for file = dirfiles'
    if (~file.isdir && strcmp (file.name(end-2:end), 'txt') && isempty(strfind(file.name, 'comments')) && isempty(strfind(file.name,'imageSkel')))
        meas = importdata (file.name);
        eval ([file.name(1:end - 4) ' = meas;']); 
      %  eval ([file.name(1:end - 4) ' = ' file.name(1:end - 4) '(:,2:end);' ]); 
    end
end 

clear file;
clear meas;
clear dirfiles;

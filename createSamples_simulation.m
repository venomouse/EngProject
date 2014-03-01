z_datavars = who;
sampleLength = 250;

for z = 1:length(z_datavars)
   data = eval(z_datavars{z});
   eval([z_datavars{z} '=' z_datavars{z} '(1:' num2str(sampleLength) ', :);']);
   if (z ==1)
       save('18_2_2014_samples.mat', z_datavars{z});
   else
       save('18_2_2014_samples.mat', z_datavars{z}, '-append');
   end
end
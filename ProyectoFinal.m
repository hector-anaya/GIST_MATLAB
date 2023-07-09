myFolder = 'D:\Masters\dataset256x256_color_OG\4\'
filePattern = fullfile(myFolder, '*.png');
jpegFiles = dir(filePattern);
 
%%
Nimages=length(jpegFiles)
%%
label=zeros([700 1])+4;
%%
% GIST Parameters:
clear param
param.imageSize = [256 256]; % set a normalized image size
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 32;
param.fc_prefilt = 4;

% Pre-allocate gist:
Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
gist4 = zeros([Nimages Nfeatures]);

% Load first image and compute gist:
baseFileName = jpegFiles(1).name;
fullFileName = fullfile(myFolder, baseFileName);
img = imread(fullFileName);
[gist4(1, :), param] = LMgist(img, '', param); % first call
% Loop:
for i = 2:Nimages
   baseFileName = jpegFiles(i).name;
   fullFileName = fullfile(myFolder, baseFileName);
   img = imread(fullFileName);
   gist4(i, :) = LMgist(img, '', param); % the next calls will be faster
end

%%
gist4 = [gist4 label];
%%
gist=vertcat(gist,gist4);
%%
csvwrite('GIST_32_2.csv' ,gist) 
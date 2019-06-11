function [trialSpecification] = setUpRandomizationSingleImages(numImages)
% numImages : indicates the number of images for each side
% trialSpecification : a 2*numImages x 2 matrix that specifies the concrete trial setup used. 
% first column codes whether left or right image is displayed; 
% second column codes number of image on left side; 
% third column codes number of image on the right;

presentationSide = Shuffle(repmat([0; 1], numImages, 1));
leftImIndices = zeros(numImages*2,1);
rightImIndices = zeros(numImages*2,1);

leftImIndices(presentationSide==0) = Shuffle(1:numImages);
rightImIndices(presentationSide==1) = Shuffle(1:numImages);

trialSpecification = [presentationSide leftImIndices rightImIndices];
end


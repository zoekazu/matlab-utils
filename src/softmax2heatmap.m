function [output] = softmax2heatmap(input)

[h,w,] = size(input);
output = ones(h,w,3);
output(:,:,1) = (1-input).*(2/3);
output = hsv2rgb(output);

end

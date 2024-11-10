function wavelet_reverse()

base_dir = 'xxx';

folder_name = 'wavelet_reverse';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end


im_w2 = imread('xxx.bmp');
[h,w,ch] = size(im_w2);
im_w2(1:h/4,1:w/4,:) = 0;

im_w1 = imread('xxx.bmp');

im_w1(1:h,1:w,:) = im_w2;
im_w1(h:h+2,1:w,:) = 0;

name = sprintf('%s/%s/reverse.bmp', base_dir, folder_name);
imwrite(im_w1, name);
end

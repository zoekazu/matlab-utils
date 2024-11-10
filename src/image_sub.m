function image_sub()

im_base_path_im = 'xxx.bmp';
im_sub_path_im = 'xxx.bmp';


base_dir = 'xxx';

folder_name = 'crop';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end
im_base = imbinarize(imread(im_base_path_im));
im_sub = imread(im_sub_path_im);

im = im_base+im_sub;

image_name = ('subimage');

name = sprintf('%s/%s/%s_crop.bmp', base_dir, folder_name, image_name);
imwrite(im, name);

end

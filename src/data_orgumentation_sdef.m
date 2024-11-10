function data_orgumentation_sdef()

base_dir = 'xxx';

imgFileLocation_im = sprintf('%s/',base_dir);
imgFileList_im = dir(sprintf('%s/*.bmp',base_dir));

imgNum_im = size(imgFileList_im);
imgFileNameList_im = cell(imgNum_im);


for i = 1 : imgNum_im(1)
    imgFileName_im = char(imgFileList_im(i).name);
    imgFileNameList_im{i} = sprintf('%s%s', imgFileLocation_im, imgFileName_im);
end

for data = 1:length(imgFileNameList_im)

    img_path_im = char(imgFileNameList_im(data));
    im  = imread(img_path_im);


    image_name = strrep(img_path_im, imgFileLocation_im, '');
    image_name = strrep(image_name, '.bmp', '');

    name = sprintf('%s/%s_base.bmp', base_dir, image_name);
    imwrite(im, name);
end
end

function bicubic_RGB()

up_scale = 0.5;

imgFileLocation = 'xxx/';
imgFileList = dir('xxx/*.bmp');

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);
for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end;

base_dir = 'xxx';

folder_name = 'x2';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end


for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im_y  = imread(img_path);

    im_y = imresize(im_y, up_scale, 'bicubic');


    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    y_name = sprintf('%s/%s/%s_x2.bmp', base_dir, folder_name, image_name);
    imwrite(im_y, y_name);
end

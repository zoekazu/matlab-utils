function label_pull()

imgFileLocation = 'xxx/';
imgFileList = dir('xxx/*.bmp');
imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

base_dir = 'xxx/';

folder_name = 'label_only';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im = imread(img_path);

    im_label = imcomplement(im(:,:,1) ==255);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    y_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name, image_name);

    imwrite(im_label, y_name);
end
end

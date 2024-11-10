function RGB_to_binary()

imgFileLocation = 'xxx/';
imgFileList = dir('xxx/*.bmp');

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

base_dir = 'xxx';

folder_name = 'binary';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im_y  = imread(img_path);
    im_y_r = im_y(:,:,1);
    im_y_g = im_y(:,:,2);
    im_y_b = im_y(:,:,3);

    im_binary = ones(size(im_y_r));
    for i = 1:numel(im_y_r)
        if (im_y_r(i) ~=255) || (im_y_g(i) ~=255) || (im_y_b(i) ~=255)
            im_binary(i) = 0;
        end
    end

    im_binary = imbinarize(im_binary);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    y_name = sprintf('%s/%s/%s_truth.bmp', base_dir, folder_name, image_name);
    imwrite(im_binary, y_name);
end

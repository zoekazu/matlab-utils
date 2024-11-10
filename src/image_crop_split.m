function image_crop_split()

base_dir = 'xxxx';

imgFileLocation_im = sprintf('%s/',base_dir);
imgFileList_im = dir(sprintf('%s/*.bmp',base_dir));

imgNum_im = size(imgFileList_im);
imgFileNameList_im = cell(imgNum_im);


for i = 1 : imgNum_im(1)
    imgFileName_im = char(imgFileList_im(i).name);
    imgFileNameList_im{i} = sprintf('%s%s', imgFileLocation_im, imgFileName_im);
end

folder_name = 'crop';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end

for data = 1:length(imgFileNameList_im)

    img_path_im = char(imgFileNameList_im(data));
    im  = imread(img_path_im);

    [h ,w] = size(im(:,:,1));
    im_v1 = im(:,1:w/4,:);
    im_v2 = im(:,w/4+1:w*2/4,:);
    im_v3 = im(:,w*2/4+1:w*3/4,:);
    im_v4 = im(:,w*3/4+1:w,:);

    image_name = strrep(img_path_im, imgFileLocation_im, '');
    image_name = strrep(image_name, '.bmp', '');

    name_v1 = sprintf('%s/%s/%s_v1.bmp', base_dir, folder_name, image_name);
    imwrite(im_v1, name_v1);
    name_v2 = sprintf('%s/%s/%s_v2.bmp', base_dir, folder_name, image_name);
    imwrite(im_v2, name_v2);
    name_v3 = sprintf('%s/%s/%s_v3.bmp', base_dir, folder_name, image_name);
    imwrite(im_v3, name_v3);
    name_v4 = sprintf('%s/%s/%s_v4.bmp', base_dir, folder_name, image_name);
    imwrite(im_v4, name_v4);
end
end

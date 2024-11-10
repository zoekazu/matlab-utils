function blend_teach_from_ori()

blend_teach_main(1)

end
function blend_teach_main(where)

imgFileLocation = 'xxx/';
imgFileList = dir('xxx/*.bmp');
imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

imgFileLocation_teach = 'xxx_teach/';
imgFileList_teach = dir('xxx_teach/*.bmp');
imgNum_teach = size(imgFileList_teach);
imgFileNameList_teach = cell(imgNum_teach);

imgFileLocation_ori = 'xxx/';
imgFileList_ori = dir('xxx/*.bmp');
imgNum_ori = size(imgFileList_ori);
imgFileNameList_ori = cell(imgNum_ori);

imgFileLocation_denoise = 'xxx/';
imgFileList_denoise = dir('xxx/*.bmp');
imgNum_denoise = size(imgFileList_denoise);
imgFileNameList_denoise = cell(imgNum_denoise);


for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

for i = 1 : imgNum_teach(1)
    imgFileName_teach = char(imgFileList_teach(i).name);
    imgFileNameList_teach{i} = sprintf('%s%s', imgFileLocation_teach, imgFileName_teach);
end

for i = 1 : imgNum_ori(1)
    imgFileName_ori = char(imgFileList_ori(i).name);
    imgFileNameList_ori{i} = sprintf('%s%s', imgFileLocation_ori, imgFileName_ori);
end

for i = 1 : imgNum_denoise(1)
    imgFileName_denoise = char(imgFileList_denoise(i).name);
    imgFileNameList_denoise{i} = sprintf('%s%s', imgFileLocation_denoise, imgFileName_denoise);
end

base_dir = 'xxx/';

folder_name_seg_teach = 'Segmentaion_teach';
folder_name_teach_ori = 'teach_ori';
folder_name_seg = 'Segmentaion_image';
folder_name = 'Train_image';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end
if ~exist(sprintf('%s/%s', base_dir, folder_name_seg), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_seg));
end
if ~exist(sprintf('%s/%s', base_dir, folder_name_teach_ori), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_teach_ori));
end
if ~exist(sprintf('%s/%s', base_dir, folder_name_seg_teach), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_seg_teach));
end

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im = imread(img_path);

    img_path_teach = char(imgFileNameList_teach(data));
    im_teach = imread(img_path_teach);

    img_path_ori = char(imgFileNameList_ori(fix((data-1)/5)+1));
    im_ori  = imread(img_path_ori);

    img_path_denoise = char(imgFileNameList_denoise(data));
    im_denoise  = imread(img_path_denoise);

    im_seg = segmentImage(im_ori);

     for j = 1:numel(im)
        if im_seg(j) == 1
            im(j) = im_denoise(j);
        end
     end

    im_teach_ori = im_teach;
    im_number = 0;
    if where == 1
        for k = 1:numel(im)
            if im_seg(k) == 1
                im_teach(k) = 255;
            end
            if im_teach(k) ~=255
               im_teach(k) = 0;
               im_number = im_number +1;
            end
            if im_teach_ori(k) ~=255
                im_teach_ori(k) = 0;
            end
        end
    end


    if where ~= 1
        for k = 1:numel(im)
            if im_teach(k) ~= 255
                im(k) = im(k) - 0.06*im_teach(k) ;% + 0.01*noise_ga;
            end
        end
    end

    [h w] = size(im);

    im = im(h*3/8+1:h,w/4+1:w*3/4);
    im_seg = im_seg(h*3/8+1:h,w/4+1:w*3/4);
    im_teach = im_teach(h*3/8+1:h,w/4+1:w*3/4);
    im_teach_ori = im_teach_ori(h*3/8+1:h,w/4+1:w*3/4);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    seg_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name_seg, image_name);
    y_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name, image_name);
    seg_teach_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name_seg_teach, image_name);
    teach_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name_teach_ori, image_name);
    imwrite(im_seg, seg_name);
    imwrite(im_teach,  seg_teach_name);
    imwrite(im, y_name);
    imwrite(im_teach_ori, teach_name);
end
end

function [BW,maskedImage] = segmentImage(X)
%segmentImage Segment image using auto-generated code from imageSegmenter App
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter App. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 18-May-2018
%----------------------------------------------------


% Create empty mask.
BW = false(size(X,1),size(X,2));

BW = X > 190;

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end
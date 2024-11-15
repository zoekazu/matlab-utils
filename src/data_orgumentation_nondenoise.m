function data_orgumentation_nondenoise()

blend_teach_main(1)

end
function blend_teach_main(where)

imgFileLocation_ori = 'xxx/';
imgFileList_ori = dir('xxx/*.bmp');
imgNum_ori = size(imgFileList_ori);
imgFileNameList_ori = cell(imgNum_ori);

for i = 1 : imgNum_ori(1)
    imgFileName_ori = char(imgFileList_ori(i).name);
    imgFileNameList_ori{i} = sprintf('%s%s', imgFileLocation_ori, imgFileName_ori);
end

base_dir = 'xxx';

folder_name_seg = 'Segmentaion_image';
folder_name_org = 'orgumentation_image';


if ~exist(sprintf('%s/%s', base_dir, folder_name_org), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_org));
end

if ~exist(sprintf('%s/%s', base_dir, folder_name_seg), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_seg));
end

for data = 1:length(imgFileNameList_ori)

    img_path_ori = char(imgFileNameList_ori(data));
    im_ori  = imread(img_path_ori);

    im_ori = medfilt2(im_ori);

    im_m05 = im_ori;
    im_p05 = im_ori;
    im_m10 = im_ori;
    im_p10 = im_ori;

    im_seg = segmentImage(im_ori);

     for j = 1:numel(im_ori)
        if im_seg(j) == 0
            im_m05(j) = im_ori(j) -5;
            im_p05(j) = im_ori(j) +5;
            im_m10(j) = im_ori(j) -10;
            im_p10(j) = im_ori(j) +10;
        end
     end


    image_name = strrep(img_path_ori, imgFileLocation_ori, '');
    image_name = strrep(image_name, '.bmp', '');

    seg_name = sprintf('%s/%s/%s_seg.bmp', base_dir, folder_name_seg, image_name);
    ori_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name_org, image_name);
    p05_name = sprintf('%s/%s/%s_p05.bmp', base_dir, folder_name_org, image_name);
    m05_name = sprintf('%s/%s/%s_m05.bmp', base_dir, folder_name_org, image_name);
    p10_name = sprintf('%s/%s/%s_p10.bmp', base_dir, folder_name_org, image_name);
    m10_name = sprintf('%s/%s/%s_m10.bmp', base_dir, folder_name_org, image_name);
    imwrite(im_seg, seg_name);
    imwrite(im_ori, ori_name);
    imwrite(im_p05, p05_name);
    imwrite(im_m05, m05_name);
    imwrite(im_p10, p10_name);
    imwrite(im_m10, m10_name);
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
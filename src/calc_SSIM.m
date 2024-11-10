shrink = 4;


imgFileLocation = 'xxx';
imgFileList = dir('xxx/*.bmp');

refImgFileLocation = 'xxx';
refImgFileList = dir('xxx/*.bmp');

save_dir = 'xxx\_ssim';

if ~exist(sprintf('%s', save_dir), 'dir')
    mkdir(sprintf('%s', save_dir));
end

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);
for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s/%s', imgFileLocation, imgFileName);
end;

refImgNum = size(refImgFileList);
refImgFileNameList = cell(refImgNum);
for i = 1 : refImgNum(1)
    refImgFileName = char(refImgFileList(i).name);
    refImgFileNameList{i} = sprintf('%s/%s', refImgFileLocation, refImgFileName);
end;

ssim_file = sprintf('%s/ssim.txt', save_dir);
ssim_fid = fopen(ssim_file, 'wt');

ave_ssim = 0;

for data = 1:length(imgFileNameList)
    img_path = char(imgFileNameList(data));
    im  = imread(img_path);
    if size(im,3) > 1
        im = rgb2ycbcr(im);
        im = im(:,:,1);
    end
    im = shave(im, [shrink shrink]);

    im = single(im)/255;

    ref_img_path = char(refImgFileNameList(data));
    im_ref = imread(ref_img_path);
    if size(im_ref,3) > 1
        im_ref = rgb2ycbcr(im_ref);
        im_ref = im_ref(:,:,1);
    end
    im_ref = shave(im_ref, [shrink shrink]);

    im_ref = single(im_ref)/255;

    if  numel(im) ~= numel(im_ref)
        ref_size = size(im_ref);
        im = imresize(im, ref_size);
    end

    ssim_matlab = ssim(im, im_ref);
    ave_ssim = ave_ssim + ssim_matlab;
    fprintf(ssim_fid, '%.3f\n', ssim_matlab);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    name = sprintf('%s/%s.bmp', save_dir, image_name);
    imwrite(uint8(im*255), name);
end
ave_ssim = ave_ssim / length(imgFileNameList);
fprintf(ssim_fid, '%.3f\n', ave_ssim);
fclose(ssim_fid);

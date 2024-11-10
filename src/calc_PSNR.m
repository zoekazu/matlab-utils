shrink = 0;


imgFileLocation = 'xxx';
imgFileList = dir('xxx/*.bmp');

refImgFileLocation = 'xxx';
refImgFileList = dir('xxx/*.bmp');

save_dir = '';

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

psnr_file = sprintf('%s/psnr.txt', save_dir);
psnr_fid = fopen(psnr_file, 'wt');

ave_psnr = 0;

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

    psnr_matlab = psnr(im, im_ref, 1);
    ave_psnr = ave_psnr + psnr_matlab;
    fprintf(psnr_fid, '%.3f\n', psnr_matlab);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    name = sprintf('%s/%s.bmp', save_dir, image_name);
    imwrite(uint8(im*255), name);
end
ave_psnr = ave_psnr / length(imgFileNameList);
fprintf(psnr_fid, '%.3f\n', ave_psnr);
fclose(psnr_fid);

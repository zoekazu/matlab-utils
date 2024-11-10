function calc_psnr_1tomany()

base_dir = '';
ref_path = sprintf('%s/truth.bmp',base_dir);

imgFileLocation_im = sprintf('%s/',base_dir);
imgFileList_im = dir(sprintf('%s/*.bmp',base_dir));

imgNum_im = size(imgFileList_im);
imgFileNameList_im = cell(imgNum_im);


for i = 1 : imgNum_im(1)
    imgFileName_im = char(imgFileList_im(i).name);
    imgFileNameList_im{i} = sprintf('%s%s', imgFileLocation_im, imgFileName_im);
end



psnr_file = sprintf('%s/psnr.txt', base_dir);
psnr_fid = fopen(psnr_file, 'wt');


for data = 1:length(imgFileNameList_im)

    img_path_im = char(imgFileNameList_im(data));
    im  = imread(img_path_im);
    im_ref = imread(ref_path);

    image_name = strrep(img_path_im, imgFileLocation_im, '');
    image_name = strrep(image_name, '.bmp', '');

    im = single(im)/255;
    im_ref = single(im_ref)/255;

    psnr_matlab = psnr(im, im_ref, 1);
    ssim_matlab = ssim(im, im_ref);
    fprintf(psnr_fid, '%s\n%.3f\n%.5f\n', image_name,psnr_matlab,ssim_matlab);

end
fclose(psnr_fid);
end

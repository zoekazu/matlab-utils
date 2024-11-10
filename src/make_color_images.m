function make_color_images(method, target, mag, up_scale)

imgFileLocation = sprintf('xxx/%s/%s/', mag, method, target);
imgDir = sprintf('xxx/%s/%s/*.bmp', mag, method, target);


imgFileList = dir(imgDir);

refFileLocation = sprintf('xxx/', mag, target);
refDir = sprintf('xxx/*.bmp', mag, target);
refFileList = dir(refDir);

out_dir = sprintf('xxx/%s/%s_color', mag, method, target);

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);
for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end;

refNum = size(imgFileList);
refFileNameList = cell(refNum);
for i = 1 : refNum(1)
    refFileName = char(refFileList(i).name);
    refFileNameList{i} = sprintf('%s%s', refFileLocation, refFileName);
end;

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im_sr  = imread(img_path);

    ref_path = char(refFileNameList(data));
    im = imread(ref_path);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');
    name = sprintf('%s/%s.bmp', out_dir, image_name);

    if size(im,3)>1
        im_ycbcr = rgb2ycbcr(im);
        im_cb = im_ycbcr(:, :, 2);
        im_cr = im_ycbcr(:, :, 3);

        im_l_cb = imresize(im_cb, 1/up_scale, 'bicubic');
        im_l_cr = imresize(im_cr, 1/up_scale, 'bicubic');

        im_h_cb = imresize(im_l_cb, up_scale, 'bicubic');
        im_h_cr = imresize(im_l_cr, up_scale, 'bicubic');

        im_color = cat(3, im_sr, im_h_cb, im_h_cr);
        im_color = ycbcr2rgb(im_color);

        imwrite(im_color, name);
    else
        imwrite(im_sr, name);
    end
end
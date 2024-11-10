function calc_f_value()
imgFileLocation = '';
imgFileList = dir('');

refImgFileLocation = '';
refImgFileList = dir('');

save_dir = '';

if ~exist(sprintf('%s', save_dir), 'dir')
    mkdir(sprintf('%s', save_dir));
end
if ~exist(sprintf('%s/true', save_dir), 'dir')
    mkdir(sprintf('%s/true', save_dir));
    mkdir(sprintf('%s/false', save_dir));
    mkdir(sprintf('%s/def', save_dir));

end

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);
for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s/%s', imgFileLocation, imgFileName);
end

refImgNum = size(refImgFileList);
refImgFileNameList = cell(refImgNum);
for i = 1 : refImgNum(1)
    refImgFileName = char(refImgFileList(i).name);
    refImgFileNameList{i} = sprintf('%s/%s', refImgFileLocation, refImgFileName);
end


comp_rate_file = sprintf('%s/comp_rate.txt', save_dir);
comp_rate_fid = fopen(comp_rate_file, 'wt');
repr_rate_file = sprintf('%s/repr_rate.txt', save_dir);
repr_rate_fid = fopen(repr_rate_file, 'wt');
f_value_file = sprintf('%s/f_value.txt', save_dir);
f_value_fid = fopen(f_value_file, 'wt');

ave_comp_rate = 0;
ave_repr_rate = 0;
ave_f_value = 0;

for data = 1:length(imgFileNameList)
    img_path = char(imgFileNameList(data));
    im  = imread(img_path);
    if size(im,3)>1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end
    if islogical(im)==0
        for h = 1:numel(im)
            if im(h) >= 128
                im(h) = 1;
            else
                im(h) = 0;
            end
        end
        im = imbinarize(im);
    end

    ref_img_path = char(refImgFileNameList(data));
    im_ref = imread(ref_img_path);

    [comp_rate, repr_rate, f_value,im_true,im_false,im_def] = run_f_value(im,im_ref);
    ave_comp_rate = ave_comp_rate + comp_rate;
    ave_repr_rate = ave_repr_rate + repr_rate;
    ave_f_value = ave_f_value + f_value;
    fprintf(comp_rate_fid, '%.3f\n', comp_rate);
    fprintf(repr_rate_fid, '%.3f\n', repr_rate);
    fprintf(f_value_fid, '%.3f\n', f_value);

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    name_true = sprintf('%s/true%s_true.bmp', save_dir, image_name);
    name_false = sprintf('%s/false%s_false.bmp', save_dir, image_name);
    name_def = sprintf('%s/def%s_def.bmp', save_dir, image_name);
    imwrite(im_true, name_true);
    imwrite(im_false, name_false);
    imwrite(im_def, name_def);
end
ave_comp_rate = ave_comp_rate / length(imgFileNameList);
ave_repr_rate = ave_repr_rate / length(imgFileNameList);
ave_f_value = ave_f_value / length(imgFileNameList);
fprintf(comp_rate_fid, '%.3f\n', ave_comp_rate);
fprintf(repr_rate_fid, '%.3f\n', ave_repr_rate);
fprintf(f_value_fid, '%.3f\n', ave_f_value);
fclose(comp_rate_fid);
fclose(repr_rate_fid);
fclose(f_value_fid);

end
function [comp_rate, repr_rate, f_value, im_true,im_false,im_def] = run_f_value(img, ref)

if size(img) ~= size(ref)
    pause
end

[hei,wid] = size(img);
im_true = ones(size(img));
im_false = ones(size(img));
im_def = ones(size(img));

mole_coun = 0;
repr_deno = 0;
comp_deno = 0;

for i = 2:1:hei-1
    for j = 2:1:wid-1
        if img(i,j) == 0
           comp_deno = comp_deno+1;
            if all(ref(i-1:i+1,j-1:j+1)) == 0
                mole_coun = mole_coun + 1;
            else
                im_false(i,j) = 0;
            end
        end
        if ref(i,j) == 0
            if all(img(i-1:i+1,j-1:j+1)) == 0
                repr_deno = repr_deno + 1;
                im_true(i,j) = 0;
            else
                im_def(i,j) = 0;
            end
        end

    end

end

comp_rate = (mole_coun / comp_deno)*100;
repr_rate = (mole_coun / repr_deno)*100;
f_value = (2 * comp_rate * repr_rate)/(comp_rate + repr_rate);

im_true = imbinarize(im_true);
im_false = imbinarize(im_false);
im_def = imbinarize(im_def);
end
function fft()

base_dir = '';

imgFileLocation = sprintf('%s/',base_dir);
imgFileList = dir(sprintf('%s/*.bmp',base_dir));imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end


folder_name = 'xxx';
folder_name_lowpass = 'xxx_lowpass';
folder_name_highpass = 'xxx_highpass';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end

if ~exist(sprintf('%s/%s', base_dir, folder_name_lowpass), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_lowpass));
end

if ~exist(sprintf('%s/%s', base_dir, folder_name_highpass), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name_highpass));
end

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im = imread(img_path);

    [h,w] = size(im);
    im_fft = fftshift(fft2(im));

    im_fft_lowpass  = im_fft;
    im_fft_highpass = im_fft;

    R = 10;

    for x = 1:h
        for y = 1:w
            if (x - h/2)*(x - h/2) + (y - w/2)*(y - w/2) <R*R
                im_fft_highpass(x,y) = 0;
            else
                im_fft_lowpass(x,y) = 0;
            end
        end
    end

    im_fft_highpass = ifft2(im_fft_highpass);
    im_fft_lowpass = ifft2(im_fft_lowpass);

    im_fft_highpass = sqrt(im_fft_highpass.*conj(im_fft_highpass));
    im_fft_lowpass = sqrt(im_fft_lowpass.*conj(im_fft_lowpass));

    im_fft_highpass = im_fft_highpass/128;
    im_fft_lowpass = im_fft_lowpass/128;

    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    y_name_highpass = sprintf('%s/%s/%s_highpass.bmp', base_dir, folder_name_highpass, image_name);
    y_name_lowpass = sprintf('%s/%s/%s_lowpass.bmp', base_dir, folder_name_lowpass, image_name);

    imwrite(uint8(im_fft_highpass*256), y_name_highpass);
    imwrite(uint8(im_fft_lowpass*256), y_name_lowpass);

    if data <33
        hei_start_pixel = fix((data-1)/8)* h + 1;

        wid_num = rem(data,8) -1 ;
        if wid_num == -1
            wid_num = 7;
        end
        wid_start_pixel = wid_num * w + 1;

        feature_maps_all_highpass(hei_start_pixel : hei_start_pixel + h-1,...
                    wid_start_pixel : wid_start_pixel + w-1) ...
                    = uint8(im_fft_highpass*256);

        feature_maps_all_lowpass(hei_start_pixel : hei_start_pixel + h-1,...
            wid_start_pixel : wid_start_pixel + w-1) ...
            = uint8(im_fft_lowpass*256);
    end
end
y_name_highpass = sprintf('%s/%s/highpass_all.bmp', base_dir, folder_name_highpass);
y_name_lowpass = sprintf('%s/%s/lowpass_all.bmp', base_dir, folder_name_lowpass);

imwrite(feature_maps_all_highpass, y_name_highpass);
imwrite(feature_maps_all_lowpass, y_name_lowpass);
end

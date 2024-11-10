function fft_2()

base_dir = 'xxx';

imgFileLocation = sprintf('%s/',base_dir);
imgFileList = dir(sprintf('%s/*.bmp',base_dir));

imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

folder_name = 'fft_image';

if ~exist(sprintf('%s/%s', base_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', base_dir, folder_name));
end

fft_ave_high = zeros(248,248);
fft_ave_low = zeros(248,248);

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im = imread(img_path);

     [h,w] = size(im);

    im_fft = fft2(im);
    im_fft = fftshift(im_fft);
    im_fft = uint8(20*log10(abs(im_fft).^2/(h*w)));


    image_name = strrep(img_path, imgFileLocation, '');
    image_name = strrep(image_name, '.bmp', '');

    y_name = sprintf('%s/%s/%s.bmp', base_dir, folder_name, image_name);

    imwrite(im_fft, y_name);

    if data <33
        hei_start_pixel = fix((data-1)/8)* h + 1;

        wid_num = rem(data,8) -1 ;
        if wid_num == -1
            wid_num = 7;
        end
        wid_start_pixel = wid_num * w + 1;

        fft_all(hei_start_pixel : hei_start_pixel + h-1,...
                    wid_start_pixel : wid_start_pixel + w-1) ...
                    = im_fft;

    end

    if 0<data && data<17
        fft_ave_high = fft_ave_high + double(im_fft);
    elseif 16<data && data < 33
        fft_ave_low = fft_ave_low + double(im_fft);
    end
end

fft_ave_high = fft_ave_high/16;
fft_ave_low = fft_ave_low/16;

y_name_fft_all = sprintf('%s/%s/fft_all.bmp', base_dir, folder_name);
y_name_fft_high = sprintf('%s/%s/fft_high_ave.bmp', base_dir, folder_name);
y_name_fft_low = sprintf('%s/%s/fft_low_ave.bmp', base_dir, folder_name);

imwrite(fft_all, y_name_fft_all);
imwrite(uint8(fft_ave_high), y_name_fft_high);
imwrite(uint8(fft_ave_low), y_name_fft_low);
end

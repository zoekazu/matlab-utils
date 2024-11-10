clear;close all;
%% settings
addpath('../func');
folder_data = '../../Train/data';
folder_label = '../../Train/label';
folder_other = '../../Train/other';
savepath = '../../hdf5/train.h5';
size_input = 32;
size_label = 32;
size_other = 32;
stride = 6;

%% initialization
data = zeros(size_input, size_input, 1, 1);
label = zeros(size_label, size_label, 1, 1);
other = zeros(size_other, size_other, 1, 1);
padding = abs(size_input - size_label)/2;
count = 0;

%% generate data
filepaths_data = dir(fullfile(folder_data,'*.bmp'));
filepaths_label = dir(fullfile(folder_label,'*.bmp'));
filepaths_other = dir(fullfile(folder_other,'*.bmp'));

for i = 1 : length(filepaths_data)

    im_data = imread(fullfile(folder_data,filepaths_data(i).name));
    if size(im_data, 3) > 1
        im_data = rgb2ycbcr(im_data);
    end
    im_data = im2double(im_data);

    im_label = imread(fullfile(folder_label,filepaths_label(i).name));
    if size(im_label, 3) > 1
        im_label = rgb2ycbcr(im_label);
    end
    im_label = im2double(im_label);

    im_other = imread(fullfile(folder_other,filepaths_other(i).name));
    if size(im_other, 3) > 1
        im_other = rgb2ycbcr(im_other);
    end
    im_other = im2double(im_other);

    [hei,wid] = size(im_label);

    for x = 1 : stride : hei-size_input+1
        for y = 1 :stride : wid-size_input+1

            subim_input = im_data(x : x+size_input-1, y : y+size_input-1);
            subim_other = im_other(x : x+size_input-1, y : y+size_input-1);
            subim_label = im_label(x+padding : x+padding+size_label-1, y+padding : y+padding+size_label-1);

            count=count+1;
            data(:, :, :, count) = subim_input;
            other(:, :, :, count) = subim_other;
            label(:, :, :, count) = subim_label;
        end
    end
end

data = cat(3,data,other);
order = randperm(count);
data = data(:, :, :, order);
label = label(:, :, :, order);

%% writing to HDF5
chunksz = 32;
created_flag = false;
totalct = 0;

for batchno = 1:floor(count/chunksz)
    last_read=(batchno-1)*chunksz;
    batchdata = data(:,:,:,last_read+1:last_read+chunksz);
    batchlabs = label(:,:,:,last_read+1:last_read+chunksz);

    startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,1,1,totalct+1]);
    curr_dat_sz = store2hdf5(savepath, batchdata, batchlabs, ~created_flag, startloc, chunksz);
    created_flag = true;
    totalct = curr_dat_sz(end);
end
h5disp(savepath);
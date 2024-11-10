function makeDataset()

save_dir = 'xxx';
base_dir = 'xxx';
base_dir_teach = 'xxx';

addInfo = [100,0,0
           500,0,0
           400,150,90
           680,150,90
           100,0,180
           500,0,180
           300,150,270
           650,150,270];

addRatio = 210;
compression = 0.25;
type = 'Hard';
end

function makeDataset(base_dir,base_dir_teach,save_dir,type,addInfo,addRatio,compression)

base_dir = 'xxx';
imgFileLocation = sprintf('%s/',base_dir);
imgFileList = dir(sprintf('%s/*.bmp',base_dir));
imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

imgFileLocation = sprintf('%s/',base_dir);
imgFileList = dir(sprintf('%s/*.bmp',base_dir));
imgNum = size(imgFileList);
imgFileNameList = cell(imgNum);

imgFileLocation_teach = sprintf('%s/',base_dir_teach);
imgFileList_teach = dir(sprintf('%s/*.bmp',base_dir_teach));
imgNum_teach = size(imgFileList_teach);
imgFileNameList_teach = cell(imgNum_teach);

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

for i = 1 : imgNum(1)
    imgFileName = char(imgFileList(i).name);
    imgFileNameList{i} = sprintf('%s%s', imgFileLocation, imgFileName);
end

for i = 1 : imgNum_teach(1)
    imgFileName_teach = char(imgFileList_teach(i).name);
    imgFileNameList_teach{i} = sprintf('%s%s', imgFileLocation_teach, imgFileName_teach);
end

folder_name_seg_teach = 'label';
folder_name_seg = 'seg';
folder_name = 'data';

if ~exist(sprintf('%s/%s', save_dir, folder_name), 'dir')
    mkdir(sprintf('%s/%s', save_dir, folder_name));
end
if ~exist(sprintf('%s/%s', save_dir, folder_name_seg), 'dir')
    mkdir(sprintf('%s/%s', save_dir, folder_name_seg));
end
if ~exist(sprintf('%s/%s', save_dir, folder_name_seg_teach), 'dir')
    mkdir(sprintf('%s/%s', save_dir, folder_name_seg_teach));
end

ForePixel = 0;
BodyPixel = 0;
BackPixel = 0;
AllPixel = 0;

[info_h,~] = size(addInfo);

for data = 1:length(imgFileNameList)

    img_path = char(imgFileNameList(data));
    im = imread(img_path);
    [h,w,~] = size(im);
    im = im(h*3/8+1:h,w/4+1:w*3/4);

    for data = 1:length(imgFileNameList)
        for info_len = 1 :info_h
            img_path = char(imgFileNameList(data));
            im = imread(img_path);

            img_path_teach = char(imgFileNameList_teach(data));
            im_teach_part = imread(img_path_teach);

            im_seg = segmentImage(im);

            [im_out,im_teach]= AddFore(im,im,im_teach_part,im_seg,addInfo(info_len,1),addInfo(info_len,2),addInfo(info_len,3),addRatio,compression);

            image_name = strrep(img_path, imgFileLocation, '');
            image_name = strrep(image_name, '.bmp', '');

            ForePixel = ForePixel + numel(im_teach) -nnz(im_teach);
            BodyPixel = BodyPixel + numel(im_seg) - (+ numel(im_teach) -nnz(im_teach))- nnz(im_seg);
            BackPixel = BackPixel + nnz(im_seg);
            AllPixel = AllPixel + numel(im_out);


            seg_name = sprintf('%s/%s/%s_%sFore%d_pattern%d.bmp', save_dir, folder_name_seg, image_name,type,data,info_len);
            y_name = sprintf('%s/%s/%s_%sFore%d_pattern%d.bmp', save_dir, folder_name, image_name,type,data,info_len);
            seg_teach_name = sprintf('%s/%s/%s_%sFore%d_pattern%d.bmp', save_dir, folder_name_seg_teach, image_name,type,data,info_len);
            imwrite(im_seg, seg_name);
            imwrite(im_teach,  seg_teach_name);
            imwrite(im_out, y_name);
        end
    end
end

PixelAmount_path = sprintf("%sPixelAmount.txt",save_dir);
PixelAmount_txt = fopen(PixelAmount_path,'wt');
fprintf(PixelAmount_txt,"Label of Fore is 0\n%f\n",single(AllPixel/ForePixel));
fprintf(PixelAmount_txt,"Label of body is 1\n%f\n",single(AllPixel/BodyPixel));
fprintf(PixelAmount_txt,"Label of back is 2\n%f\n",single(AllPixel/BackPixel));
fclose(PixelAmount_txt);

end

function [im,im_teach]= AddFore(im,im,im_teach_part,im_seg,sPositionX,sPositionY,rotateInfo,addRatio,compression)

    im = imrotate(im,rotateInfo);
    im_teach_part = imrotate(im_teach_part,rotateInfo);

    [hei,wid,~] = size(im);
    [hei_teach_part,wid_teach_part,~] = size(im);

    im_ori = im;
    im_teach = ones(hei,wid);

    %Calculate average of back pixel
    back_cnt = 0;
    back_pixel = 0;
    for back_x = 1:hei_teach_part
        for back_y = 1:wid_teach_part
            if im_teach_part(back_x,back_y) == 1
                back_cnt = back_cnt +1 ;
                back_pixel = back_pixel + double(im(back_x,back_y));
            end
        end
    end
    back_pixel = round(back_pixel/back_cnt);

    for x = sPositionX: hei_teach_part: hei - hei_teach_part
        for y = sPositionY: wid_teach_part: wid-wid_teach_part

            for xx = 1:hei_teach_part
                for yy = 1:wid_teach_part
                    if im_teach_part(xx,yy) == 0
                        im(x+xx,y+yy) = im(x+xx,y+yy) - compression*(back_pixel - im(xx,yy)); %addInfo
                        im_teach(x+xx,y+yy) = 0;
                    end
                end
            end
        end
    end
    for i = 1:hei
        for j  = 1:wid
            if im_seg(i,j) ==  1
                im_teach(i,j) = 1;
                im(i,j) = im_ori(i,j);
            end
        end
    end

    im_teach = imbinarize(im_teach);
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
function out = area_average_reduction_x4(input, scale)

% only x1/4
input = double(input);

if size(input, 3) > 1
    [hei, wid, ch] = size(input);

    out = double(zeros(hei/scale, wid/scale, ch));

    count_x = 1;
    count_y = 1;

    for y = 1:scale:size(input, 1)
        for x = 1:scale:size(input, 2)
            for c = 1:size(input, 3)
                out(count_y,count_x,c) = input(y,x,c) + input(y,x+1,c) + input(y,x+2,c) + input(y,x+3,c)...
                    + input(y+1,x,c) + input(y+1,x+1,c) + input(y+1,x+2,c) + input(y+1,x+3,c)...
                    + input(y+2,x,c) + input(y+2,x+1,c) + input(y+2,x+2,c) + input(y+2,x+3,c)...
                    + input(y+3,x,c) + input(y+3,x+1,c) + input(y+3,x+2,c) + input(y+3,x+3,c);
            end
            count_x = count_x + 1;
        end
        count_x = 1;
        count_y = count_y + 1;
    end
    out = out/16;
    out = uint8(out);
else
    [hei, wid] = size(input);

    out = double(zeros(hei/scale, wid/scale));

    count_x = 1;
    count_y = 1;

    for y = 1:scale:size(input, 1)
        for x = 1:scale:size(input, 2)
            out(count_y,count_x) = input(y,x) + input(y,x+1) + input(y,x+2) + input(y,x+3)...
                + input(y+1,x) + input(y+1,x+1) + input(y+1,x+2) + input(y+1,x+3)...
                + input(y+2,x) + input(y+2,x+1) + input(y+2,x+2) + input(y+2,x+3)...
                + input(y+3,x) + input(y+3,x+1) + input(y+3,x+2) + input(y+3,x+3);
            count_x = count_x + 1;
        end
        count_x = 1;
        count_y = count_y + 1;
    end
    out = out/16;
    out = uint8(out);
end

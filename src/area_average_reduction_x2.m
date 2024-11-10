function out = area_average_reduction_x2(input, scale)

% only x1/2
input = double(input);

if size(input, 3) > 1
    [hei, wid, ch] = size(input);

    out = double(zeros(hei/scale, wid/scale, ch));

    count_x = 1;
    count_y = 1;

    for y = 1:2:size(input, 1)
        for x = 1:2:size(input, 2)
            for c = 1:size(input, 3)
                out(count_y, count_x, c) = input(y,x,c) + input(y,x+1,c) + input(y+1,x,c) + input(y+1,x+1,c);
            end
            count_x = count_x + 1;
        end
        count_x = 1;
        count_y = count_y + 1;
    end
    out = out/4;
    out = uint8(out);
else
    [hei, wid] = size(input);

    out = double(zeros(hei/scale, wid/scale));

    count_x = 1;
    count_y = 1;

    for y = 1:scale:size(input, 1)
        for x = 1:scale:size(input, 2)
            out(count_y, count_x) = input(y,x) + input(y,x+1) + input(y+1,x) + input(y+1,x+1);
            count_x = count_x + 1;
        end
        count_x = 1;
        count_y = count_y + 1;
    end
    out = out/4;
    out = uint8(out);
end
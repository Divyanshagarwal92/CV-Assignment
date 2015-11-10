function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
width = dest_canvas_width_height(1);
height = dest_canvas_width_height(2);
[r, c, t] = size(src_img);

mask = logical(zeros(height,width));
result_img = double(zeros(height,width,3));

for i=1:height
    for j=1:width
        src = applyHomography(resultToSrc_H,[j,i]);
        x = round(src(1));
        y = round(src(2));
        if x > 0 & x <= c & y > 0 & y <= r 
            value = src_img(y,x,:);
            result_img(i,j,:) = value(:);
            mask(i,j) = 1;
        end
    end
end
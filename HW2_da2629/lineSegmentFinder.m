function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)

thresh = 0.06;
edge_img = edge(orig_img,'canny', thresh);
fig = figure();
imshow(orig_img);

[rows,cols] = find( edge_img == 1);


[r,c] = size(orig_img);
x = [1:c];
processed_img = hough_img > hough_threshold;
[rho, theta] = find(processed_img );

% flag = ones(size(rho));
% count = 0;
% % removing redundant lines
% for i = 2:size(rho,1)
%     if abs(rho(i)-rho(i-1)) < 10 && abs(theta(i)-theta(i-1)) <= 3
%         flag(i) = -1;
%         count = count + 1;
%     end
% end


for i=1:size(rho,1) % pick ith tuple of rho-theta

    list_x = [0];
    list_y = [0];
    th = (theta(i)-1)*pi/180.0;
    rh = rho(i) - 0.5*(size(hough_img,1)- 1);
    
    for j=1:size(rows,1) % pick jth point
        pstep = 1;
        p = -round(sqrt((size(orig_img,1))^2+(size(orig_img,2))^2)):pstep:round(sqrt((size(orig_img,1))^2+(size(orig_img,2))^2));
        tetastep = 1;
        teta = 0:tetastep:180-tetastep;
        for k = teta % iterate over teta and calculate rho_k
            teta_k = k*pi/180;
            rho_k = round(-cols(j)*sin(teta_k) + rows(j)*cos(teta_k));
            if rho_k < p(1) || rho_k > p(end)
                continue;
            end
            if rho_k == rh && teta_k == th
%                 disp('ere');
                list_x = [list_x; cols(j)];
                list_y = [list_y; rows(j)];
            end
            
        end
        
    end
    hold on;
    seg_x = [0];
    seg_y = [0];
    for j= 3:size(list_x,1)
        if abs( list_x(j)-list_x(j-1) ) +  abs( list_y(j) - list_y(j-1) )  < 15
            seg_x = [ seg_x; list_x(j)];
            seg_y = [seg_y; list_y(j)];
            continue;
        else
            line(seg_x(2:end),seg_y(2:end),'LineWidth',2, 'Color', [1,0,0]);
            seg_x = [0];
            seg_y = [0];
%             disp('here');
        end
    end
end
I = getframe(fig);
cropped_line_img = I.cdata;

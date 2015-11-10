function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)

% rho from 1 to 1 + 2*sumthing, theta from 1 to 180
fig = figure();
imshow(orig_img);
[rows,cols] = size(orig_img);
x = [1:cols];
processed_img = hough_img > hough_threshold;
[rho, theta] = find(processed_img );
% [rho,theta]
flag = ones(size(rho));
count = 0;
for i = 2:size(rho,1)
    if abs(rho(i)-rho(i-1)) < 10 && abs(theta(i)-theta(i-1)) <= 3
        flag(i) = -1;
        count = count + 1;
    end
end
disp(['Deleted lines: ', num2str(count), ' Actual no of lines: ', num2str(size(rho,1))]);

for i=1:size(rho,1)
    if flag(i) == -1
        continue;
    end
    th = (theta(i)-1)*pi/180.0;
    rh = rho(i) - 0.5*(size(hough_img,1)- 1);
    y = tan(th) .* x + rh/cos(th) .* (x.^0);
    hold on;
    line(x,y,'LineWidth',2, 'Color', rand(1,3));
end
I = getframe(fig);
line_detected_img = I.cdata;



% for i=1:size(rho,1)
%     if i == 1
%         newarr = [double(rho(i)),theta(i), double(hough_img(rho(i),theta(i)))];
%     else
%         newarr = [newarr; double(rho(i)), theta(i), double(hough_img(rho(i),theta(i)))];
%     end
% end
% newarr = sortrows(newarr,-3);
% [rho, theta]
% for i=1:size(newarr,1)
%     if newarr(i,3) == 0
%         continue;
%     end
%     for j = 
%         for k =
%         end
%         
%     end
%     th = ( newarr(i,2) - 1 )*pi/180.0;
%     rh = rho(i) - 0.5*(size(hough_img,1)-1);
%     y = tan(th) .* x + rh/cos(th) .* (x.^0);
%     hold on;
%     line(x,y,'LineWidth',2, 'Color', rand(1,3));
% end


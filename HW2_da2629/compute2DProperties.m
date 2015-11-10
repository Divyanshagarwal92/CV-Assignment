function [db, out_img] = compute2DProperties(orig_img, labeled_img)

% labeled_img = imread(labeled_img);
nObj = max(labeled_img(:));
[rows,cols] = size(labeled_img);
x = ones(rows,1)*[1:cols];
y = [1:rows]'*ones(1,cols);
out_img = orig_img;
fh1 = figure();
imshow(out_img);
for i=1:nObj
    
    [r,c] = find(labeled_img == i);
    if size(r,1) < 20
        continue;
    end
    o1 = double( labeled_img == i);
%     hold on;
%     imshow(o1);
%     [cc,dd] = ginput(1);
    
    Meany = mean(r(:));
    Meanx = mean(c(:));
    Area = size(r,1);
    
    xp = x-(ones(size(labeled_img))*Meanx);
    yp = y-(ones(size(labeled_img))*Meany);
    
    a = sum(sum(o1 .* xp .* xp));
    b = 2*sum(sum(o1 .* xp .* yp));
    c = sum(sum(o1 .* yp .* yp));

        
    cos2theta = (a-c)/sqrt(b^2+(a-c)^2);
    sin2theta = b/sqrt(b^2+(a-c)^2);
    Imin = 0.5*(c+a)-0.5*(a-c)*(cos2theta)-0.5*b*(sin2theta);
    Imax = 0.5*(c+a)-0.5*(a-c)*(-cos2theta)-0.5*b*(-sin2theta);
    if a-c ~= 0
        theta = 0.5* atan2(b,(a-c));
        roundedness = Imin/Imax;
    else
        theta = 0;
        roundedness = 1;
    end
    
    orientation = (theta*180)/pi;
%     c = Meany - tan(theta)*Meanx
%     liney = c.*ones(3,1) + orientation.*[Meanx-50,Meanx, Meanx+50]' ;

    Arr = [double(i); double(Meany); double(Meanx); Imin; orientation; roundedness; Area];
    if i==1
        db = Arr;
    else
        db = [db, Arr];
    end
    hold on;
    
    t = double(out_img) .* x *cos(theta) + double(out_img) .* y *sin(theta);
    rho = Meany*cos(theta)-Meanx*sin(theta);
    x0 = -rho*sin(theta) + t*cos(theta);
    y0 =  rho*cos(theta) + t*sin(theta);
    line(x0,y0, 'LineWidth',2, 'Color', rand(1,3) );
    plot(Meanx, Meany, 's', 'MarkerFaceColor', [1 0 0]);


    %     plot([Meanx-50,Meanx, Meanx+50]', liney, 'g');
%     
% %         'LineWidth',2, 'Color', [0, 1, 0]);
    
end
I = getframe(fh1);
out_img = I.cdata;
% imwrite(I.cdata,'out_img.png');
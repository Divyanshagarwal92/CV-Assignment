function output_img = recognizeObjects(orig_img, labeled_img, obj_db)

[img_db, out_img] = compute2DProperties(orig_img, labeled_img);

nObj = size(obj_db,2);
nObjImg = size(img_db,2);
output_img = orig_img;
f1 = figure();
imshow(output_img);
[rows,cols] = size(labeled_img);
x = ones(rows,1)*[1:cols];
y = [1:rows]'*ones(1,cols);

for i = 1:nObj
    roundedness = obj_db(6,i);
    Area = obj_db(7,i);
    for j = 1:nObjImg
        Jround = img_db(6,j);
        Jarea = img_db(7,j);
        if abs(Jround - roundedness) < 0.1*roundedness && abs(Area - Jarea) < 0.15*Area
            Meanx = img_db(3,j);
            Meany = img_db(2,j);
            theta = img_db(5,j)*pi/180;
            hold on;
            plot(Meanx, Meany, 'ws', 'MarkerFaceColor', [1 1 1]);
            
            
            
            t = double(labeled_img) .* x *cos(theta) + double(labeled_img) .* y *sin(theta);
            rho = Meany*cos(theta)-Meanx*sin(theta);
            x0 = -rho*sin(theta) + t*cos(theta);
            y0 =  rho*cos(theta) + t*sin(theta);
            line(x0,y0,'Color',rand(1,3));
                       
        end
    end
end
I = getframe(f1);
output_img = I.cdata;

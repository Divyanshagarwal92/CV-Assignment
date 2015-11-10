function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)

num = size(img_cell,1);
light_dirs_5x3 = [];
for i=1:num
    X = img_cell{i};
    [v,ind]=max(X);
    [v1,ind1]=max(max(X));
    y = ind(ind1);
    x = ind1;
    z = sqrt(radius^2 - (x-center(2))^2 - (y-center(1)^2));
    p = (x-center(2))/z;
    q = (y-center(1))/z;
    light_dirs_5x3 = [light_dirs_5x3;double(v1).*[p,q,1]];
      % Chk normals By projecting on x-y plane 
%     figure,imshow(X);
%     x_new = x + 1000*p
%     y_new = y + 1000*q
%     hold;
%     plot([x x_new],[y y_new],'LineWidth',2);
end

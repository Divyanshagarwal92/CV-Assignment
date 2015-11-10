function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)
% img_cell = vase_img_cell;
s = size(mask);
num = size(img_cell,1);
Img = zeros(s(1), s(2), num);
for i=1:num
    Img(:,:,i) = img_cell{i};
end
albedo_img= zeros(s);
normals = zeros(s(1),s(2),3);

for i=1:size(mask,1)
    for j=1:size(mask,2)
       if mask(i,j) ~= 1
           N(i,j,:) = [0,0,1];
           continue;
       end
       [val, index] = sort(Img(i,j,:),'descend');
       s = [index(:,:,1), index(:,:,2), index(:,:,3)]';
       S = light_dirs(s,:);
       I = [ Img(i,j,s(1)), Img(i,j,s(2)), Img(i,j,s(3))]';
       n = inv(S)*I;
       albedo_img(i,j) = pi*norm(n);
       normals(i,j,:) = n/norm(n);
    end
end
albedo_img = mat2gray(albedo_img);

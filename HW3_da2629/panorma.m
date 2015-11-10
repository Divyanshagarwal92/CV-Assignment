center = imread('mountain_center.png');
left = imread('mountain_left.png');
right = imread('mountain_right.png');
imgs = im2single(left);
imgd = im2single(center);



[rd cd dd] = size(imgd);
[rs cs ds] = size(imgs);

%Compute homography between source and destination
[xs, xd] = genSIFTMatches(imgs, imgd);

ransac_n = 1000; % Max number of iteractions
ransac_eps = 10; % Acceptable alignment error

[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

%Compute bounding box of source
src_bounding_pts = [[1 1]; [cs 1]; [cs rs]; [1 rs]];
dest_bounding_pts = [[1 1]; [cd 1]; [cd rd]; [1 rd]];
src_new_bounding_pts = applyHomography(H_3x3, src_bounding_pts);

%Compute dimensions of new stitched image
row_min = min([1, min(src_new_bounding_pts(:,2)), dest_bounding_pts(3,2), max(src_new_bounding_pts(:,2))]);
row_max = max([1, min(src_new_bounding_pts(:,2)), dest_bounding_pts(3,2), max(src_new_bounding_pts(:,2))]);
col_min = min([1, min(src_new_bounding_pts(:,1)), dest_bounding_pts(2,1), max(src_new_bounding_pts(:,1))]);
col_max = max([1, min(src_new_bounding_pts(:,1)), dest_bounding_pts(2,1), max(src_new_bounding_pts(:,1))]);

%Translate both images to fit into stitched_img canvas
buffer_x = 6;   %Buffers to escape boundary cases where image lies just outside bounds
buffer_y = 6;
dest_canvas_width_height = [row_max-row_min+1+buffer_y, col_max-col_min+1+buffer_x];
stitched_img = zeros(row_max-row_min+1+buffer_y, col_max-col_min+1+buffer_x,3);
%size(stitched_img)

offset_y = -row_min+1+buffer_y/2;
offset_x = -col_min+1+buffer_x/2;
offset_mat = repmat([offset_x offset_y],size(src_bounding_pts,1),1);
dest_bounding_pts = dest_bounding_pts + offset_mat;                     %Final bounding coords of dest image
src_new_bounding_pts = src_new_bounding_pts + offset_mat;               %Final bounding coords of src image

%Write dest img into stitched image
maskd = zeros(row_max-row_min+1+buffer_y, col_max-col_min+1+buffer_x);
maskd(dest_bounding_pts(1,2):dest_bounding_pts(3,2), dest_bounding_pts(1,1):dest_bounding_pts(2,1)) = ones(size(imgd,1), size(imgd,2));
imshow(maskd);
stitched_img(dest_bounding_pts(1,2):dest_bounding_pts(3,2), dest_bounding_pts(1,1):dest_bounding_pts(2,1),:) = imgd;

%%Write src img into stitched image via backward warping
%Find new homography between translated bounding_pts and src_pts
H = computeHomography(src_bounding_pts, src_new_bounding_pts);

[masks, dest_img] = backwardWarpImg(imgs, inv(H), dest_canvas_width_height);
% mask should be of the type logical

% stitched_img = blendImagePair(stitched_img, maskd, dest_img, masks, 'blend');

masks = ~masks;
% Superimpose the image
% stitched_img = double(stitched_img) .* double(cat(3, masks, masks, masks)) + dest_img;
imgd = stitched_img;
figure, imshow(dest_img)

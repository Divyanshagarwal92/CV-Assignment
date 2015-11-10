% function stitched_img = stitchImg(varargin)

center = imread('mountain_center.png');
left = imread('mountain_left.png');
right = imread('mountain_right.png');
baseI = im2single(center);
varI = im2single(left);
% varI = im2single(right);


% numImg = nargin;
% baseI = varargin{1};
% for img=2:numImg
%     varI = varargin{i};
    [baseS, varD] = genSIFTMatches(baseI, varI);
    ransac_n = 25; % Max number of iteractions
    ransac_eps = 5; %Acceptable alignment error 
    [inliers_id, H_21] = runRANSAC(baseS, varD, ransac_n, ransac_eps);
    after_img = showCorrespondence(center, left, baseS(inliers_id(1:10), :), varD(inliers_id(1:10), :));
%     figure, imshow(after_img);
    [y,x, t] = size(varI)
    x = double(x); y = double(y);
    varCornerDest = [1.0,1.1;
                    x,1.1;
                    x,y;
                    1.1,y];
    varCornerSrc = applyHomography(inv(H_21), varCornerDest);
    
    after_img = showCorrespondence(center, left, varCornerSrc, varCornerDest);
    minimum_x = round(min([varCornerSrc(1,1),1,varCornerSrc(4,1)]));
    maximum_x = round(max([varCornerSrc(2,1),varCornerSrc(3,1), size(baseI,2)]));
    minimum_y = round(min([varCornerSrc(1,2), varCornerSrc(2,2),1]));
    maximum_y = round(max([varCornerSrc(3,2), varCornerSrc(4,2),size(baseI,1)]));
    W = maximum_x - minimum_x + 1;
    H = maximum_y - minimum_y + 1;
    Canvas = zeros(H,W,3);
    CanvasMask = zeros(H,W);
    x_offset = 1 - minimum_x;
    y_offset = 1 - minimum_y;
    Canvas(1+y_offset:y_offset+size(baseI,1), 1+x_offset:x_offset+size(baseI,2),:) = baseI;
    CanvasMask(1+y_offset:y_offset+size(baseI,1), 1+x_offset:x_offset+size(baseI,2)) = baseI(:,:,1) .^0;
    imshow(Canvas);
    
    [potrait, canvas] = genSIFTMatches(varI, Canvas);
    [inliers_id, H_3x3] = runRANSAC(potrait, canvas, ransac_n, ransac_eps);
    H_3x3
    dest_canvas_width_height = [ W , H];

    [mask, dest_img] = backwardWarpImg(varI, inv(H_3x3), dest_canvas_width_height);
    imshow(dest_img);
%     mask = ~mask;
% Superimpose the image
result =  Canvas.* cat(3, ~mask, ~mask, ~mask) + dest_img;
imshow(result);
    after_img = showCorrespondence(potrait, Canvas, potrait(inliers_id(1:10),:), canvas(inliers_id(1:10),:) );


blended_result = blendImagePair( uint8(255*Canvas), uint8(255*CanvasMask), uint8(255*dest_img), uint8(255 * (mask) ),'blend');
imshow(blended_result);

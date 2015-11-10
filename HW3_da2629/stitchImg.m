function stitched_img = stitchImg(varargin)
% 
% center = imread('mountain_center.png');
% left = imread('mountain_left.png');
% right = imread('mountain_right.png');
% baseI = im2single(center);
% varI = im2single(left);
% varI = im2single(right);

numImg = nargin;
baseI = varargin{1};
for img=2:numImg
    varI = varargin{img};
    [basePts, srcPts] = genSIFTMatches(baseI, varI);
    ransac_n = 1000; % Max number of iteractions
    ransac_eps = 6; %Acceptable alignment error 
    [inliers_id, H_21] = runRANSAC(srcPts, basePts, ransac_n, ransac_eps);
%     after_img = showCorrespondence(center, left, basePts(inliers_id(:), :), srcPts(inliers_id(:), :));
%     figure, imshow(after_img);
    
    [y,x, t] = size(varI);
    x = double(x); y = double(y);
    varCornerDest = double([1,1; x,1;x,y;1,y]);
    varCornerSrc = applyHomography(H_21, varCornerDest);    
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
    figure,imshow(Canvas);
    
    [potrait, canvas] = genSIFTMatches(varI, Canvas);
    [inliers_id, H_3x3] = runRANSAC(potrait, canvas, ransac_n, ransac_eps);
    dest_canvas_width_height = [ W , H];

    [mask, dest_img] = backwardWarpImg(varI, inv(H_3x3), dest_canvas_width_height);
    figure, imshow(dest_img);
% Superimpose the image
    result =  Canvas.* cat(3, ~mask, ~mask, ~mask) + dest_img;
    figure, imshow(result);
    blended_result = blendImagePair(  uint8(255*dest_img), uint8(255 * (mask) ), uint8(255*Canvas), uint8(255*CanvasMask),'blend');
    figure,imshow(blended_result);
    baseI = blended_result;
end

stitched_img = baseI;
% wrapped_imgs = uint8(255*dest_img);
% masks = uint8(255 * (mask));
% maskd = uint8(255*CanvasMask);
% wrapped_imgd = uint8(255*Canvas);

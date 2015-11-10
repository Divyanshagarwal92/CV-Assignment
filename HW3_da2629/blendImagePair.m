function [out_img,wMask] = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)

if strcmp(mode,'overlay')
    masks = uint8(~maskd & masks);
    maskd = uint8(maskd > 220);
    out_img = cat(3, masks, masks, masks).*wrapped_imgs + cat(3,maskd,maskd,maskd) .* wrapped_imgd;
else
    mask = (masks > 150) & (maskd > 150);
    BW = edge(mask,'canny');
    [r, c] = find(BW == 1);
    p1 = min(c)
    p2 = max(c)
    rows = ones(size(wrapped_imgs,1),1);

    columns = double(1:1:size(wrapped_imgs,2));
    columns(1:p1-1) = 1 ;
    columns(p1:p2) = ( p2  - columns(p1:p2) ) ./ double(p2-p1);
    columns(p2+1:size(wrapped_imgs,2)) = 0;

    MASK1 = rows*columns;
    
    columns = 1:1:size(wrapped_imgd,2);
    columns(1:p1-1) = 0 ;
    columns(p2+1:size(wrapped_imgd,2)) = 1;
    columns(p1:p2) = (columns(p1:p2) - p1) / (p2-p1);
    rows = ones(size(wrapped_imgd,1),1);
    MASK2 = rows*columns;
    
%     MASK2 = 1 - MASK1;
    IMAGE  = uint8( cat(3,MASK1, MASK1, MASK1) .* double(wrapped_imgs) + cat(3,MASK2, MASK2, MASK2) .* double(wrapped_imgd));
    out_img = IMAGE;
end
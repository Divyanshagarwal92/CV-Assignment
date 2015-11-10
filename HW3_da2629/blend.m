
% read images
[fish, fish_map, fish_mask] = imread('escher_fish.png');
[horse, horse_map, horse_mask] = imread('escher_horsemen.png');
% fish = imread(fishImgName);
% horse = imread(horseImgName);
mask = (fish_mask > 200) & (horse_mask > 200);
BW = edge(mask,'sobel','vertical');
[r, c] = find(BW == 1);
p1 = min(c);
p2 = max(c);
columns = 1:1:size(fish,1);
columns(1:p1-1) = 1 ;
columns(p2+1:size(fish,2)) = 1;
columns(p1:p2) = (columns(p1:p2) - p1) / (p2-p1);
rows = ones(size(fish,1),1);
MASK1 = rows*columns;
columns = 1:1:size(fish,1);
columns(1:p1-1) = 1 ;
columns(p2+1:size(fish,2)) = 1;
columns(p1:p2) = ( p2  - columns(p1:p2) ) / (p2-p1);
MASK2 = rows*columns;
IMAGE  = uint8( cat(3,MASK1, MASK1, MASK1) .* double(horse) + cat(3,MASK2, MASK2, MASK2) .* double(fish));
imshow(IMAGE);

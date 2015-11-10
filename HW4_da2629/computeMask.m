function mask = computeMask(img_cell)
num = size(img_cell,1);
mask = uint8(zeros(size(img_cell{1})));
for i=1:num
    img = img_cell{i};
    mask = mask | img;
end

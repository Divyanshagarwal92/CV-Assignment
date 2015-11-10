function labeled_img = generateLabeledImage(gray_img, threshold)

bw = double( gray_img > threshold);
labeled_img = bwlabel(bw,8);
imwrite(labeled_img,'labeled_img.png');
function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)

s = size(orig_img);
newI = uint8(zeros(s(1),2*s(2),3));
newI(1:s(1),1:s(2),:) = orig_img;
newI(1:s(1),1+s(2):2*s(2),:) = warped_img(:,:,:);

f1=  figure();
imshow(newI);
hold on;
for i=1:size(src_pts_nx2,1)
%     plot([5,10],[5,100]);
    plot([src_pts_nx2(i,1), s(2)+dest_pts_nx2(i,1)], [src_pts_nx2(i,2), dest_pts_nx2(i,2)], 'LineWidth',2, 'Color', [0, 1, 0]);
end

fm = getframe(f1);
result_img = frame2im(fm);
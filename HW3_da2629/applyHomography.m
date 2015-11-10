function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
dest_pts = zeros(size(src_pts_nx2));
H = H_3x3';
for i=1:size(src_pts_nx2,1)
    src = [ src_pts_nx2(i,:) 1];
%     dest = H'*src';
%     dest_pts(i,:) = [ dest(1)/dest(3) dest(2)/dest(3) ];
    dest_pts(i,1) = ( H(1,1)*src(1) + H(1,2)*src(2) + H(1,3) )/( H(3,1)*src(1) + H(3,2)*src(2) + H(3,3));
    dest_pts(i,2) = ( H(2,1)*src(1) + H(2,2)*src(2) + H(2,3) )/( H(3,1)*src(1) + H(3,2)*src(2) + H(3,3));
end
dest_pts_nx2 = dest_pts;
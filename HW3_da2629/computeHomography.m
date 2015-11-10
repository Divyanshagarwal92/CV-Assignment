function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
s = size(src_pts_nx2 ,1);
A = zeros(2*s,9);
for i=1:s
    src = src_pts_nx2(i,:);
    dest = dest_pts_nx2(i,:);
%     A(2*i,:) = [ 0, 0, 0, src(2), src(1), 1, -dest(1)*src(2), -dest(1)*src(2), -dest(1)];
%     A(2*i-1,:) = [src(2), src(1), 1, 0, 0, 0, -dest(2)*src(2), -dest(2)*src(1), -dest(2)];
%     
    A(2*i-1,:) = [src(1), src(2), 1, 0, 0, 0, -dest(1)*src(1), -dest(1)*src(2), -dest(1)];
    A(2*i,:) = [ 0, 0, 0, src(1), src(2), 1, -dest(2)*src(1), -dest(2)*src(2), -dest(2)];
end
[V, D] = eig(A'*A);
H = V(:,1);
H_3x3 = reshape(H,3,3);

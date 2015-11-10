function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)

H = zeros(3,3);
max_fit_count = 0;
B = zeros(size(Xs,1),1);
for i=1:ransac_n
    %Randomly choose 4 samples
    T = datasample([Xs Xd], 4);
    xs = T(:,1:2);
    xd = T(:,3:4);
    %Compute homography using sampled SIFT points
    h = computeHomography(xs, xd);
    
    %Apply homography to all SIFT points
    Xdbar = applyHomography(h, Xs);
    
    %Count number of data points with error less than or equal to eps
    euc = sqrt(sum((Xdbar-Xd).^2, 2));
    inliers_bin = (sqrt(sum((Xdbar-Xd).^2, 2)) <= eps);
    count = sum(inliers_bin);
    
    if count > max_fit_count
        max_fit_count = count;
        H = h;
        B(:) = inliers_bin(:);
    end    
end

inliers_id = find(B);
    
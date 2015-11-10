function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)

pstep = 1;
p = -round(sqrt((size(img,1))^2+(size(img,2))^2)):pstep:round(sqrt((size(img,1))^2+(size(img,2))^2)); 
tetastep = 1;
teta = 0:tetastep:180-tetastep;


%img is a logical image
hough_img = double(zeros(length(p), length(teta)));

[Y,X] = find(img > 50);
nEdgePts = size(X,1);

for i = 1:nEdgePts
    for j = teta
        teta_j = j*pi/180;
        rho_j = round(-X(i)*sin(teta_j) + Y(i)*cos(teta_j));
        if rho_j < p(1) | rho_j > p(end)
            continue;
        end
        hough_img(rho_j+p(end),j+1) = hough_img(rho_j+p(end),j+1) + 1;       
    end
end
sc = max(hough_img(:));
hough_img = round(255/sc .* hough_img);







% %% Script version
% img = imread('edge_hough_1.png');
% pstep = 1;
% p = -round(sqrt((size(img,1))^2+(size(img,2))^2)):pstep:round(sqrt((size(img,1))^2+(size(img,2))^2)); 
% tetastep = 1;
% teta = 0:tetastep:180-tetastep;
% 
% 
% %img is a logical image
% hough_img = double(zeros(length(p), length(teta)));
% 
% [Y,X] = find(img > 50);
% nEdgePts = size(X,1);
% 
% for i = 1:nEdgePts
%     for j = teta
%         teta_j = j*pi/180;
%         rho_j = round(-X(i)*sin(teta_j) + Y(i)*cos(teta_j));
%         if rho_j < p(1) | rho_j > p(end)
%             continue;
%         end
%         hough_img(rho_j+p(end),j+1) = hough_img(rho_j+p(end),j+1) + 1;       
%     end
% end



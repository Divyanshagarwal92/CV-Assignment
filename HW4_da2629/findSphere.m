function [center, radius] = findSphere(img)

I = img > 0.01;

Area = sum(sum(I==1));
[r,c] = find(I==1);

center = round([ sum(r)/Area, sum(c)/Area ]);
radius = sqrt(Area/pi);
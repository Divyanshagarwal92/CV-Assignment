% NONMAXSUPPTS - Non-maximal suppression for features/corners
%
% Non maxima suppression and thresholding for points generated by a feature
% or corner detector.
%
% Usage:   [r,c] = nonmaxsuppts(cim, radius, thresh, im)
%                                                    /
%                                                optional
%
%          [r,c, rsubp, csubp] = nonmaxsuppts(cim, radius, thresh, im)
%                                                             
% Arguments:
%            cim    - corner strength image.
%            radius - radius of region considered in non-maximal
%                     suppression. Typical values to use might
%                     be 1-3 pixels.
%            thresh - threshold.
%            im     - optional image data.  If this is supplied the
%                     thresholded corners are overlayed on this
%                     image. This can be useful for parameter tuning.
% Returns:
%            r      - row coordinates of corner points (integer valued).
%            c      - column coordinates of corner points.
%            rsubp  - If four return values are requested sub-pixel
%            csubp  - localization of feature points is attempted and
%                     returned as an additional set of floating point
%                     coords. Note that you may still want to use the integer
%                     valued coords to specify centres of correlation windows
%                     for feature matching.
%
% Note: An issue with integer valued images is that if there are multiple pixels
% all with the same value within distance 2*radius of each other then they will
% all be marked as local maxima. 

% Copyright (c) 2003-2013 Peter Kovesi
% Centre for Exploration Targeting
% The University of Western Australia
% peter.kovesi at uwa edu au
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% September 2003  Original version
% August    2005  Subpixel localization and Octave compatibility
% January   2010  Fix for completely horizontal and vertical lines (by Thomas Stehle,
%                 RWTH Aachen University) 
% January   2011  Warning given if no maxima found

function [r,c, rsubp, csubp] = nonmaxsuppts(cim, radius, thresh, im)

    subPixel = nargout == 4;            % We want sub-pixel locations    
    [rows,cols] = size(cim);
    
    % Extract local maxima by performing a grey scale morphological
    % dilation and then finding points in the corner strength image that
    % match the dilated image and are also greater than the threshold.
    sze = 2*radius+1;                    % Size of dilation mask.
    mx = ordfilt2(cim, sze^2,ones(sze)); % Grey-scale dilate.

    % Make mask to exclude points within radius of the image boundary. 
    bordermask = zeros(size(cim));
    bordermask(radius+1:end-radius, radius+1:end-radius) = 1;
    
    % Find maxima, threshold, and apply bordermask
    cimmx = (cim==mx) & (cim>thresh) & bordermask;
    
    [r,c] = find(cimmx);                % Find row,col coords.

    
    if subPixel        % Compute local maxima to sub pixel accuracy  
        if ~isempty(r) % ...if we have some ponts to work with
        
        ind = sub2ind(size(cim),r,c);   % 1D indices of feature points
        w = 1;         % Width that we look out on each side of the feature
                       % point to fit a local parabola
        
        % Indices of points above, below, left and right of feature point
        indrminus1 = max(ind-w,1);
        indrplus1  = min(ind+w,rows*cols);
        indcminus1 = max(ind-w*rows,1);
        indcplus1  = min(ind+w*rows,rows*cols);
        
        % Solve for quadratic down rows
        rowshift = zeros(size(ind));
        cy = cim(ind);
        ay = (cim(indrminus1) + cim(indrplus1))/2 - cy;
        by = ay + cy - cim(indrminus1);
        rowshift(ay ~= 0) = -w*by(ay ~= 0)./(2*ay(ay ~= 0));       % Maxima of quadradic
        rowshift(ay == 0) = 0;
    
        % Solve for quadratic across columns    
        colshift = zeros(size(ind));
        cx = cim(ind);
        ax = (cim(indcminus1) + cim(indcplus1))/2 - cx;
        bx = ax + cx - cim(indcminus1);    
        colshift(ax ~= 0) = -w*bx(ax ~= 0)./(2*ax(ax ~= 0));       % Maxima of quadradic
        colshift(ax == 0) = 0;
    
        rsubp = r+rowshift;  % Add subpixel corrections to original row
        csubp = c+colshift;  % and column coords.
        else
        rsubp = []; csubp = [];
        end
    end
    
    if nargin==4 && ~isempty(r)     % Overlay corners on supplied image.
        figure(1), imshow(im,[]), hold on
        if subPixel
            plot(csubp,rsubp,'r+'), title('corners detected');
        else        
            plot(c,r,'r+'), title('corners detected');
        end
        hold off
    end
    
    if isempty(r)     
        warning('No maxima above threshold found\n');
    end

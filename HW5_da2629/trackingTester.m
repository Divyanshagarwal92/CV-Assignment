function trackingTester(data_params, tracking_params)


numImages = size(data_params.frame_ids,2);
rect = tracking_params.rect; % [xmin ymin width height]
searchWindow = tracking_params.search_half_window_size;

img = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(1))));
object = img( rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);
[indexI, map] = rgb2ind( object, tracking_params.bin_n);
histogram = imhist(indexI, map);
[rect(1), rect(2)]
for n=2:numImages

    trackI = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(n))));
    min_r = rect(2) - searchWindow;
    max_r = rect(2) + searchWindow;
    min_c = rect(1) - searchWindow;
    max_c = rect(1) + searchWindow;
    if min_r < 1
        min_r = 1;
    end
    if max_r > size(trackI,1)-rect(4)
        max_r = size(trackI,1)-rect(4);
    end
    if min_c < 1
        min_c = 1;
    end
    if max_c > size(trackI,2)-rect(3)
        max_c = size(trackI,2)-rect(3);
    end
    
    max_val = 0;
    max_coord = [-1,-1];
    for r=min_r:max_r
        for c=min_c:max_c
            template = trackI(r:r+rect(4),c:c+rect(3),:);
            [templateI, map_template] = rgb2ind( template, map);
            template_hist = imhist(templateI, map);
            val = corr(histogram,template_hist);
            if val > max_val
                max_val = val;
                max_coord = [r,c];
            end
        end
    end
    box = [ max_coord(2), max_coord(1), rect(3), rect(4)];
    output = drawBox(trackI, box, [255,0,0], 3);
    figure, imshow(output);
    imwrite( output,fullfile(data_params.out_dir,...
    data_params.genFname(data_params.frame_ids(n))));
    rect(1) = box(1);
    rect(2) = box(2);
    [rect(1), rect(2)]
end
function [rCorr, pCorr]= fieldPcorr(period1,period2,timestamp,position,spkData)
%%%%%%%%%%%%%%%%%%%%%%
% Purpose: The function calculate place field correlation based on Pearson's correlation. 
% 1st Author: Joonyeup Lee
% 1st written: 2015. 10. 4.
% Last modified: 2016. 5. 25.
% period1, period2: nx1 matrix which you want to compare (unit: ms)
% timestmap is a nx1 matrix from VT.mat data (unit: ms)
% position is a  nx2 matrix from VT.mat data

%%%%%%%%%%%%%%%%%%%%%%

% Parameters
alpha_v = 0.0001;
fr_threshold = 3;
fieldsize_cutoff = 10;
field_ratio = [8, 10, 5]; % Choose one for the map ratio (for smoothing. 8:1, 10:1, 5:1)

% Loading data
    rCorr = zeros(1);
    
    comp1.time = timestamp(period1(1)<=timestamp & timestamp<=period1(end));
    comp1.position = position(period1(1)<=timestamp & timestamp<=period1(end),:);
    
    comp2.time = timestamp(period2(1)<=timestamp & timestamp<=period2(end));
    comp2.position = position(period2(1)<=timestamp & timestamp<=period2(end),:);
    
    % Field map & Visit map    
    [comp1.fr_map, comp1.visit_map, comp1.visit_dur, comp1.flags] = findmaps(comp1.time, comp1.position, spkData, field_ratio(3));
    if isempty(find(comp1.visit_map,1))
        comp1.meanrate = 0;
    else
        comp1.meanrate = sum(comp1.fr_map)/sum(comp1.visit_map);
    end
    
    [comp2.fr_map, comp2.visit_map, comp2.visit_dur, comp2.flags] = findmaps(comp2.time, comp2.position, spkData, field_ratio(3));
    if isempty(find(comp2.visit_map,1))
        comp2.meanrate = 0;
    else
        comp2.meanrate = sum(comp2.fr_map)/sum(comp2.visit_map);
    end
        
    %  Ratemap
    [comp1.ratemap,~,~] = compute_rate144x96(comp1.visit_map,comp1.fr_map,alpha_v,comp1.meanrate,fr_threshold,fieldsize_cutoff);
    [comp2.ratemap,~,~] = compute_rate144x96(comp2.visit_map,comp2.fr_map,alpha_v,comp2.meanrate,fr_threshold,fieldsize_cutoff);
    
    % Pearson's correlation
    [rCorr, pCorr] = corr(comp1.ratemap(comp1.visit_map(:)&comp2.visit_map(:)), comp2.ratemap(comp1.visit_map(:)&comp2.visit_map(:)),'type','Pearson');
    return;
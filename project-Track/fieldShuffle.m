function fieldShuffle()

alpha_v = 0.005;
fr_threshold = 3;
fieldsize_cutoff = 10;
field_ratio = [72, 48];


%% Loading data

[tData, tList] = tLoad;
nCell = length(tList);

load ('VT1.mat');
load('Events.mat','sensor','fields','nSensor','nTrial');

period1 = [sensor.S1(1),sensor.S12(15)];
period2 = [sensor.S1(16),sensor.S12(30)];

% random sequence
for iSeq = 1:1000
    randSeq = randperm(size(position,1));
    randPosition{iSeq,1} = position(randSeq,:);
end

% ttdata = LoadSpikes(ttFile,'tsflag','ts','verbose',0);
for icell = 1:nCell
    [cellPath,cellName,~] = fileparts(tList{icell});
    disp(['### Analyzing ',tList{icell}, '...']);
    cd(cellPath);
    
    spkData = tData{icell}; %unit: msec
    
    pCorrIntra.original = fieldPcorr(period1,period2,timestamp,position,spkData);
    
    for iShuffle = 1:1000
        pCorrIntra.rand(iShuffle,1) = fieldPcorr(period1, period2, timestamp, randPosition{iShuffle,1}, spkData);
    end
    pShf = length(find(pCorrIntra.rand>pCorrIntra.original))/1000;

save([cellName,'.mat'],'pCorrIntra','pShfIntra','-append')
    
end

disp('### Shuffling is done! ###');
end

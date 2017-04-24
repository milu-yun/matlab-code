% Latency of neurons which are activated on the platform. (Blue)
% Among neurons which are activated on the platform, latency of neurons
% which are also activated on the platform

% common part
clearvars;
lineColor = {[144, 164, 174]./255,... % Before stimulation
    [33 150 243]./ 255,... % During stimulation
    [38, 50, 56]./255}; % After stimulation

lineWth = [1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75];
fontS = 4; fontM = 6; fontL = 8; fontXL = 10; % font size large
lineS = 0.2; lineM = 0.5; lineL = 1; % line width large

colorBlue = [33, 150, 243]/255;
colorLightBlue = [100, 181, 246]/255;
colorLLightBlue = [187, 222, 251]/255;
colorDarkBlue = [13, 71, 161]/255;
colorLightRed = [242, 138, 130]/255;
colorRed = [237, 50, 52]/255;
colorDarkRed = [183, 28, 28]/255;
colorGray = [189, 189, 189]/255;
colorLightGreen = [67, 160, 71]/255;
colorGreen = [46, 125, 50]/255;
colorDarkGreen = [27, 94, 32]/255;
colorLightGray = [238, 238, 238]/255;
colorDarkGray = [117, 117, 117]/255;
colorYellow = [255, 243, 3]/255;
colorLightYellow = [255, 249, 196]/255;
colorPurple = [123, 31, 162]/255;
colorBlack = [0, 0, 0];

markerS = 2; markerM = 4; markerL = 6; markerXL = 8;
tightInterval = [0.02 0.02]; midInterval = [0.09, 0.09]; wideInterval = [0.14 0.14];
width = 0.7;

paperSize = {[0 0 21.0 29.7]; % A4_portrait
             [0 0 29.7 21.0]; % A4_landscape
             [0 0 15.7 21.0]; % A4_half landscape
             [0 0 21.6 27.9]}; % Letter

cd('D:\Dropbox\SNL\P2_Track');
load('neuronList_ori_170413.mat');

cri_meanFR = 7;
cri_peakFR = 0;
alpha = 0.01;

% TN: track neuron
DRunTN = (T.taskType == 'DRun') & (cellfun(@max, T.peakFR1D_track) > cri_peakFR);

% total population (DRunIN / DRunIN / DRwPN / DRwIN) with light responsiveness (light activated)
DRunIN_total = DRunTN & T.meanFR_task>cri_meanFR;
DRunIN_light = DRunTN & T.meanFR_task>cri_meanFR & T.pLR_Track<alpha;
DRunIN_act = DRunTN & T.meanFR_task>cri_meanFR & T.pLR_Track<alpha & T.statDir_Track == 1;
DRunIN_ina = DRunTN & T.meanFR_task>cri_meanFR & T.pLR_Track<alpha & T.statDir_Track == -1;
DRunIN_no = DRunTN & T.meanFR_task>cri_meanFR & T.pLR_Track>=alpha;

winSize = [ones(1,4)*5, ones(1,9)*10, ones(1,14)*15];
mvWinSize = [1:4,1:9,1:14];
nCycle = length(winSize);
baseLine = [-20, 0];

[m_neuDist_DRunIN_total, ~, tracePCA_DRunIN_total, latentPCA_DRunIN_total] = analysis_neuralTrace(T.xptTrackLight(DRunIN_total),5,1,baseLine);    
[m_neuDist_DRunIN_light, ~, tracePCA_DRunIN_light, latentPCA_DRunIN_light] = analysis_neuralTrace(T.xptTrackLight(DRunIN_light),5,1,baseLine);    
[m_neuDist_DRunIN_act, ~, tracePCA_DRunIN_act, latentPCA_DRunIN_act] = analysis_neuralTrace(T.xptTrackLight(DRunIN_act),5,1,baseLine);
[m_neuDist_DRunIN_ina, ~, tracePCA_DRunIN_ina, latentPCA_DRunIN_ina] = analysis_neuralTrace(T.xptTrackLight(DRunIN_ina),5,1,baseLine);
[m_neuDist_DRunIN_no, ~, tracePCA_DRunIN_no, latentPCA_DRunIN_no] = analysis_neuralTrace(T.xptTrackLight(DRunIN_no),5,1,baseLine);

%%
nCol = 2;
nRow = 2;

fHandle(1) = figure('PaperUnits','centimeters','PaperPosition',paperSize{1},'Name','DRun_total');

hLatent(1) = axes('Position',axpt(nCol,nRow,1,1,[0.10 0.10 0.85 0.85],wideInterval));
plot(cumsum(latentPCA_DRunIN_act),'-o','color',colorBlack,'MarkerFaceColor',colorGray);
xlabel('number of components','fontSize',fontL);
ylabel('Representation (%)','fontSize',fontL);

hTrace(1) = axes('Position',axpt(nCol,nRow,2,1,[0.10, 0.10, 0.85, 0.85],wideInterval));
plot(tracePCA_DRunIN_total(:,1),tracePCA_DRunIN_total(:,2),'-o','color',colorBlack,'MarkerFaceColor',colorGray,'LineWidth',lineL);
hold on;
plot(tracePCA_DRunIN_light(:,1),tracePCA_DRunIN_light(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(1,1),tracePCA_DRunIN_light(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(end,1),tracePCA_DRunIN_light(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(:,1),tracePCA_DRunIN_act(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(1,1),tracePCA_DRunIN_act(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(end,1),tracePCA_DRunIN_act(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(:,1),tracePCA_DRunIN_ina(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(1,1),tracePCA_DRunIN_ina(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(end,1),tracePCA_DRunIN_ina(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkRed,'markerEdgeColor',colorBlack);
hold on;
xlabel('PC1','fontSize',fontL);
ylabel('PC2','fontSize',fontL);

hTrace(2) = axes('Position',axpt(nCol,nRow,1,2,[0.10, 0.10, 0.85, 0.85],wideInterval));
plot(tracePCA_DRunIN_total(:,1),tracePCA_DRunIN_total(:,2),'-o','color',colorBlack,'MarkerFaceColor',colorGray,'LineWidth',lineL);
hold on;
plot(tracePCA_DRunIN_light(:,1),tracePCA_DRunIN_light(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(1,1),tracePCA_DRunIN_light(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(end,1),tracePCA_DRunIN_light(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(:,1),tracePCA_DRunIN_act(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(1,1),tracePCA_DRunIN_act(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(end,1),tracePCA_DRunIN_act(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(:,1),tracePCA_DRunIN_ina(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(1,1),tracePCA_DRunIN_ina(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(end,1),tracePCA_DRunIN_ina(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkRed,'markerEdgeColor',colorBlack);
hold on;
xlabel('PC2','fontSize',fontL);
ylabel('PC3','fontSize',fontL);

hTrace(3) = axes('Position',axpt(nCol,nRow,2,2,[0.10, 0.10, 0.85, 0.85],wideInterval));
plot(tracePCA_DRunIN_total(:,1),tracePCA_DRunIN_total(:,2),'-o','color',colorBlack,'MarkerFaceColor',colorGray,'LineWidth',lineL);
hold on;
plot(tracePCA_DRunIN_light(:,1),tracePCA_DRunIN_light(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(1,1),tracePCA_DRunIN_light(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_light(end,1),tracePCA_DRunIN_light(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkGreen,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(:,1),tracePCA_DRunIN_act(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(1,1),tracePCA_DRunIN_act(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_act(end,1),tracePCA_DRunIN_act(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkBlue,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(:,1),tracePCA_DRunIN_ina(:,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(1,1),tracePCA_DRunIN_ina(1,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorLightRed,'markerEdgeColor',colorBlack);
hold on;
plot(tracePCA_DRunIN_ina(end,1),tracePCA_DRunIN_ina(end,2),'-o','color',colorBlack,'LineWidth',lineL,'MarkerFaceColor',colorDarkRed,'markerEdgeColor',colorBlack);
hold on;
xlabel('PC3','fontSize',fontL);
ylabel('PC1','fontSize',fontL);

set(hLatent,'Box','off','TickDir','out','YLim',[0,110]);
set(hTrace,'Box','off','TickDir','out');
print('-painters','-r300','plot_neuralTrace_DRunIN_total_PCA.tif','-dtiff');

%%
fHandle(2) = figure('PaperUnits','centimeters','PaperPosition',paperSize{1},'Name','DRun_NeuDist');
hNeuDist = axes('Position',axpt(1,1,1,1,[0.1 0.1 0.85 0.85],wideInterval));
plot(m_neuDist_DRunIN_total,'-o','color',colorLightGray,'MarkerFaceColor',colorDarkGray,'MarkerSize',markerL,'LineWidth',lineL);
hold on;
plot(m_neuDist_DRunIN_light,'-o','color',colorLightGreen,'MarkerFaceColor',colorDarkGreen,'MarkerSize',markerL,'LineWidth',lineL);
hold on;
plot(m_neuDist_DRunIN_act,'-o','color',colorLightBlue,'MarkerFaceColor',colorDarkBlue,'MarkerSize',markerL,'LineWidth',lineL);
hold on;
plot(m_neuDist_DRunIN_ina,'-o','color',colorLightRed,'MarkerFaceColor',colorDarkRed,'MarkerSize',markerL,'LineWidth',lineL);
hold on;
plot(m_neuDist_DRunIN_no,'-o','color',colorGray,'MarkerFaceColor',colorBlack,'MarkerSize',markerL,'LineWidth',lineL);

text(size(m_neuDist_DRunIN_act,1)*0.6,max(m_neuDist_DRunIN_act)*0.9,['Total (n = ',num2str(sum(double(DRunIN_total))), ')'],'color',colorDarkGray,'fontSize',fontL);
text(size(m_neuDist_DRunIN_act,1)*0.6,max(m_neuDist_DRunIN_act)*0.85,['Light resp. (n = ',num2str(sum(double(DRunIN_light))), ')'],'color',colorGreen,'fontSize',fontL);
text(size(m_neuDist_DRunIN_act,1)*0.6,max(m_neuDist_DRunIN_act)*0.80,['Light act. (n = ',num2str(sum(double(DRunIN_act))), ')'],'color',colorBlue,'fontSize',fontL);
text(size(m_neuDist_DRunIN_act,1)*0.6,max(m_neuDist_DRunIN_act)*0.75,['Light ina. (n = ',num2str(sum(double(DRunIN_ina))), ')'],'color',colorRed,'fontSize',fontL);
text(size(m_neuDist_DRunIN_act,1)*0.6,max(m_neuDist_DRunIN_act)*0.70,['No resp. (n = ',num2str(sum(double(DRunIN_no))), ')'],'color',colorBlack,'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontXL);
ylabel('Neural distance','fontSize',fontXL);
title('Neural Distance [DRun sessions]','fontSize',fontXL);
set(hNeuDist,'Box','off','TickDir','out','XLim',[0,size(m_neuDist_DRunIN_act,1)*1.01],'XTick',[0,20/1,30/1,40/1,size(m_neuDist_DRunIN_act,1)],'XTickLabel',[-20,0,10,20,100],'fontSize',fontXL);

print('-painters','-r300','plot_neuralTrace_DRunIN_total_NeuDist.tif','-dtiff');
close('all')

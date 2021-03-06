% The function plot [spike number Vs. Stimulation frequency]
% It draws rapid light activated neurons & delayed activated neurons
clearvars;

% rtDir = 'D:\Dropbox\SNL\P2_Track'; % Win version
rtDir = '/Users/Jun/Dropbox/SNL/P2_Track'; % Mac version
cd(rtDir);

load('myParameters.mat');
Txls = readtable('neuronList_freq_170613.xlsx');
load('neuronList_freq_170613.mat');
Txls.latencyIndex = categorical(Txls.latencyIndex);

alpha = 0.01;
alpha2 = alpha/5;
c_latency = 10;
cSpkpvr = 1.2;
%% Light responsive population
lightTotal = T.meanFR<9 & (T.pLR_Plfm1hz<alpha2 | T.pLR_Plfm2hz<alpha2 | T.pLR_Plfm8hz<alpha2 | T.pLR_Plfm20hz<alpha2 | T.pLR_Plfm50hz<alpha2);
lightShort = T.spkpvr>cSpkpvr & Txls.latencyIndex == 'rapid';
lightLong = T.spkpvr>cSpkpvr & Txls.latencyIndex == 'delay';
nolightCri = T.meanFR<9 & ~(T.pLR_Plfm1hz<alpha2 | T.pLR_Plfm2hz<alpha2 | T.pLR_Plfm8hz<alpha2 | T.pLR_Plfm20hz<alpha2 | T.pLR_Plfm50hz<alpha2);

evoSpike1hz_dr = T.evoSpike1hz_dr((lightShort));
evoSpike2hz_dr = T.evoSpike2hz_dr((lightShort));
evoSpike8hz_dr = T.evoSpike8hz_dr((lightShort));
evoSpike20hz_dr = T.evoSpike20hz_dr((lightShort));
evoSpike50hz_dr = T.evoSpike50hz_dr((lightShort));
totalSpk = [evoSpike1hz_dr,evoSpike2hz_dr,evoSpike8hz_dr,evoSpike20hz_dr,evoSpike50hz_dr];
norm_totalSpk = totalSpk ./ repmat(max(totalSpk,[],2),1,5);

nCell = sum(double(lightShort));

nLight_1hz = sum(double(T.meanFR<9 & T.pLR_Plfm1hz<alpha));
nLight_2hz = sum(double(T.meanFR<9 & T.pLR_Plfm2hz<alpha));
nLight_8hz = sum(double(T.meanFR<9 & T.pLR_Plfm8hz<alpha));
nLight_20hz = sum(double(T.meanFR<9 & T.pLR_Plfm20hz<alpha));
nLight_50hz = sum(double(T.meanFR<9 & T.pLR_Plfm50hz<alpha));
nlight_all = sum(double(T.meanFR<9 & (T.pLR_Plfm1hz<alpha & T.pLR_Plfm2hz<alpha & T.pLR_Plfm8hz<alpha & T.pLR_Plfm20hz<alpha & T.pLR_Plfm50hz<alpha)));

<<<<<<< Updated upstream
m_1hz = mean(evoSpike1hz_dr);
m_2hz = mean(evoSpike2hz_dr);
m_8hz = mean(evoSpike8hz_dr);
m_20hz = mean(evoSpike20hz_dr);
m_50hz = mean(evoSpike50hz_dr);
m_norm_totalSpk = mean(norm_totalSpk);

=======
<<<<<<< HEAD
m_1hz = mean(evoSpike1hz);
m_2hz = mean(evoSpike2hz);
m_8hz = mean(evoSpike8hz);
m_20hz = mean(evoSpike20hz);
m_50hz = mean(evoSpike50hz);
m_norm_totalSpk = mean(norm_totalSpk,1);

sem_1hz = std(evoSpike1hz)/sqrt(nCell);
sem_2hz = std(evoSpike2hz)/sqrt(nCell);
sem_8hz = std(evoSpike8hz)/sqrt(nCell);
sem_20hz = std(evoSpike20hz)/sqrt(nCell);
sem_50hz = std(evoSpike50hz)/sqrt(nCell);
sem_norm_totalSpk = std(norm_totalSpk,0,1)/sqrt(nCell);
=======
m_1hz = mean(evoSpike1hz_dr);
m_2hz = mean(evoSpike2hz_dr);
m_8hz = mean(evoSpike8hz_dr);
m_20hz = mean(evoSpike20hz_dr);
m_50hz = mean(evoSpike50hz_dr);
m_norm_totalSpk = mean(norm_totalSpk);

>>>>>>> Stashed changes
sem_1hz = std(evoSpike1hz_dr)/sqrt(nCell);
sem_2hz = std(evoSpike2hz_dr)/sqrt(nCell);
sem_8hz = std(evoSpike8hz_dr)/sqrt(nCell);
sem_20hz = std(evoSpike20hz_dr)/sqrt(nCell);
sem_50hz = std(evoSpike50hz_dr)/sqrt(nCell);
sem_norm_totalSpk = std(norm_totalSpk)/sqrt(nCell);
>>>>>>> origin/master

%% Long delay
evoSpike1hzLong_idr = T.evoSpike1hz_idr((lightLong));
evoSpike2hzLong_idr = T.evoSpike2hz_idr((lightLong));
evoSpike8hzLong_idr = T.evoSpike8hz_idr((lightLong));
evoSpike20hzLong_idr = T.evoSpike20hz_idr((lightLong));
evoSpike50hzLong_idr = T.evoSpike50hz_idr((lightLong));
totalSpkLong = [evoSpike1hzLong_idr,evoSpike2hzLong_idr,evoSpike8hzLong_idr,evoSpike20hzLong_idr,evoSpike50hzLong_idr];
norm_totalSpkLong = totalSpkLong ./ repmat(max(totalSpkLong,[],2),1,5);

nCellLong = sum(double(lightLong));

nLight_1hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm1hz<alpha));
nLight_2hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm2hz<alpha));
nLight_8hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm8hz<alpha));
nLight_20hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm20hz<alpha));
nLight_50hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm50hz<alpha));
nlight_allLong = sum(double(T.meanFR<9 & (T.pLR_Plfm1hz<alpha & T.pLR_Plfm2hz<alpha & T.pLR_Plfm8hz<alpha & T.pLR_Plfm20hz<alpha & T.pLR_Plfm50hz<alpha)));

m_1hzLong = mean(evoSpike1hzLong_idr);
m_2hzLong = mean(evoSpike2hzLong_idr);
m_8hzLong = mean(evoSpike8hzLong_idr);
m_20hzLong = mean(evoSpike20hzLong_idr);
m_50hzLong = mean(evoSpike50hzLong_idr);
m_norm_totalSpkLong = mean(norm_totalSpkLong);

sem_1hzLong = std(evoSpike1hzLong_idr)/sqrt(nCellLong);
sem_2hzLong = std(evoSpike2hzLong_idr)/sqrt(nCellLong);
sem_8hzLong = std(evoSpike8hzLong_idr)/sqrt(nCellLong);
sem_20hzLong = std(evoSpike20hzLong_idr)/sqrt(nCellLong);
sem_50hzLong = std(evoSpike50hzLong_idr)/sqrt(nCellLong);
sem_norm_totalSpkLong = std(norm_totalSpkLong)/sqrt(nCellLong);

%% Long delay
evoSpike1hzLong_idr = T.evoSpike1hz_idr((lightLong));
evoSpike2hzLong_idr = T.evoSpike2hz_idr((lightLong));
evoSpike8hzLong_idr = T.evoSpike8hz_idr((lightLong));
evoSpike20hzLong_idr = T.evoSpike20hz_idr((lightLong));
evoSpike50hzLong_idr = T.evoSpike50hz_idr((lightLong));
totalSpkLong = [evoSpike1hzLong_idr,evoSpike2hzLong_idr,evoSpike8hzLong_idr,evoSpike20hzLong_idr,evoSpike50hzLong_idr];
norm_totalSpkLong = totalSpkLong ./ repmat(max(totalSpkLong,[],2),1,5);

nCellLong = sum(double(lightLong));

nLight_1hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm1hz<alpha));
nLight_2hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm2hz<alpha));
nLight_8hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm8hz<alpha));
nLight_20hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm20hz<alpha));
nLight_50hzLong = sum(double(T.meanFR<9 & T.pLR_Plfm50hz<alpha));
nlight_allLong = sum(double(T.meanFR<9 & (T.pLR_Plfm1hz<alpha & T.pLR_Plfm2hz<alpha & T.pLR_Plfm8hz<alpha & T.pLR_Plfm20hz<alpha & T.pLR_Plfm50hz<alpha)));

m_1hzLong = mean(evoSpike1hzLong_idr);
m_2hzLong = mean(evoSpike2hzLong_idr);
m_8hzLong = mean(evoSpike8hzLong_idr);
m_20hzLong = mean(evoSpike20hzLong_idr);
m_50hzLong = mean(evoSpike50hzLong_idr);
m_norm_totalSpkLong = mean(norm_totalSpkLong);

sem_1hzLong = std(evoSpike1hzLong_idr)/sqrt(nCellLong);
sem_2hzLong = std(evoSpike2hzLong_idr)/sqrt(nCellLong);
sem_8hzLong = std(evoSpike8hzLong_idr)/sqrt(nCellLong);
sem_20hzLong = std(evoSpike20hzLong_idr)/sqrt(nCellLong);
sem_50hzLong = std(evoSpike50hzLong_idr)/sqrt(nCellLong);
sem_norm_totalSpkLong = std(norm_totalSpkLong)/sqrt(nCellLong);

%% No light responsive population
% noevoSpike1hz = T.evoSpike1hz(nolightCri);
% noevoSpike2hz = T.evoSpike2hz(nolightCri);
% noevoSpike8hz = T.evoSpike8hz(nolightCri);
% noevoSpike20hz = T.evoSpike20hz(nolightCri);
% noevoSpike50hz = T.evoSpike50hz(nolightCri);
% 
% nNoLCell = length(noevoSpike1hz);
% 
% m_no_1hz = mean(noevoSpike1hz);
% m_no_2hz = mean(noevoSpike2hz);
% m_no_8hz = mean(noevoSpike8hz);
% m_no_20hz = mean(noevoSpike20hz);
% m_no_50hz = mean(noevoSpike50hz);
% 
% sem_no_1hz = std(noevoSpike1hz)/sqrt(nNoLCell);
% sem_no_2hz = std(noevoSpike2hz)/sqrt(nNoLCell);
% sem_no_8hz = std(noevoSpike8hz)/sqrt(nNoLCell);
% sem_no_20hz = std(noevoSpike20hz)/sqrt(nNoLCell);
% sem_no_50hz = std(noevoSpike50hz)/sqrt(nNoLCell);

%% Plot
nCol = 2;
nRow = 2;

hHandle = figure('PaperUnits','centimeters','PaperPosition',[0 0 6 6]*2);
% light response population
hPlot(1) = axes('Position',axpt(nCol,nRow,1,1,[0.1 0.1 0.80 0.85],wideInterval));
<<<<<<< Updated upstream
plot([1,2,3,4,5],[evoSpike1hz_dr, evoSpike2hz_dr, evoSpike8hz_dr, evoSpike20hz_dr, evoSpike50hz_dr]','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
=======
<<<<<<< HEAD
plot([1,2,3,4,5],[evoSpike1hz, evoSpike2hz, evoSpike8hz, evoSpike20hz, evoSpike50hz]','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
=======
plot([1,2,3,4,5],[evoSpike1hz_dr, evoSpike2hz_dr, evoSpike8hz_dr, evoSpike20hz_dr, evoSpike50hz_dr]','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
>>>>>>> origin/master
>>>>>>> Stashed changes
hold on;
plot([1,2,3,4,5],[m_1hz, m_2hz, m_8hz, m_20hz, m_50hz],'o','color',colorBlack,'markerSize',markerL,'markerEdgeColor',colorBlack,'markerFaceColor',colorBlack);
hold on;
errorbarJun([1,2,3,4,5],[m_1hz, m_2hz, m_8hz, m_20hz, m_50hz],[sem_1hz,sem_2hz,sem_8hz,sem_20hz,sem_50hz],0.2, 0.8, colorBlack);

text(1,60,['n = ',num2str(nCell)],'fontSize',fontL);
xlabel('Frequency, Hz','fontSize',fontL);
ylabel('Spike number','fontSize',fontL);
title('Short delay','fontSize',fontL);

hPlot(2) = axes('Position',axpt(nCol,nRow,1,2,[0.1 0.1 0.80 0.85],wideInterval));
plot([1,2,3,4,5],norm_totalSpk','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
hold on;
plot([1,2,3,4,5],m_norm_totalSpk,'o','color',colorBlack,'markerSize',markerL,'markerEdgeColor',colorBlack,'markerFaceColor',colorBlack);
hold on;
errorbarJun([1,2,3,4,5],m_norm_totalSpk,sem_norm_totalSpk,0.2, 0.8, colorBlack);

text(1,60,['n = ',num2str(nCell)],'fontSize',fontL);
xlabel('Frequency, Hz','fontSize',fontL);
ylabel('Normalized spike number','fontSize',fontL);
title('Short delay','fontSize',fontL);

hPlot(3) = axes('Position',axpt(nCol,nRow,2,1,[0.1 0.1 0.80 0.85],wideInterval));
plot([1,2,3,4,5],[evoSpike1hzLong_idr, evoSpike2hzLong_idr, evoSpike8hzLong_idr, evoSpike20hzLong_idr, evoSpike50hzLong_idr]','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
hold on;
plot([1,2,3,4,5],[m_1hzLong, m_2hzLong, m_8hzLong, m_20hzLong, m_50hzLong],'o','color',colorBlack,'markerSize',markerL,'markerEdgeColor',colorBlack,'markerFaceColor',colorBlack);
hold on;
errorbarJun([1,2,3,4,5],[m_1hzLong, m_2hzLong, m_8hzLong, m_20hzLong, m_50hzLong],[sem_1hzLong,sem_2hzLong,sem_8hzLong,sem_20hzLong,sem_50hzLong],0.2, 0.8, colorBlack);

text(1,60,['n = ',num2str(nCellLong)],'fontSize',fontL);
xlabel('Frequency, Hz','fontSize',fontL);
ylabel('Spike number','fontSize',fontL);
title('Long delay','fontSize',fontL);

hPlot(4) = axes('Position',axpt(nCol,nRow,2,2,[0.1 0.1 0.80 0.85],wideInterval));
plot([1,2,3,4,5],norm_totalSpkLong','-o','color',colorDarkGray,'markerSize',markerL,'markerEdgeColor',colorDarkGray,'markerFaceColor',colorLightGray);
hold on;
plot([1,2,3,4,5],m_norm_totalSpkLong,'o','color',colorBlack,'markerSize',markerL,'markerEdgeColor',colorBlack,'markerFaceColor',colorBlack);
hold on;
errorbarJun([1,2,3,4,5],m_norm_totalSpkLong,sem_norm_totalSpkLong,0.2, 0.8, colorBlack);

xlabel('Frequency, Hz','fontSize',fontL);
ylabel('Normalized spike number','fontSize',fontL);
title('Long delay','fontSize',fontL);

set(hPlot,'TickDir','out','Box','off');
set(hPlot,'XLim',[0,6],'XTick',[1:5],'XTickLabel',{'1';'2';'8';'20';'50'},'fontSize',fontL);
set(hPlot(1),'YLim',[-1,250]);
set(hPlot(2),'YLim',[-0.1,1.2]);
set(hPlot(3),'YLim',[-1,150]);
set(hPlot(4),'YLim',[-0.1,1.2]);

formatOut = 'yymmdd';
print('-painters','-r300','-dtiff',[datestr(now,formatOut),'_fig1_frequencyTest_ShortLong_spike_','.tif']);
% print('-painters','-r300','-depsc',['fig1_frequencyTest_spike_',datestr(now,formatOut),'.ai']);
% close();
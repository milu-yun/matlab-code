clearvars;

load myParameters.mat         
rtDir = 'D:\Dropbox\SNL\P2_Track';
load('neuronList_pulse_170510.mat');

alpha = 0.01;
%% Population separation
cri_MeanFR = 9;
cMaxPeakFR = 1;
cSpkpvr = 1.1;
alpha = 0.01;

condiPN = T.spkpvr>cSpkpvr & T.meanFR10<cri_MeanFR;
condiIN = ~condiPN;

% listPN = T.meanFR10<cri_meanFR;
listPN = condiPN;
cri_lightAct = T.pLR_Plfm2hz<alpha & T.statDir_Plfm2hz==1;
cri_lightInAct = T.pLR_Plfm2hz<alpha & T.statDir_Plfm2hz==-1;
cri_lightNo = ~(T.pLR_Plfm2hz<alpha);

% Pyramidal neuron
actPN_peth10ms = cell2mat(T.peth10ms(listPN & cri_lightAct));
actPN_peth50ms = cell2mat(T.peth50ms(listPN & cri_lightAct));

inactPN_peth10ms = cell2mat(T.peth10ms(listPN & cri_lightInAct));
inactPN_peth50ms = cell2mat(T.peth50ms(listPN & cri_lightInAct));

noPN_peth10ms = cell2mat(T.peth10ms(listPN & cri_lightNo));
noPN_peth50ms = cell2mat(T.peth50ms(listPN & cri_lightNo));

% Interneuron
actIN_peth10ms = cell2mat(T.peth10ms(~listPN & cri_lightAct));
actIN_peth50ms = cell2mat(T.peth50ms(~listPN & cri_lightAct));

inactIN_peth10ms = cell2mat(T.peth10ms(~listPN & cri_lightInAct));
inactIN_peth50ms = cell2mat(T.peth50ms(~listPN & cri_lightInAct));

noIN_peth10ms = cell2mat(T.peth10ms(~listPN & cri_lightNo));
noIN_peth50ms = cell2mat(T.peth50ms(~listPN & cri_lightNo));

%% Mean & SEM
nactPN10ms = size(actPN_peth10ms,1);
m_actPN_peth10ms = mean(actPN_peth10ms,1);
sem_actPN_peth10ms = std(actPN_peth10ms,1)/sqrt(nactPN10ms);
nactPN50ms = size(actPN_peth50ms,1);
m_actPN_peth50ms = mean(actPN_peth50ms,1);
sem_actPN_peth50ms = std(actPN_peth50ms,1)/sqrt(nactPN50ms);

ninactPN10ms = size(inactPN_peth10ms,1);
m_inactPN_peth10ms = mean(inactPN_peth10ms,1);
sem_inactPN_peth10ms = std(inactPN_peth10ms,1)/sqrt(ninactPN10ms);
ninactPN50ms = size(inactPN_peth50ms,1);
m_inactPN_peth50ms = mean(inactPN_peth50ms,1);
sem_inactPN_peth50ms = std(inactPN_peth50ms,1)/sqrt(ninactPN50ms);

nnoPN10ms = size(noPN_peth10ms,1);
m_noPN_peth10ms = mean(noPN_peth10ms,1);
sem_noPN_peth10ms = std(noPN_peth10ms,1)/sqrt(nnoPN10ms);
nnoPN50ms = size(noPN_peth50ms,1);
m_noPN_peth50ms = mean(noPN_peth50ms,1);
sem_noPN_peth50ms = std(noPN_peth50ms,1)/sqrt(nnoPN50ms);


nactIN10ms = size(actIN_peth10ms,1);
m_actIN_peth10ms = mean(actIN_peth10ms,1);
sem_actIN_peth10ms = std(actIN_peth10ms,1)/sqrt(nactIN10ms);
nactIN50ms = size(actIN_peth50ms,1);
m_actIN_peth50ms = mean(actIN_peth50ms,1);
sem_actIN_peth50ms = std(actIN_peth50ms,1)/sqrt(nactIN50ms);

ninactIN10ms = size(inactIN_peth10ms,1);
m_inactIN_peth10ms = mean(inactIN_peth10ms,1);
sem_inactIN_peth10ms = std(inactIN_peth10ms,1)/sqrt(ninactIN10ms);
ninactIN50ms = size(inactIN_peth50ms,1);
m_inactIN_peth50ms = mean(inactIN_peth50ms,1);
sem_inactIN_peth50ms = std(inactIN_peth50ms,1)/sqrt(ninactIN50ms);

nnoIN10ms = size(noIN_peth10ms,1);
m_noIN_peth10ms = mean(noIN_peth10ms,1);
sem_noIN_peth10ms = std(noIN_peth10ms,1)/sqrt(nnoIN10ms);
nnoIN50ms = size(noIN_peth50ms,1);
m_noIN_peth50ms = mean(noIN_peth50ms,1);
sem_noIN_peth50ms = std(noIN_peth50ms,1)/sqrt(nnoIN50ms);

%% Plot
nCol = 3;
nRow = 4;
xpt = -200:2:300;
yMaxPN = max([m_actPN_peth10ms,m_actPN_peth50ms])*1.5;
yMaxIN = max([m_actIN_peth10ms,m_actIN_peth50ms])*1.5;

fHandle = figure('PaperUnits','centimeters','PaperPosition',paperSize{2});

hPlotPN(1) = axes('Position',axpt(nCol,nRow,1,1,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxPN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,10,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(1) = bar(xpt,m_actPN_peth10ms,'histc');
text(100, yMaxPN*0.8,['n = ',num2str(nactPN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('PN_activated','fontSize',fontL,'interpreter','none','fontWeight','bold');
hPlotPN(2) = axes('Position',axpt(nCol,nRow,1,2,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxPN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,50,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(2) = bar(xpt,m_actPN_peth50ms,'histc');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

hPlotPN(3) = axes('Position',axpt(nCol,nRow,2,1,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxPN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,10,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(3) = bar(xpt,m_inactPN_peth10ms,'histc');
text(100, yMaxPN*0.8,['n = ',num2str(ninactPN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('PN_inactivated','interpreter','none','fontSize',fontL);
hPlotPN(4) = axes('Position',axpt(nCol,nRow,2,2,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxPN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,50,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(4) = bar(xpt,m_inactPN_peth50ms,'histc');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

hPlotPN(5) = axes('Position',axpt(nCol,nRow,3,1,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxPN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,10,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(5) = bar(xpt,m_noPN_peth10ms,'histc');
text(100, yMaxPN*0.8,['n = ',num2str(nnoPN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('PN_no response','fontSize',fontL,'interpreter','none','fontWeight','bold');
hPlotPN(6) = axes('Position',axpt(nCol,nRow,3,2,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxPN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.925,50,yMaxPN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN(6) = bar(xpt,m_noPN_peth50ms,'histc');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

set(hBarPN,'FaceColor',colorBlack,'EdgeColor',colorBlack,'FaceAlpha',1);
set(hPlotPN,'Box','off','TickDir','out','XLim',[-20,120],'XTick',[-20:20:100],'YLim',[0,yMaxPN],'fontSize',fontL);

%% IN
hPlotIN(1) = axes('Position',axpt(nCol,nRow,1,3,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxIN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,10,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(1) = bar(xpt,m_actIN_peth10ms,'histc');
text(100, yMaxIN*0.8,['n = ',num2str(nactIN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('IN_activated','fontSize',fontL,'interpreter','none','fontWeight','bold');
hPlotIN(2) = axes('Position',axpt(nCol,nRow,1,4,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxIN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,50,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(2) = bar(xpt,m_actIN_peth50ms,'histc');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

hPlotIN(3) = axes('Position',axpt(nCol,nRow,2,3,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxIN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,10,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(3) = bar(xpt,m_inactIN_peth10ms,'histc');
text(100, yMaxIN*0.8,['n = ',num2str(ninactIN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('IN_inactivated','fontSize',fontL,'interpreter','none','fontWeight','bold');
hPlotIN(4) = axes('Position',axpt(nCol,nRow,2,4,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxIN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,50,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(4) = bar(xpt,m_inactIN_peth50ms,'histc');
uistack(hBarIN(4),'up');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

hPlotIN(5) = axes('Position',axpt(nCol,nRow,3,3,[0.10 0.10 0.85 0.8],wideInterval));
bar(5,yMaxIN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,10,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(5) = bar(xpt,m_noIN_peth10ms,'histc');
text(100, yMaxIN*0.8,['n = ',num2str(nnoIN10ms)],'fontSize',fontL);
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);
title('IN_no response','fontSize',fontL,'interpreter','none','fontWeight','bold');
hPlotIN(6) = axes('Position',axpt(nCol,nRow,3,4,[0.10 0.10 0.85 0.8],wideInterval));
bar(25,yMaxIN,'BarWidth',50,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxIN*0.925,50,yMaxIN*0.075],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarIN(6) = bar(xpt,m_noIN_peth50ms,'histc');
uistack(hBarIN(4),'up');
xlabel('Time (ms)','fontSize',fontL);
ylabel('Spikes/bin','fontSize',fontL);

set(hBarIN,'FaceColor',colorBlack,'EdgeAlpha',0);
set(hPlotIN,'Box','off','TickDir','out','XLim',[-20,120],'XTick',[-20:20:100],'YLim',[0,yMaxIN],'fontSize',fontL);

formatOut = 'yymmdd';
% print('-painters','-r300','-dtiff',['plot_plfm_laserWidth_',datestr(now,formatOut),'.tif']);
% print('-painters','-r300','-depsc',['plot_plfm_laserWidth_',datestr(now,formatOut),'.ai']);
close;

%% figure 2
fHandle = figure('PaperUnits','centimeters','PaperPosition',paperSize{1});
nCol2 = 5;
nRow2 = 6;

hPlotPN2(1) = axes('Position',axpt(nCol2,nRow2,1:2,1:2,[0.10 0.10 0.85 0.85],wideInterval));
bar(5,yMaxPN,'BarWidth',10,'LineStyle','none','FaceColor',colorLLightBlue);
hold on;
rectangle('Position',[0,yMaxPN*0.970,10,yMaxPN*0.030],'LineStyle','none','FaceColor',colorBlue);
hold on;
hBarPN2(1) = bar(xpt,m_actPN_peth10ms,'histc');
errorbarJun(xpt+1,m_actPN_peth10ms,sem_actPN_peth10ms,1,0.6,colorDarkGray);
text(100, yMaxPN*0.8,['n = ',num2str(nactPN10ms)],'fontSize',fontM);
xlabel('Time (ms)','fontSize',fontM);
ylabel('Spikes/bin','fontSize',fontM);
title('PN_activated','fontSize',fontM,'interpreter','none','fontWeight','bold');

set(hBarPN2,'FaceColor',colorBlack,'EdgeColor',colorBlack,'FaceAlpha',1);
set(hPlotPN2,'Box','off','TickDir','out','XLim',[-20,120],'XTick',[-20:20:100],'YLim',[0,yMaxPN],'fontSize',fontM);

% print('-painters','-r300','-dtiff',['plot_plfm_laserWidth_fig_',datestr(now,formatOut),'.tif']);
% print('-painters','-r300','-depsc',['plot_plfm_laserWidth_fig_',datestr(now,formatOut),'.ai']);
function plot_Track_sin_v50hz
% Draw & Save figures about track project
% TT*.mat files in the each folders will be loaded and plotted
% Author: Joonyeup Lee
% Version 3.0 (12/14/2016)

% Plot properties
lineColor = {[144, 164, 174]./255,... % Before stimulation
    [33 150 243]./ 255,... % During stimulation
    [38, 50, 56]./255}; % After stimulation

lineWth = [1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75 1 0.75];
fontS = 4; fontM = 5; fontL = 7; % font size large
lineS = 0.2; lineM = 0.5; lineL = 1; % line width large

colorBlue = [33 150 243] ./ 255;
colorLightBlue = [100 181 246] ./ 255;
colorLLightBlue = [187, 222, 251]./255;
colorRed = [237 50 52] ./ 255;
colorLightRed = [242 138 130] ./ 255;
colorLLightRed = [239 154 154] ./ 255;
colorGray = [189 189 189] ./ 255;
colorLightGray = [238, 238, 238] ./255;
colorDarkGray = [117, 117, 117] ./255;
colorYellow = [255 243 3] ./ 255;
colorLightYellow = [255 249 196] ./ 255;
colorBlack = [0, 0, 0];

markerS = 2.2; markerM = 4.4; markerL = 6.6; markerXL = 8.8;
tightInterval = [0.02 0.02]; wideInterval = [0.07 0.07];
width = 0.7;

paperSize = {[0 0 21.0 29.7]; % A4_portrait
             [0 0 29.7 21.0]; % A4_landscape
             [0 0 15.7 21.0]; % A4_half landscape
             [0 0 21.6 27.9]}; % Letter

matFile = mLoad;
nFile = length(matFile);
[cscTime, total_cscSample, cscList] = cscLoad;

for iFile = 1:nFile
    [cellDir, cellName, ~] = fileparts(matFile{iFile});
    cellDirSplit = regexp(cellDir,'\','split');
    cellFigName = strcat(cellDirSplit(end-1),'_',cellDirSplit(end),'_',cellName);
    cscTetrode = str2double(cellName(3)); % find a tetrode for csc analysis
    cscSample = total_cscSample{cscTetrode};
    
    % Arc property
    if ~isempty(strfind(cellDir,'DRun'));
        arc = linspace(pi,pi/2*3,170); % s6-s9
    else ~isempty(strfind(cellDir,'DRw'));
        arc = linspace(pi/6*5, pi/6*4,170);
    end
    
    cd(cellDir);
    load(matFile{iFile});
    load('Events.mat');
    
    nCol = 10;
    nRow = 11;
% Cell information    
    fHandle = figure('PaperUnits','centimeters','PaperPosition',paperSize{3});
    hText = axes('Position',axpt(1,1,1,1,axpt(nCol,nRow,1:4,1:2,[0.1 0.1 0.85 0.89],tightInterval),wideInterval));
    hold on;
    text(0,0.9,matFile{iFile}, 'FontSize',fontM, 'Interpreter','none','FontWeight','bold');
    text(0,0.8,['Mean firing rate (baseline): ',num2str(meanFR_base,3), ' Hz'], 'FontSize',fontM);
    text(0,0.7,['Mean firing rate (task): ',num2str(meanFR_task,3), ' Hz'], 'FontSize',fontM);
    text(0,0.6,['Spike width: ',num2str(spkwth,3),' us'], 'FontSize',fontM);
    text(0,0.5,['Half-valley width: ',num2str(hfvwth,3),' us'], 'FontSize',fontM);
    text(0,0.4,['Peak valley ratio: ',num2str(spkpvr,3)], 'FontSize',fontM);
    set(hText,'Visible','off');
    
% Waveform
    yLimWaveform = [min(spkwv(:)), max(spkwv(:))];
    for iCh = 1:4
        hWaveform(iCh) = axes('Position',axpt(4,1,iCh,1,axpt(nCol,nRow,3:5,2,[0.1 0.4 0.85 0.60],tightInterval),wideInterval));
        plot(spkwv(iCh,:), 'LineWidth', lineL, 'Color','k');
        if iCh == 4
            line([24 32], [yLimWaveform(2)-50 yLimWaveform(2)-50], 'Color','k', 'LineWidth', lineM);
            line([24 24],[yLimWaveform(2)-50 yLimWaveform(2)], 'Color','k', 'LineWidth',lineM);
        end
    end
    set(hWaveform, 'Visible', 'off','XLim',[1 32], 'YLim',yLimWaveform*1.05);
    
% Platform light intensity plot
    yLimlightBase = max([lightProbPlfm5mw; lightProbPlfm8mw; lightProbPlfm10mw])*1.1;
    if yLimlightBase < 10
        yLimlightBase = 20;
    end
    hIntensity = axes('Position',axpt(1,1,1,1,axpt(nCol,nRow,7,1,[0.15 0.25 0.80 0.70],tightInterval),wideInterval));
    hold on;
    plot([1,2,3],[lightProbPlfm5mw,lightProbPlfm8mw,lightProbPlfm10mw],'-o','Color',colorGray,'MarkerFaceColor',colorBlue,'MarkerEdgeColor','k','MarkerSize',markerM);
    hold on;
    ylabel('Spike counts','FontSize',fontM);
    xlabel('Power (mW)','FontSize',fontM);
    title('Platform laser intensity','FontSize',fontL,'FontWeight','bold');
    set(hIntensity,'XLim',[0,4],'YLim',[-5,yLimlightBase],'Box','off','TickDir','out','XTick',[1:3],'XTickLabel',{'5','8','10'},'FontSize',fontM);

% Response check: Platform
      % Activation or Inactivation?
    if isfield(lightTime,'Plfm2hz') && exist('xptPlfm2hz','var');
        lightDuration = 10;
        lightDurationColor = {colorLLightBlue, colorLightGray};
        testRangeChETA = 8; % ChETA light response test range (ex. 10ms)       
    end
    if isfield(lightTime,'Plfm2hz') && exist('xptPlfm2hz','var') && ~isempty(xptPlfm2hz)
        nBlue = length(lightTime.Plfm2hz)/3;
        winBlue = [min(pethtimePlfm2hz) max(pethtimePlfm2hz)];
% Raster
        hPlfmBlue(1) = axes('Position',axpt(2,8,1,1:2,axpt(nCol,nRow,1:4,2:5,[0.1 0.15 0.85 0.75],tightInterval),wideInterval));
        plot(xptPlfm2hz{1},yptPlfm2hz{1},'LineStyle','none','Marker','.','MarkerSize',markerS,'Color','k');
        set(hPlfmBlue(1),'XLim',winBlue,'XTick',[],'YLim',[0 nBlue], 'YTick', [0 nBlue], 'YTickLabel', {0, nBlue});
        ylabel('Trials','FontSize',fontM);
        title('Platform light response (2Hz)','FontSize',fontL,'FontWeight','bold');
% Psth
        hPlfmBlue(2) = axes('Position',axpt(2,8,1,3:4,axpt(nCol,nRow,1:4,2:5,[0.1 0.15 0.85 0.75],tightInterval),wideInterval));
        hold on;
        yLimBarBlue = ceil(max(pethPlfm2hz(:))*1.05+0.0001);
        bar(5, 1000, 'BarWidth', 10, 'LineStyle','none', 'FaceColor', colorLLightBlue);
        rectangle('Position', [0 yLimBarBlue*0.925, 10, yLimBarBlue*0.075], 'LineStyle', 'none', 'FaceColor', colorBlue);
        hBarBlue = bar(pethtimePlfm2hz, pethPlfm2hz, 'histc');
        text(sum(winBlue)*0.3,yLimBarBlue*0.9,['latency = ', num2str(latencyPlfm2hz1st,3)],'FontSize',fontM,'interpreter','none');
        %         text(sum(winBlue)*0.85,yLimBarBlue*0.9,['p_lat = ',num2str(pLatencyPlfm,3)],'FontSize',fontM,'interpreter','none');
        set(hBarBlue, 'FaceColor','k', 'EdgeAlpha',0);
        set(hPlfmBlue(2), 'XLim', winBlue, 'XTick', [winBlue(1) 0 winBlue(2)],'XTickLabel',{winBlue(1);0;num2str(winBlue(2))},'YLim', [0 yLimBarBlue], 'YTick', [0 yLimBarBlue], 'YTickLabel', {[], yLimBarBlue});
        xlabel('Time (ms)','FontSize',fontM);
        ylabel('Rate (Hz)', 'FontSize',fontM);
% Hazard function
        hPlfmBlue(3) = axes('Position',axpt(2,8,1,7:8,axpt(nCol,nRow,1:4,2:5,[0.1 0.17 0.85 0.75],tightInterval),wideInterval));
        hold on;
        ylimH = min([ceil(max([H1_Plfm2hz;H2_Plfm2hz])*1100+0.0001)/1000 1]);
        winHTag = [0 testRangeChETA];
        stairs(timeLR_Plfm2hz, H2_Plfm2hz, 'LineStyle',':','LineWidth',lineL,'Color','k');
        stairs(timeLR_Plfm2hz, H1_Plfm2hz,'LineStyle','-','LineWidth',lineL,'Color',colorBlue);
        text(diff(winHTag)*0.1,ylimH*0.9,['p = ',num2str(pLR_Plfm2hz,3)],'FontSize',fontM,'Interpreter','none');
        text(diff(winHTag)*0.1,ylimH*0.7,['calib: ',num2str(calibPlfm2hz,3),' ms'],'FontSize',fontM,'Interpreter','none');
        set(hPlfmBlue(3),'XLim',winHTag,'XTick',winHTag,'YLim',[0 ylimH], 'YTick', [0 ylimH], 'YTickLabel', {[], ylimH});
        xlabel('Time (ms)','FontSize',fontM);
        ylabel('H(t)','FontSize',fontM);
        title('LR test (platform 2Hz)','FontSize',fontL,'FontWeight','bold');
        set(hPlfmBlue,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM);
    end
    align_ylabel(hPlfmBlue)

% Response check: Plfm50hz
    if isfield(lightTime,'Plfm50hz') && ~isempty(lightTime.Plfm50hz) && exist('xptPlfm50hz','var')
        lightDuration = 10;
        lightDurationColor = {colorLLightBlue, colorLightGray};
        testRangeChETA = 8; % ChETA light response test range (ex. 10ms)       
    end
    if isfield(lightTime,'Plfm50hz') && ~isempty(lightTime.Plfm50hz)&& exist('xptPlfm50hz','var')
        nBlue = length(lightTime.Plfm50hz);
        winBlue = [min(pethtimePlfm50hz) max(pethtimePlfm50hz)];
% Raster
        hPlfmBlue(1) = axes('Position',axpt(2,8,2,1:2,axpt(nCol,nRow,1:4,2:5,[0.17 0.15 0.85 0.75],tightInterval),wideInterval));
        plot(xptPlfm50hz{1},yptPlfm50hz{1},'LineStyle','none','Marker','.','MarkerSize',markerS,'Color','k');
        set(hPlfmBlue(1),'XLim',winBlue,'XTick',[],'YLim',[0 nBlue], 'YTick', [0 nBlue], 'YTickLabel', {0, nBlue});
%         ylabel('Trials','FontSize',fontM);
        title('Platform light response (50hz)','FontSize',fontL,'FontWeight','bold');
% Psth
        hPlfmBlue(2) = axes('Position',axpt(2,8,2,3:4,axpt(nCol,nRow,1:4,2:5,[0.17 0.15 0.85 0.75],tightInterval),wideInterval));
        hold on;
        yLimBarBlue = ceil(max(pethPlfm50hz(:))*1.05+0.0001);
        bar(5, 1000, 'BarWidth', 10, 'LineStyle','none', 'FaceColor', colorLLightBlue);
        rectangle('Position', [0 yLimBarBlue*0.925, 10, yLimBarBlue*0.075], 'LineStyle', 'none', 'FaceColor', colorBlue);
        hBarBlue = bar(pethtimePlfm50hz, pethPlfm50hz, 'histc');
        if statDir_Plfm50hz == 1
            text(sum(winBlue)*0.3,yLimBarBlue*0.9,['latency = ', num2str(latencyPlfm50hz1st,3)],'FontSize',fontM,'interpreter','none');
        else
        end
        set(hBarBlue, 'FaceColor','k', 'EdgeAlpha',0);
        set(hPlfmBlue(2), 'XLim', winBlue, 'XTick', [winBlue(1) winBlue(2)],'XTickLabel',{winBlue(1);num2str(winBlue(2))},'YLim', [0 yLimBarBlue], 'YTick', [0 yLimBarBlue], 'YTickLabel', {[], yLimBarBlue});
        xlabel('Time (ms)','FontSize',fontM);
%         ylabel('Rate (Hz)', 'FontSize',fontM);
% Hazard function
        hPlfmBlue(3) = axes('Position',axpt(2,8,2,7:8,axpt(nCol,nRow,1:4,2:5,[0.17 0.17 0.85 0.75],tightInterval),wideInterval));
        hold on;
        ylimH = min([ceil(max([H1_Plfm50hz;H2_Plfm50hz])*1100+0.0001)/1000 1]);
        winHTag = [0 testRangeChETA];
        stairs(timeLR_Plfm50hz, H2_Plfm50hz, 'LineStyle',':','LineWidth',lineL,'Color','k');
        stairs(timeLR_Plfm50hz, H1_Plfm50hz,'LineStyle','-','LineWidth',lineL,'Color',colorBlue);
        text(diff(winHTag)*0.1,ylimH*0.9,['p = ',num2str(pLR_Plfm50hz,3)],'FontSize',fontM,'Interpreter','none');
        text(diff(winHTag)*0.1,ylimH*0.7,['calib: ',num2str(calibPlfm50hz,3),' ms'],'FontSize',fontM,'Interpreter','none');
        set(hPlfmBlue(3),'XLim',winHTag,'XTick',winHTag,'YLim',[0 ylimH], 'YTick', [0 ylimH], 'YTickLabel', {[], ylimH});
        xlabel('Time (ms)','FontSize',fontM);
%         ylabel('H(t)','FontSize',fontM);
        title('LR test (platform 50hz)','FontSize',fontL,'FontWeight','bold');
        set(hPlfmBlue,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM);
    end
    align_ylabel(hPlfmBlue)
    
% Response check: Track
    if isfield(lightTime,'Track50hz') && exist('xptTrackLight','var') && ~isempty(xptTrackLight)
        nBlue = length(lightTime.Track50hz);
        winBlue = [min(pethtimeTrackLight) max(pethtimeTrackLight)];
    % Raster
        hTrackBlue(1) = axes('Position',axpt(2,8,1,1:2,axpt(nCol,nRow,7:10,2:5,[0.1 0.15 0.82 0.75],tightInterval),wideInterval));
        plot(xptTrackLight{1},yptTrackLight{1},'LineStyle','none','Marker','.','MarkerSize',markerS,'Color','k');
        set(hTrackBlue(1),'XLim',winBlue,'XTick',[],'YLim',[0 nBlue], 'YTick', [0 nBlue], 'YTickLabel', {0, nBlue});
        ylabel('Trials','FontSize',fontM);
        title('Track light response (50hz)','FontSize',fontL,'FontWeight','bold');    
    % Psth
        hTrackBlue(2) = axes('Position',axpt(2,8,1,3:4,axpt(nCol,nRow,7:10,2:5,[0.1 0.15 0.82 0.75],tightInterval),wideInterval));
        hold on;
        yLimBarBlue = ceil(max(pethTrackLight(:))*1.05+0.0001);
        if ~isempty(strfind(cellDir,'DRun')) | ~isempty(strfind(cellDir,'DRw'))
            bar(5, 1000, 'BarWidth', 10,'LineStyle', 'none', 'FaceColor', colorLLightBlue);
            rectangle('Position', [0, yLimBarBlue*0.925, 10, yLimBarBlue*0.075], 'LineStyle', 'none', 'FaceColor', colorBlue);
        else
            bar(5, 1000, 'BarWidth', 10,'LineStyle', 'none', 'FaceColor', colorLightGray);
            rectangle('Position', [0, yLimBarBlue*0.925, 10, yLimBarBlue*0.075], 'LineStyle', 'none', 'FaceColor', colorGray);
        end
        hBarBlue = bar(pethtimeTrackLight, pethTrackLight, 'histc');
        if statDir_Track == 1;
            text(sum(winBlue)*0.3,yLimBarBlue*0.9,['latency = ', num2str(latencyTrack1st,3)],'FontSize',fontM,'interpreter','none');
%         text(sum(winBlue)*0.85,yLimBarBlue*0.9,['p_lat = ',num2str(pLatencyModu_first,3)],'FontSize',fontM,'interpreter','none');
        else
        end
        set(hBarBlue, 'FaceColor','k', 'EdgeAlpha',0);
        set(hTrackBlue(2), 'XLim', winBlue, 'XTick', [winBlue(1), winBlue(2)],'XTickLabel',{winBlue(1);num2str(winBlue(2))},...
            'YLim', [0 yLimBarBlue], 'YTick', [0 yLimBarBlue], 'YTickLabel', {[], yLimBarBlue});
        ylabel('Rate (Hz)','FontSize',fontM);
        xlabel('Time (ms)','FontSize',fontM);
    % Hazard function    
        hTrackBlue(3) = axes('Position',axpt(2,8,1,7:8,axpt(nCol,nRow,7:10,2:5,[0.1 0.17 0.82 0.75],tightInterval),wideInterval));
        hold on;
        ylimH = min([ceil(max([H1_Track;H2_Track])*1100+0.0001)/1000 1]);
        winHModu = [0 testRangeChETA];
        stairs(timeLR_Track, H2_Track, 'LineStyle',':','LineWidth',lineL,'Color','k');
        stairs(timeLR_Track, H1_Track,'LineStyle','-','LineWidth',lineL,'Color',colorBlue);
        text(diff(winHModu)*0.1,ylimH*0.9,['p = ',num2str(pLR_Track,3)],'FontSize',fontM,'Interpreter','none');
        text(diff(winHModu)*0.1,ylimH*0.7,['calib: ',num2str(calibTrack,3),' ms'],'FontSize',fontM,'Interpreter','none');
        xlabel('Time (ms)','FontSize',fontM);
        ylabel('H(t)','FontSize',fontM);
        title('Log-rank test (Track)','FontSize',fontL,'FontWeight','bold');
        set(hTrackBlue(3),'XLim',winHModu,'XTick',winHModu,'XTickLabel',{winHModu(1);num2str(winHModu(2))},'YLim',[0 ylimH], 'YTick', [0 ylimH], 'YTickLabel', {[], ylimH});
        set(hTrackBlue,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM);
    end
    align_ylabel(hTrackBlue)

% detonate spike plot
    hDetoSpk = axes('Position',axpt(4,8,3:4,1:4,axpt(nCol,nRow,7:10, 2:5,[0.16 0.15 0.80 0.75],tightInterval),wideInterval));
    plot(m_deto_spkTrack50hz*100,'-o','color',colorBlack,'MarkerFaceColor',colorBlue,'MarkerSize',markerM);
    xlabel('Light pulse','fontSize',fontM);
    ylabel('Spike probability, P (%)','fontSize',fontM);
    title('Detonate spike (Track 50hz)','fontSize',fontL,'fontWeight','bold');
    set(hDetoSpk,'Box','off','TickDir','out','XLim',[0,length(m_deto_spkTrack50hz)+1],'YLim',[0, max(m_deto_spkTrack50hz*100)*1.1+5],'fontSize',fontM);

% Light response spike probability
    hTextSpkProb = axes('Position',axpt(2,8,2,6:7,axpt(nCol,nRow,7:10,2:5,[0.1 0.15 0.80 0.75],tightInterval),wideInterval));
    text(0.2,0.9,'Spike probability (%)','fontSize',fontL,'fontWeight','bold');
    text(0.4,0.7,['Plfm 2Hz spike Prob. (%): ',num2str(round(lightProbPlfm_2hz*10)/10)],'fontSize',fontM);
    if ~isnan(lightProbPlfm_50hz)
        text(0.4,0.55,['Plfm 50hz spike Prob. (%): ',num2str(round(lightProbPlfm_50hz*10)/10)],'fontSize',fontM);
    end
    text(0.4,0.4,['Track 50hz spike Prob. (%): ',num2str(round(lightProbTrack_50hz*10)/10)],'fontSize',fontM);
    set(hTextSpkProb,'Box','off','visible','off');

% Light response spike probability 
    hStmzoneSpike = axes('Position',axpt(2,8,2,7:8,axpt(nCol,nRow,7:10,2:5,[0.1 0.15 0.80 0.75],tightInterval),wideInterval));
    text(0.2,0.7,'Stm zone spike number','fontSize',fontL,'fontWeight','bold');
    text(0.4,0.5,['Pre: ',num2str(stmzoneSpike(1))],'fontSize',fontM);
    text(0.4,0.35,['Stm: ',num2str(stmzoneSpike(2))],'fontSize',fontM);
    text(0.4,0.2,['Post: ',num2str(stmzoneSpike(3))],'fontSize',fontM);
    set(hStmzoneSpike,'Box','off','visible','off');

% Heat map
    totalmap = [pre_ratemap(1:90,40:130),stm_ratemap(1:90,40:130),post_ratemap(1:90,40:130)];
    hMap = axes('Position',axpt(1,1,1,1,axpt(nCol,nRow,1:5,7:8,[0.07 0.22 0.80 0.75]),tightInterval));
    hold on;
    hField = pcolor(totalmap);

    % Arc property
    if ~isempty(strfind(cellDir,'DRun')) | ~isempty(strfind(cellDir,'noRun'));
        arc = linspace(pi,pi/2*3,170); % s6-s9
    else ~isempty(strfind(cellDir,'DRw')) | ~isempty(strfind(cellDir,'noRw'));
        arc = linspace(pi/6*5, pi/6*4,170);
    end
    if ~isempty(lightTime.Track50hz)
        hold on;
        arc_r = 40;
        x = arc_r*cos(arc)+135;
        y = arc_r*sin(arc)+45;
        if exist('xptTrackLight','var') & (~isempty(strfind(cellDir,'DRw')) | ~isempty(strfind(cellDir,'DRun')));
            plot(x,y,'LineWidth',4,'color',colorBlue);
        else exist('xptTrackLight','var') & (~isempty(strfind(cellDir,'noRw')) | ~isempty(strfind(cellDir,'noRun')));
            plot(x,y,'LineWidth',4,'color',colorGray);                
        end
    end
    set(hField,'linestyle','none');
    set(hMap,'XLim',[0 270],'YLim',[0, 90],'visible','off');
    text(250,85,[num2str(floor(max(peakFR2D_SMtrack*10))/10), ' Hz'],'color','k','FontSize',fontM)
    text(28,3,'Pre-stm','color','k','FontSize',fontM);
    text(125,3,'Stm','color','k','FontSize',fontM)
    text(208,3,'Post-stm','color','k','FontSize',fontM)
    text(95,90,'Track heat map','FontSize',fontL,'FontWeight','bold');
    
     hPlfmMap(1) = axes('Position',axpt(1,4,1,1:2,axpt(nCol,nRow,5,6:7,[0.11 0.15 0.85 0.75],tightInterval),wideInterval));
     hFieldBase = pcolor(base_ratemap(30:70,50:110));
     text(40,38,[num2str(floor(peakFR2D_plfm*10)/10),' Hz'],'fontSize',fontM);
     text(17,0,'baseline','fontSize',fontM);
     
     hPlfmMap(2) = axes('Position',axpt(1,4,1,3:4,axpt(nCol,nRow,5,6:7,[0.11 0.15 0.85 0.75],tightInterval),wideInterval));
     hFieldTwo = pcolor(twohz_ratemap(30:70,50:110));
     text(40,38,[num2str(floor(peakFR2D_two*10)/10),' Hz'],'fontSize',fontM);
     text(17,0,'2hz stm','fontSize',fontM);

     set(hFieldBase,'linestyle','none');
     set(hFieldTwo,'linestyle','none');
     set(hPlfmMap,'Box','off','visible','off','XLim',[0,75],'YLim',[0,50]);
    
% Track light response raster plot (aligned on pseudo light - light - pseudo light)
    hTrackLight(1) = axes('Position',axpt(1,8,1,5:6,axpt(nCol,nRow,7:10,5:7,[0.10 0.11 0.85 0.85],tightInterval),wideInterval));
        plot([xptPsdPre{1}, xptTrackLight{1}, xptPsdPost{1}],[yptPsdPre{1}, (length(psdlightPre)+yptTrackLight{1}), (sum([length(psdlightPre),length(lightTime.Track50hz)])+yptPsdPost{1})],'Marker','.','MarkerSize',markerS,'LineStyle','none','Color','k');
        if ~isempty(strfind(cellDir,'DRun')) | ~isempty(strfind(cellDir,'DRw'))
            rec = rectangle('Position',[0 length(psdlightPre)+1, 10, length(lightTime.Track50hz)], 'LineStyle','none','FaceColor',lightDurationColor{1});
        end
        if ~isempty(strfind(cellDir,'noRun')) | ~isempty(strfind(cellDir,'noRw'))
            rec = rectangle('Position',[0 length(psdlightPre)+1, 10, length(lightTime.Track50hz)], 'LineStyle','none','FaceColor',lightDurationColor{2});
        end
        if pLR_Track_pre < 0.005
            text(105, sum([length(psdlightPre),length(lightTime.Track50hz),length(psdlightPost)])/8, '*','Color',colorRed,'fontSize',fontL);
        end
        if pLR_Track < 0.005
            text(105, sum([length(psdlightPre),length(lightTime.Track50hz),length(psdlightPost)])*3/8, '*','Color',colorRed,'fontSize',fontL);
        end
        if pLR_Track_post < 0.005
            text(105, sum([length(psdlightPre),length(lightTime.Track50hz),length(psdlightPost)])*6/8, '*','Color',colorRed,'fontSize',fontL);
        end
        uistack(rec,'bottom');
        ylabel('Light trial','FontSize',fontM);
        title('Track light response (Psd-L-Psd)','FontSize',fontL,'FontWeight','bold');  
    hTrackLight(2) = axes('Position',axpt(1,8,1,7:8,axpt(nCol,nRow,7:10,5:7,[0.10 0.11 0.85 0.85],tightInterval),wideInterval));
        ylimpeth = ceil(max([pethPsdPreConv,pethTrackLightConv,pethPsdPostConv])*1.1+0.0001);
        hold on;
        plot(pethtimePsdPre,pethPsdPreConv,'LineStyle','-','LineWidth',lineM,'Color',colorGray);
        plot(pethtimeTrackLight,pethTrackLightConv,'LineStyle','-','LineWidth',lineM,'Color',colorBlue);
        plot(pethtimePsdPost,pethPsdPostConv,'LineStyle','-','LineWidth',lineM,'Color',colorBlack);
        ylabel('Rate (Hz)','FontSize',fontM);
        xlabel('Time (ms)','FontSize',fontM);
        align_ylabel(hTrackLight);
    set(hTrackLight(1),'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[0, 20],'XTick',[],'YLim',[0, sum([length(psdlightPre),length(lightTime.Track50hz),length(psdlightPost)])],'YTick',[0,length(psdlightPre),sum([length(psdlightPre),length(lightTime.Track50hz)]),sum([length(psdlightPre),length(lightTime.Track50hz),length(psdlightPost)])]);
    set(hTrackLight(2),'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[0, 20],'XTick',[0,20],'YLim',[0, max(ylimpeth)]);
    
if ~isempty(strfind(cellDir,'DRun')) | ~isempty(strfind(cellDir,'noRun'))
    iSensor = 6; % Light on sensor
    lightDur = 1; % Putative light duration
end
if ~isempty(strfind(cellDir,'DRw')) | ~isempty(strfind(cellDir,'noRw'))
    iSensor = 10; % Light on sensor
    lightDur = 4; % Putative light duration
end

% Spatial raster plot
    if ~isempty(strfind(cellDir,'DRun')) | ~isempty(strfind(cellDir,'DRw')) % Light session
        hSRaster(1) = axes('Position',axpt(1,2,1,1,axpt(nCol,nRow,1:4,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        plot([xptSpatial{:}],[yptSpatial{:}],'Marker','.','MarkerSize',markerS,'LineStyle','none','Color','k');
        rec = rectangle('Position',[lightLoc(1), 31, lightLoc(2)-lightLoc(1), 30], 'LineStyle','none','FaceColor',lightDurationColor{1});
        ylabel('Trial','FontSize',fontM);
        title(['Spatial Raster & PETH at ',fields{iSensor}],'FontSize',fontL,'FontWeight','bold');
        hSPsth(1) = axes('Position',axpt(1,2,1,2,axpt(nCol,nRow,1:4,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        ylimpethSpatial = ceil(max(pethconvSpatial(pethconvSpatial<inf))*1.1+0.0001);
        pRw(1) = patch([rewardLoc(1)+2, rewardLoc(1)+6, rewardLoc(1)+6, rewardLoc(1)+2],[0, 0, ylimpethSpatial, ylimpethSpatial],colorLightRed);
        hold on;
        pRw(2) = patch([rewardLoc(2)+2.5, rewardLoc(2)+6.5, rewardLoc(2)+6.5, rewardLoc(2)+2.5],[0, 0, ylimpethSpatial, ylimpethSpatial],colorLightRed);
        hold on;
        for iType = 1:3
            plot(pethSpatial(1:124),pethconvSpatial(iType,:),'LineStyle','-','LineWidth',lineM,'Color',lineColor{iType})
        end
        ylabel('Rate (Hz)','FontSize',fontM);
        xlabel('Position (cm)','FontSize',fontM);
        uistack(rec,'bottom');
% Temporal raster plot
        hTRaster(1) = axes('Position',axpt(1,2,1,1,axpt(nCol,nRow,7:10,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        plot([xpt.(fields{iSensor}){:}],[ypt.(fields{iSensor}){:}],'Marker','.','MarkerSize',markerS,'LineStyle','none','Color','k');
        rec = rectangle('Position',[0 31 lightDur 30], 'LineStyle','none','FaceColor',lightDurationColor{1});
        ylabel('Trial','FontSize',fontM);
        title(['Temporal Raster & PETH at ',fields{iSensor}],'FontSize',fontL,'FontWeight','bold');
        hTPsth(1) = axes('Position',axpt(1,2,1,2,axpt(nCol,nRow,7:10,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        ylimpethTemporal = ceil(max(pethconv.(fields{iSensor})(:))*1.1+0.0001);
        hold on;
        for iType = 1:3
            plot(pethtime.(fields{iSensor}),pethconv.(fields{iSensor})(iType,:),'LineStyle','-','LineWidth',lineM,'Color',lineColor{iType})
        end
        ylabel('Rate (Hz)','FontSize',fontM);
        xlabel('Time (sec)','FontSize',fontM);
        uistack(rec,'bottom');
    end

% Spatial rastser plot
    if ~isempty(strfind(cellDir,'noRun')) | ~isempty(strfind(cellDir,'noRw')) % No light session
        hSRaster(1) = axes('Position',axpt(1,2,1,1,axpt(nCol,nRow,1:4,8:9,[0.1 0.10 0.85 0.75],tightInterval),wideInterval));
        hold on;
        plot([xptSpatial{:}],[yptSpatial{:}],'Marker','.','MarkerSize',markerS,'LineStyle','none','Color','k');
        rec = rectangle('Position',[lightLoc(1), 31, lightLoc(2)-lightLoc(1), 30], 'LineStyle','none','FaceColor',lightDurationColor{2});
        ylabel('Trial','FontSize',fontM);
        title(['Spatial Raster & PETH at ',fields{iSensor}],'FontSize',fontL,'FontWeight','bold');
        hSPsth(1) = axes('Position',axpt(1,2,1,2,axpt(nCol,nRow,1:4,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        ylimpethSpatial = ceil(max(pethconvSpatial(pethconvSpatial<inf))*1.1+0.0001);
        pRw(1) = patch([rewardLoc(1)+2, rewardLoc(1)+6, rewardLoc(1)+6, rewardLoc(1)+2],[0, 0, ylimpethSpatial, ylimpethSpatial],colorLightRed);
        hold on;
        pRw(2) = patch([rewardLoc(2)+2.5, rewardLoc(2)+6.5, rewardLoc(2)+6.5, rewardLoc(2)+2.5],[0, 0, ylimpethSpatial, ylimpethSpatial],colorLightRed);
        hold on;
        for iType = 1:3
            plot(pethSpatial(1:124),pethconvSpatial(iType,:),'LineStyle','-','LineWidth',lineM,'Color',lineColor{iType})
        end
        ylabel('Rate (Hz)','FontSize',fontM);
        xlabel('Position (cm)','FontSize',fontM);
        uistack(rec,'bottom');
% Temporal raster plot
        hTRaster(1) = axes('Position',axpt(1,2,1,1,axpt(nCol,nRow,7:10,8:9,[0.10 0.10 0.85 0.75],tightInterval),wideInterval));
        hold on;
        plot([xpt.(fields{iSensor}){:}],[ypt.(fields{iSensor}){:}],'Marker','.','MarkerSize',markerS,'LineStyle','none','Color','k');
        rec = rectangle('Position',[0 31 lightDur 30], 'LineStyle','none','FaceColor',lightDurationColor{2});
        ylabel('Trial','FontSize',fontM);
        title(['Temporal Raster & PETH at ',fields{iSensor}],'FontSize',fontL,'FontWeight','bold');
        hTPsth(1) = axes('Position',axpt(1,2,1,2,axpt(nCol,nRow,7:10,8:9,[0.1 0.10 0.85 0.75],tightInterval),wideInterval));
        ylimpethTemporal = ceil(max(pethconv.(fields{iSensor})(:))*1.1+0.0001);
        hold on;
        for iType = 1:3
            plot(pethtime.(fields{iSensor}),pethconv.(fields{iSensor})(iType,:),'LineStyle','-','LineWidth',lineM,'Color',lineColor{iType})
        end
        uistack(rec,'bottom');
    end
    align_ylabel([hSRaster,hSPsth]);
    align_ylabel([hTRaster,hTPsth]);
    set(hSRaster,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[0 124],'XTick',[],'YLim',[0, 90],'YTick',[0:30:90]);
    set(hTRaster,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[-5 5],'XTick',[],'YLim',[0, 90],'YTick',[0:30:90]);
    set(hSPsth,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[0, 124],'XTick',[0:10:120],'YLim',[0, ylimpethSpatial],'YTick',[0,ylimpethSpatial]);
    set(hTPsth,'Box','off','TickDir','out','LineWidth',lineS,'FontSize',fontM,'XLim',[-5, 5],'XTick',[-5:5],'YLim',[0, ylimpethTemporal],'YTick',[0,ylimpethTemporal]);
    set(pRw,'LineStyle','none','FaceAlpha',0.2);
    
    hLine = axes('Position',axpt(1,2,1,1:2,axpt(nCol,nRow,5:6,8,[0.1 0.10 0.85 0.75],tightInterval),wideInterval));
        text(0.2,1.00,'-: Pre','FontSize',fontL,'Color',lineColor{1},'fontWeight','Bold');    
        text(0.2,0.75,'-: Stm','FontSize',fontL,'Color',lineColor{2},'fontWeight','Bold');
        text(0.2,0.50,'-: Post','FontSize',fontL,'Color',lineColor{3},'fontWeight','Bold');
        text(0.1,0.25,' : Reward','FontSize',fontL,'Color',colorLightRed,'fontWeight','Bold');
    set(hLine,'Box','off','visible','off');

% LFP analysis (Plfm 2hz)
    lightPlfm2hz = lightTime.Plfm2hz(201:400);
    lapPlfm2hzIdx = 1:10:200; % find start light of each lap
    nLabLightPlfm2hz = 10;
    lightOnPlfm2hz = lightPlfm2hz(lapPlfm2hzIdx);
    
    winPlfm2hz = [-300, 5200]; % unit: msec
    sFreq = 2000; % 2000 samples / sec
    win_csc2hz = winPlfm2hz/1000*sFreq;
    xLimCSC = [-300 1100];
    xpt_csc2hz = winPlfm2hz(1):0.5:winPlfm2hz(2);

    for iCycle = 1:20
        cscIdxPlfm2hz = find(cscTime{1}>lightOnPlfm2hz(iCycle),1,'first');
        cscPlfm2hz(:,iCycle) = cscSample((cscIdxPlfm2hz+win_csc2hz(1)):cscIdxPlfm2hz+win_csc2hz(2));
    end
    m_cscPlfm2hz = mean(cscPlfm2hz,2);
    yLimCSC_Plfm2hz = [min(m_cscPlfm2hz(find(xpt_csc2hz==xLimCSC(1)):find(xpt_csc2hz==xLimCSC(2)))), max(m_cscPlfm2hz(find(xpt_csc2hz==xLimCSC(1)):find(xpt_csc2hz==xLimCSC(2))))]*1.1;

% LFP analysis (Track 50hz)
    lightTrack50hz = lightTime.Track50hz;
    lapTrack50hzIdx = [1;(find(diff(lightTrack50hz)>1000)+1)]; % find start light of each lap
    nLabLightTrack50hz = min(diff(lapTrack50hzIdx));
    lightOnTrack50hz = lightTrack50hz(lapTrack50hzIdx);
    
    winTrack50hz = [-500,3000];
    win_csc50hz = winTrack50hz/1000*sFreq;
    xpt_csc50hz = winTrack50hz(1):0.5:winTrack50hz(2);
    for iCycle = 1:30
        cscIdxTrack50hz = find(cscTime{1}>lightOnTrack50hz(iCycle),1,'first');
        cscTrack50hz(:,iCycle) = cscSample((cscIdxTrack50hz+win_csc50hz(1)):cscIdxTrack50hz+win_csc50hz(2));
    end
    m_cscTrack50hz = mean(cscTrack50hz,2);
    yLimCSC_Track50hz = [min(m_cscTrack50hz(find(xpt_csc50hz==xLimCSC(1)):find(xpt_csc50hz==xLimCSC(2)))), max(m_cscTrack50hz(find(xpt_csc50hz==xLimCSC(1)):find(xpt_csc50hz==xLimCSC(2))))]*1.1;
    
    hLFP(1) = axes('Position',axpt(6,6,1:6,1:2,axpt(nCol,nRow,1:nCol,10:11,[0.10 0.05 0.85 0.85],tightInterval),wideInterval));
    for iLight = 1:nLabLightPlfm2hz
        hLpatch(1) = patch([500*(iLight-1), 500*(iLight-1)+10, 500*(iLight-1)+10, 500*(iLight-1)],[yLimCSC_Plfm2hz(1)*0.8, yLimCSC_Plfm2hz(1)*0.8, yLimCSC_Plfm2hz(2), yLimCSC_Plfm2hz(2)],colorBlue,'EdgeColor','none');
        hold on;
    end
    plot(xpt_csc2hz,m_cscPlfm2hz,'color',colorBlack,'lineWidth',1);
    line([xLimCSC(2)*0.97 xLimCSC(2)*0.97+20],[yLimCSC_Plfm2hz(2)*0.7, yLimCSC_Plfm2hz(2)*0.7],'color',colorBlack);
    line([xLimCSC(2)*0.97 xLimCSC(2)*0.97],[yLimCSC_Plfm2hz(2)*0.7, yLimCSC_Plfm2hz(2)*0.7+0.2],'color',colorBlack);
    ylabel('LFP (Plfm2hz)','fontSize',fontM);
    text(xLimCSC(1), yLimCSC_Plfm2hz(2),'LFP (Plfm 2hz)','fontSize',fontM);
    text(xLimCSC(2)*0.91,yLimCSC_Plfm2hz(2)*0.7+0.1,'0.2 uVolt','fontSize',fontS);
    text(xLimCSC(2)*0.97,yLimCSC_Plfm2hz(2)*0.60,'20 ms','fontSize',fontS);
        
    hLFP(2) = axes('Position',axpt(6,6,1:6,5:6,axpt(nCol,nRow,1:nCol,10:11,[0.10 0.05 0.85 0.85],tightInterval),wideInterval));
    for iLight = 1:nLabLightTrack50hz
        hLpatch(2) = patch([125*(iLight-1), 125*(iLight-1)+10, 125*(iLight-1)+10, 125*(iLight-1)],[yLimCSC_Track50hz(1)*0.8, yLimCSC_Track50hz(1)*0.8, yLimCSC_Track50hz(2), yLimCSC_Track50hz(2)],colorBlue,'EdgeColor','none');
        hold on;
    end
    plot(xpt_csc50hz,m_cscTrack50hz,'color',colorBlack,'lineWidth',1);
    line([xLimCSC(2)*0.97 xLimCSC(2)*0.97+20],[yLimCSC_Track50hz(2)*0.7, yLimCSC_Track50hz(2)*0.7],'color',colorBlack);
    line([xLimCSC(2)*0.97 xLimCSC(2)*0.97],[yLimCSC_Track50hz(2)*0.7, yLimCSC_Track50hz(2)*0.7+0.2],'color',colorBlack);
    ylabel('LFP (Track50hz)','fontSize',fontM);
    text(xLimCSC(1), yLimCSC_Track50hz(2),'LFP (Track 50hz)','fontSize',fontM);
    
    set(hLFP(1),'Xlim',xLimCSC,'XTick',[],'YLim',yLimCSC_Plfm2hz,'fontSize',fontM);
    set(hLFP(2),'Xlim',xLimCSC,'XTick',[],'YLim',yLimCSC_Track50hz,'fontSize',fontM);

% LFP analysis (Plfm 50hz)
    if isfield(lightTime,'Plfm50hz') && ~isempty(lightTime.Plfm50hz) && exist('xptPlfm50hz','var')
        lightPlfm50hz = lightTime.Plfm50hz;
        lapPlfm50hzIdx = [1;(find(diff(lightPlfm50hz)>1000)+1)]; % find start light of each lap
        nLabLightPlfm50hz = min(diff(lapPlfm50hzIdx));
        lightOnPlfm50hz = lightPlfm50hz(lapPlfm50hzIdx);

        for iCycle = 1:30
            cscIdxPlfm50hz = find(cscTime{1}>lightOnPlfm50hz(iCycle),1,'first');
            cscPlfm50hz(:,iCycle) = cscSample((cscIdxPlfm50hz+win_csc50hz(1)):cscIdxPlfm50hz+win_csc50hz(2));
        end
        m_cscPlfm50hz = mean(cscPlfm50hz,2);
        yLimCSC_Plfm50hz = [min(m_cscPlfm50hz(find(xpt_csc50hz==xLimCSC(1)):find(xpt_csc50hz==xLimCSC(2)))), max(m_cscPlfm50hz(find(xpt_csc50hz==xLimCSC(1)):find(xpt_csc50hz==xLimCSC(2))))]*1.1;
        xpt_csc50hz = winTrack50hz(1):0.5:winTrack50hz(2);

        hLFP(3) = axes('Position',axpt(6,6,1:6,3:4,axpt(nCol,nRow,1:nCol,10:11,[0.10 0.05 0.85 0.85],tightInterval),wideInterval));
        for iLight = 1:nLabLightPlfm50hz
            hLpatch(3) = patch([125*(iLight-1), 125*(iLight-1)+10, 125*(iLight-1)+10, 125*(iLight-1)],[yLimCSC_Plfm50hz(1)*0.8 yLimCSC_Plfm50hz(1)*0.8 yLimCSC_Plfm50hz(2), yLimCSC_Plfm50hz(2)],colorBlue,'EdgeColor','none');
            hold on;
        end
        plot(xpt_csc50hz,m_cscPlfm50hz,'color',colorBlack,'lineWidth',1);
        line([xLimCSC(2)*0.97 xLimCSC(2)*0.97+20],[yLimCSC_Plfm50hz(2)*0.7, yLimCSC_Plfm50hz(2)*0.7],'color',colorBlack);
        line([xLimCSC(2)*0.97 xLimCSC(2)*0.97],[yLimCSC_Plfm50hz(2)*0.7, yLimCSC_Plfm50hz(2)*0.7+0.2],'color',colorBlack);
        ylabel('LFP (Plfm50hz)','fontSize',fontM);
        text(xLimCSC(1), yLimCSC_Plfm50hz(2),'LFP (Plfm 50hz)','fontSize',fontM);
        set(hLFP(3),'Xlim',xLimCSC,'XTick',[],'YLim',yLimCSC_Plfm50hz,'fontSize',fontM);
    end
    set(hLFP,'Box','off','TickDir','out');

% Spectrogram (aligned on sensor onset)
%     load(['CSC','.mat']);
%     hSpectro(1) = axes('Position',axpt(6,6,1:5,1:2,axpt(nCol,nRow,1:3,10:11,[0.1 0.04 0.8 0.80],tightInterval),wideInterval));
%         hSpec(1) = pcolor(timeSensor,freqSensor,psdSensor_pre/(max(psdSensor_stm(:))));
%         text(0.3, 25,'Pre','fontSize',fontM,'Color',[1,1,1])
%         title(['Spectrogram on sensor: ',num2str(iSensor1)],'fontSize',fontL,'FontWeight','bold');
%     hSpectro(2) = axes('Position',axpt(6,6,1:5,3:4,axpt(nCol,nRow,1:3,10:11,[0.1 0.04 0.8 0.80],tightInterval),wideInterval));
%         hSpec(2) = pcolor(timeSensor,freqSensor,psdSensor_stm/(max(psdSensor_stm(:))));
%         text(0.3, 25,'Stm','fontSize',fontM,'Color',[1,1,1])
%         ylabel('Freq (Hz)','fontSize',fontM);
%     hSpectro(3) = axes('Position',axpt(6,6,1:5,5:6,axpt(nCol,nRow,1:3,10:11,[0.1 0.04 0.8 0.80],tightInterval),wideInterval));
%         hSpec(3) = pcolor(timeSensor,freqSensor,psdSensor_post/(max(psdSensor_stm(:))));
%         text(0.3, 25,'Post','fontSize',fontM,'Color',[1,1,1])
%         xlabel('Time (ms)','fontSize',fontM);
%         cBar = colorbar;
%     set(hSpec,'EdgeColor','none');
%     set(hSpectro(1:3),'Box','off','TickDir','out','YLim',[0,30],'YTick',[0:30:90],'XLim',[0.25,1.75],'XTick',1,'XTickLabel',[],'FontSize',fontM);
%     set(hSpectro(3),'Box','off','TickDir','out','YLim',[0,30],'YTick',[0:30:90],'XTick',[0.25,1,1.75],'XTickLabel',{'-750','0','750'},'FontSize',fontM);
%     set(cBar,'Position',axpt(12,6,11,1:2,axpt(nCol,nRow,1:3,10:11,[0.10 0.04 0.80 0.85],tightInterval)));    
% % Spectrogram (aligned on light onset)
%     hSpectroPlfmLight(1) = axes('Position',axpt(6,6,1:5,1:2,axpt(nCol,nRow,4:6,10:11,[0.10 0.04 0.80 0.80],tightInterval),wideInterval));
%         hPlfmLight(1) = pcolor(timeLightPlfm2hz5mw,freqLightPlfm2hz5mw,psdLightPlfm2hz5mw/max(psdLightPlfm2hz8mw(:)));
%         text(0.3,25,'5 mW','fontSize',fontM,'Color',[1,1,1]);
%         title('Spectrogram on Platform','fontSize',fontL,'FontWeight','bold')        
%     hSpectroPlfmLight(2) = axes('Position',axpt(6,6,1:5,3:4,axpt(nCol,nRow,4:6,10:11,[0.10 0.04 0.80 0.80],tightInterval),wideInterval));
%         hPlfmLight(2) = pcolor(timeLightPlfm2hz8mw,freqLightPlfm2hz8mw,psdLightPlfm2hz8mw/max(psdLightPlfm2hz8mw(:)));
%         text(0.3,25,'8 mW','fontSize',fontM,'Color',[1,1,1]);
%     hSpectroPlfmLight(3) = axes('Position',axpt(6,6,1:5,5:6,axpt(nCol,nRow,4:6,10:11,[0.10 0.04 0.80 0.80],tightInterval),wideInterval));
%         hPlfmLight(3) = pcolor(timeLightPlfm2hz10mw,freqLightPlfm2hz10mw,psdLightPlfm2hz10mw/max(psdLightPlfm2hz8mw(:)));
%         text(0.3, 25,'10 mW','fontSize',fontM,'Color',[1,1,1]);
%         xlabel('Time (ms)','fontSize',fontM);
%     set(hPlfmLight,'EdgeColor','none');
%     set(hSpectroPlfmLight(1:3),'Box','off','TickDir','out','YLim',[0,30],'YTick',[],'XLim',[0.25,1.75],'XTick',1,'XTickLabel',[],'FontSize',fontM);
%     set(hSpectroPlfmLight(3),'YTick',[0:30:90],'YTickLabel',[],'XTick',[0.25,1,1.75],'XTickLabel',{'-750','0','750'},'FontSize',fontM);
% 
% % Powerspectrum
%     yLim = [0, max([rPwSensorTheta_pre,rPwSensorTheta_stm,rPwSensorTheta_post,rPwSensorLGamma_pre,rPwSensorLGamma_stm,rPwSensorLGamma_post,rPwSensorHGamma_pre,rPwSensorHGamma_stm,rPwSensorHGamma_post])*1.2];
%     hSpectrum(1) = axes('Position',axpt(8,6,2:3,2:6,axpt(nCol,nRow,7:10,10:11,[0.10 0.05 0.90 0.80],tightInterval),wideInterval));
%         hSpecTheta(1) = bar(1,rPwSensorTheta_pre,width,'FaceColor',colorDarkGray,'EdgeColor','none');
%         hold on;
%         hSpecTheta(2) = bar(2,rPwSensorTheta_stm,width,'FaceColor',colorLightBlue,'EdgeColor','none');
%         hold on;
%         hSpecTheta(3) = bar(3,rPwSensorTheta_post,width,'FaceColor',colorBlack,'EdgeColor','none');
%         text(1,yLim(2)*0.95,'Theta','fontSize',fontM);
%         ylabel('Relative Power','fontSize',fontM);
%     hSpectrum(2) = axes('Position',axpt(8,6,4:5,2:6,axpt(nCol,nRow,7:10,10:11,[0.10 0.05 0.90 0.80],tightInterval),wideInterval));
%         hSpecTheta(1) = bar(1,rPwSensorLGamma_pre,width,'FaceColor',colorDarkGray,'EdgeColor','none');
%         hold on;
%         hSpecTheta(2) = bar(2,rPwSensorLGamma_stm,width,'FaceColor',colorLightBlue,'EdgeColor','none');
%         hold on;
%         hSpecTheta(3) = bar(3,rPwSensorLGamma_post,width,'FaceColor',colorBlack,'EdgeColor','none');
%         text(0.5,yLim(2)*0.95,'L-Gam','fontSize',fontM);
%         title('Relative PowerSpec on the track','fontSize',fontL,'fontWeight','bold')    
%     hSpectrum(3) = axes('Position',axpt(8,6,6:7,2:6,axpt(nCol,nRow,7:10,10:11,[0.10 0.05 0.90 0.80],tightInterval),wideInterval));
%         hSpecTheta(1) = bar(1,rPwSensorHGamma_pre,width,'FaceColor',colorDarkGray,'EdgeColor','none');
%         hold on;
%         hSpecTheta(2) = bar(2,rPwSensorHGamma_stm,width,'FaceColor',colorLightBlue,'EdgeColor','none');
%         hold on;
%         hSpecTheta(3) = bar(3,rPwSensorHGamma_post,width,'FaceColor',colorBlack,'EdgeColor','none');
%         text(0.5,yLim(2)*0.95,'H-Gam','fontSize',fontM);
%         
%     set(hSpectrum,'Box','off','TickDir','out','YLim',yLim,'YTick',[],'XLim',[0,4],'XTick',[1,2,3],'XTickLabel',{'Pr','St','  Po'},'fontSize',fontM,'LineWidth',lineM)
%     set(hSpectrum(1),'Box','off','TickDir','out','YLim',yLim,'YTick',[yLim(1),yLim(2)],'YTickLabel',{'0';sprintf('%.2E',yLim(2))},'XLim',[0,4],'XTick',[1,2,3],'XTickLabel',{'Pr','St','  Po'},'fontSize',fontM)

% Cell ID
    hID = axes('Position',axpt(1,1,1,1,axpt(nCol,nRow,10,1,[0.11 0.18 0.80 0.80],tightInterval),wideInterval));
    text(1, 1, ['Cell ID: ',num2str(iFile)],'FontSize',fontL,'fontWeight','bold');
    set(hID,'visible','off');
    
    print('-painters','-r300',[cellFigName{1},'.tif'],'-dtiff');
%     print(-painters','-r300',[cellFigName{1},'.ai'],'-depsc');
    close;
end
fclose('all');
end
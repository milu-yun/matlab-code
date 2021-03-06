%% Directory setup
rtPath = 'D:\Dropbox\SNL\P2_Track';
startingDir = {'D:\Projects\Track_160726-1_Rbp48pulse';
               'D:\Projects\Track_160726-2_Rbp50pulse';
               'D:\Projects\Track_160824-2_Rbp58pulse';
               'D:\Projects\Track_160824-5_Rbp60pulse';
               'D:\Projects\Track_161130-3_Rbp64pulse';
               'D:\Projects\Track_161130-5_Rbp66pulse';
               'D:\Projects\Track_161130-7_Rbp68pulse';
               'D:\Projects\Track_170119-1_Rbp70pulse';
               'D:\Projects\Track_170109-2_Rbp72pulse';
               'D:\Projects\Track_170115-4_Rbp74pulse'};

matFile = [];
tFile = [];
nDir = size(startingDir,1);
for iDir = 1:nDir
%% Mat file
%     tempmatFile = FindFiles('tt*.mat','StartingDirectory',startingDir{iDir},'CheckSubdirs',1);
%     matFile = [matFile; tempmatFile];
%% t-file
     temptFile = FindFiles('TT*.t','StartingDirectory',startingDir{iDir},'CheckSubdirs',1);
     tFile = [tFile;temptFile]; 
%% Event file
%     tempEventFile = FindFiles('Events.nev','StartingDirectory',startingDir{iDir},'CheckSubdirs',1); % Modifying event files
%     matFile = [matFile;tempEventFile];
end

% nFile = length(matFile);
% for ifile = 1:nFile
%     [cellpath, ~, ~] = fileparts(matFile{ifile});
%     filePath{ifile,1} = cellpath;
% end

nFile = length(tFile);
for ifile = 1:nFile
    [cellpath, ~, ~] = fileparts(tFile{ifile});
    filePath{ifile,1} = cellpath;
end

filePath = unique(filePath);
nPath = length(filePath);

%% Swiping contents
for iPath = 1:nPath
    cd(filePath{iPath});
    
%     event2mat_pulse;

%     analysis_laserWidthTest;
%     analysis_respstatWidthTest;
%     waveform;
    
%     plot_LightPulse;

    fclose('all');
    close all;
end

cd(rtPath);
disp('### Done! ###');
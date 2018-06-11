%%% Run Experiment Omission AV %%%

% Clear the workspace and the screen
close all;
clearvars;

% Where to save data
saveplace = 'C:\Users\Liesa\Desktop\Marlene_script\Meins\Data';

% Participant info
Demo = input(['Demo?, 1-Yes: , 2-No:'])

VPno = input(['Please enter subject numer:'])


if Demo ~= 1
    CheckEEG = input(['Is EEG On? '])
end

if Demo == 1
    Modality = 3;
else
    Modality = input(['1-Auditory:, 2-Visual:, 3-Bimodal: '])
end

%% General settings
ITI = 1.5;
%%% window configurations
Color.back = [0 0 0];
Color.fix = [255 255 255];
Color.text = [255 255 255];
Color.gray = [127 127 127];

%%% Stimuli configuration
sound.dur = 1.25;
sound.freq = [200 600];
sound.fs = 44100;
sound.volum = 1;
sound.nrchannels = 2;

visual.dur = 0.5;
visual.pos = [480 300; 
            1440 300;
            480 900;
            1440 900];
visual.rSize = 150;
visual.cycles = 5;

%% Trial parameter
% Auditory freq. || visual position || omission || catch-trial || trigger


TrialParams = [1 0 0 0 100; % Auditory only
    2 0 0 0 200;
    1 0 0 1 1001;
    2 0 0 1 2001;
    % Visual only
    0 1 0 0 10;
    0 2 0 0 20;
    0 3 0 1 30;
    0 4 0 1 40;
    % bimodal
    1 1 0 0 110;
    1 2 0 0 120;
    1 3 0 0 130;
    1 4 0 0 140;
    2 1 0 0 210;
    2 2 0 0 220;
    2 3 0 0 230;
    2 4 0 0 240;
    %omission
    1 0 1 0 101;
    2 0 1 0 201];

%% Select standardposition

% position of gratings odd/even VPno
if mod(VPno,2) == 0
    standardposition = visual.pos([1,4],:,:);
    rareposition = visual.pos([2,3],:,:);
else
    standardposition = visual.pos([2,3],:,:);
    rareposition = visual.pos([1,4],:,:);
end

if mod(VPno, 4) == 3 || 0
    sound.freq = [600 200];
end


% Number of trials for each condition and block (4 blocks for uniV and
% bimodal, 2 for uniA)

Nreps.uni = 50;      % 2/4 time (A1,2 or V1,2,3,4)
Nreps.stan = 105;     % 2 times (A1V1, A2V2)
Nreps.target = 6;    % 6 times (A1V2,3,4 A2V1,3,4)
Nreps.omis = 27;      % 2 times (A1V- A2V-)
Nreps.demo = 10;      % 10 times (possible stimuli combis in the experiment)

% nBlocks
if Demo ~= 1 && Modality ~= 2
    nBlocks = 4;
elseif Demo ~= 1 && Modality == 1
    nBlocks = 2;
else
    nBlocks = 2; %%%%%HIER NOCHMAL NACHDENKEN WEGEN DEMO
end

switch Modality
    case 1 %auditory only
        Aud = 1;
        Vis = 0;
        Filename = ('AuditoryOnly');
    case 2 %visual only
        Aud = 0;
        Vis = 1;
        Filename = ('VisualOnly');
    case 3 %bimodal
        Aud = 1;
        Vis = 1;
        visual.pos = [standardposition; rareposition];
        Filename = ('Bimodal');
end



% Generating parameter matrix
TrialParamsRand = [];


if Demo ~= 1 && Modality == 1
    TrialParamsRand = repmat(TrialParams(1:4,:),Nreps.uni,1);
elseif Demo ~= 1 && Modality == 2
    TrialParamsRand = repmat(TrialParams(5:8,:), Nreps.uni,1);
elseif Demo ~= 1 && Modality == 3
    TrialParamsRand = [repmat(TrialParams([9, 14],:), Nreps.stan,1);...
        repmat(TrialParams([10:13,15:16],:),Nreps.target,1);...
        repmat(TrialParams(17:18,:), Nreps.omis,1)];
elseif Demo == 1
    TrialParamsRand = [repmat(TrialParams(9:18,:), Nreps.demo,1)];
end
       
% randomize the order of trials
TrialParamsRand = TrialParamsRand(randperm(size(TrialParamsRand,1)),:);


% Set the screen number to the external secondary monitor if there is one
% connected
mainwindow = max(Screen('Screens'));


% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Open the screen + screen variables
[window, windowRect] = PsychImaging('OpenWindow', mainwindow, Color.back);

ifi = Screen('GetFlipInterval', window);

screenWidth = windowRect(3) - windowRect(1);
screenHeight = windowRect(4) - windowRect(2);
Screen(window,'TextSize',30);

% Initialize sound
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], [], 0, sound.fs, sound.nrchannels);


if Demo == 1
    DrawFormattedText(window, ...
        'Übung',...
        'center', 'center',Color.text);
else
    DrawFormattedText(window, ...
        'Experiment',...
        'center', 'center',Color.text);
end         
Screen('Flip',window);


% Initializing of Trial
Ready = input('Are you ready to start?');
Screen(window,'TextSize',30);
vbl = Screen('Flip', window);

%% Run Demo.m or Experiment.m
if Demo ~= 1 && Modality == 3
    run Experiment.m;
elseif Demo ~= 1 && Modality ~= 3
    run UniExperiment
else
    run Demonstration.m
end
            

%% prepare the end of the experiment

DrawFormattedText(window, 'ENDE','center','center',Color.back);
Screen('Flip',window);

if Demo ~=1
    if Modality == 1
        save([saveplace, num2str(VPno),FileName,'.mat'])
    elseif Modality == 2
        save([saveplace, num2str(VPno),FileName,'.mat'])
    elseif Pract == 3
        save([saveplace, num2str(VPno),FileName,'.mat'])
    end
else
    save([saveplace, num2str(VPno),'Demo','.mat'])
end



sca;






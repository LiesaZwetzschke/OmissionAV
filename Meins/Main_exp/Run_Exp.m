%%% Run Experiment Omission AV %%%



% Clear the workspace and the screen
close all;
clearvars;

% Randomize clock
rand('state', sum(100*clock));


try
% Where to save data
saveplace = 'C:\Users\Liesa\Desktop\Marlene_script\Meins\Data';
toSave = ["data",'answer', 'sound', 'visual', 'standardposition', 'rareposition', 'TrialParamsRand'];

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
ITI = 1;
%%% window configurations
Color.back = [0 0 0];
Color.fix = [255 255 255];
Color.text = [255 255 255];
Color.gray = [60 60 60];
Color.grid = [255 0 0 1];


%%% Stimuli configuration
sound.dur = 1.25;
sound.freq = [200 600];
sound.fs = 44100;
sound.volum = 1;
sound.nrchannels = 2;
sound.break = 0.2;

visual.dur = 0.5;
visual.pos = [480 300; 
            1440 300;
            480 900;
            1440 900];
visual.rSize = 150;
visual.cycles = 5;
visual.angle = [90 0];

% Prep for gabor
freq = visual.cycles/visual.rSize;
sigma = visual.rSize/7;
propertiesMat = [0, freq, sigma, 1, 1, 0, 0, 0];
%[phase, freq, sigma, contrast, aspectRatio, 0, 0, 0]

%% Trial parameter
% Auditory freq. || visual position || omission || catch-trial(1 = no, 2 = yes) || trigger


TrialParams = [1 0 0 1 101; % Auditory only
    2 0 0 1 201;
    1 0 0 2 102;
    2 0 0 2 202;
    % Visual only
    0 1 0 1 10;
    0 2 0 1 20;
    0 1 0 2 12;
    0 2 0 2 22;
    % bimodal
    1 1 0 1 110;
    1 2 0 1 120;
    1 3 0 1 130;
    1 4 0 1 140;
    2 1 0 1 210;
    2 2 0 1 220;
    2 3 0 1 230;
    2 4 0 1 240;
    %omission
    1 0 1 1 1;
    2 0 1 1 2];

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
Nreps.catch = 10;     % 2/4 times (catch)
Nreps.stan = 420;     % 2 times (A1V1, A2V2)
Nreps.target = 24;    % 6 times (A1V2,3,4 A2V1,3,4)
Nreps.omis = 108;      % 2 times (A1V- A2V-)
Nreps.demo = 10;      % 10 times (possible stimuli combis in the experiment)


switch Modality
    case 1 %auditory only
        Aud = 1;
        Vis = 0;
        Filename = ('AuditoryOnly');
    case 2 %visual only
        Aud = 0;
        Vis = 1;
        visual.pos = [standardposition; rareposition];
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
    TrialParamsRand = [repmat(TrialParams(1:2,:),Nreps.uni,1);...
        repmat(TrialParams(3:4,:),Nreps.catch,1)];
elseif Demo ~= 1 && Modality == 2
    TrialParamsRand = [repmat(TrialParams(5:6,:), Nreps.uni,1);...
        repmat(TrialParams(7:8,:), Nreps.catch,1)];
elseif Demo ~= 1 && Modality == 3
    TrialParamsRand = [repmat(TrialParams([9, 14],:), Nreps.stan,1);...
        repmat(TrialParams([10:13,15:16],:),Nreps.target,1);...
        repmat(TrialParams(17:18,:), Nreps.omis,1)];
elseif Demo == 1
    TrialParamsRand = repmat(TrialParams(9:18,:), Nreps.demo,1);
end

       
% randomize the order of trials
TrialParamsRand = TrialParamsRand(randperm(size(TrialParamsRand,1)),:);

%%% HOW TO RANDOMIZE BUT DON'T REPEAT 2???
            

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

%% create Gabor patches
for i = 1: length(visual.pos)
    [gaborid, desRect] = createGabor(window, visual.pos(i,:,:), visual.rSize);
    visual.gabor(i,:) = [gaborid, desRect];
end

%% Initialize sound
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], [], 0, sound.fs, sound.nrchannels);

%% create Sounds
for i = 1:length(sound.freq)
    [wave] = createSound(sound.fs,sound.dur, sound.freq(i), 1);
    sound.tact(:,:,i) = [wave; wave];
end
for i = 1:length(sound.freq)
    [wavebr] = createSound(sound.fs,sound.dur, sound.freq(i), 2, sound.break);
    sound.tact(:,:,i+2) = [wavebr; wavebr];
end

DrawFormattedText(window, 'Bitte warten','center', 'center',Color.text);
         
Screen('Flip',window);


% Initializing of Trial
Ready = input('Are you ready to start?');
Screen(window,'TextSize',30);
vbl = Screen('Flip', window);

%% Run Demo.m or Experiment.m
if Demo ~= 1 && Modality == 3
    run Experiment.m;
elseif Demo ~= 1 && Modality ~= 3
    run UniExperiment.m
else
    run Demonstration.m
end
            

%% prepare the end of the experiment

DrawFormattedText(window, 'ENDE','center','center',Color.text);
Screen('Flip',window);

if Demo ~=1
    if Modality == 1
        save(fullfile(saveplace, ['VP', num2str(VPno),Filename,datestr(now,'DDmmYY'),'.mat']),...
            'data','answer', 'sound', 'visual', 'standardposition', 'rareposition', 'TrialParamsRand')
    elseif Modality == 2
        save(fullfile(saveplace, ['VP', num2str(VPno),Filename,datestr(now,'DDmmYY'),'.mat']),...
            'data','answer', 'sound', 'visual', 'standardposition', 'rareposition', 'TrialParamsRand')
    elseif Modality == 3
        save(fullfile(saveplace, ['VP', num2str(VPno),Filename,datestr(now,'DDmmYY'),'.mat']),...
            'data','answer', 'sound', 'visual', 'standardposition', 'rareposition', 'TrialParamsRand')
    end
else
    save(fullfile(saveplace, ['VP', num2str(VPno),'Demo',datestr(now,'DDmmYY'),'.mat']),...
        'data','answer', 'sound', 'visual', 'standardposition', 'rareposition', 'TrialParamsRand') 
end


KbWait;

sca;
catch ME
   disp(ME);
   % disp(MExc.stack.file);
   %cd([cd, '\skripts\main experiment\' ])
   PsychPortAudio('Close',pahandle);
   %ShowCursor;
   sca; 
   ME.message
   ME.stack.name
   ME.stack.line
   save('error.mat', 'ME')
   error('Oops somethint wrong, s. above');
end


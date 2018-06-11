%% Script for the demonstration/ exercise (Run_Experiment.m)%%
KbName('UnifyKeyNames');
corrkey = [32];
spaceKey = KbName('space');
escKey = KbName('escape');
twait = 2;
activeKeys = [KbName('space') KbName('escape')];


% restrict the keys for keyboard input to the keys we want
RestrictKeysForKbCheck(activeKeys);
% suppress echo to the command line for keypresses
ListenChar(2);

answer = [];
for i = 1: length(TrialParamsRand)
    if TrialParamsRand(i,1,:) == TrialParamsRand(i,2,:)
        answer(i,1) = 1;
    else
        answer(i,1) = 2;
    end
end

instructionText = ['In diesem Block werden dir sowohl Töne als auch Kreise präsentiert.'...
    '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
    '\nZu Beginn werden dir zwei unterschiedliche Ton-Kreis-Kombinationen präsentiert.'...
    '\nBitte präge dir diese Kombinationen ein. Im Anschluss wird es nämlich deine Aufgabe sein, auf alle Kombinationen,'...
    '\ndie nicht diesen beiden Kombinationen entsprechen mit einem Leertastendruch zu reagieren.'...
    '\nWie in den anderen beiden Blocks, hast du nach jedem Durchgang die Möglichkeit zu antworten.'...
    '\nBitte sei so akkurat wie möglich.'...
    '\nIn manchen Durchgängen wird dir nur ein einzelner Ton präsentiert, auf diese musst du ebenfalls nicht reagieren.']; 

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text);
Screen('Flip', window);
KbStrokeWait;

exit=0;
trial = 1

for i = 1:nBlocks
    while trial <= length(TrialParamsRand) && exit == 0;
        
        pahandle = PsychPortAudio('Open', [], [], 0, sound.fs, sound.nrchannels);

        rise = [0:sound.fs/5]/(sound.fs/5);
        Env = [rise  ones(1,(sound.dur*sound.fs-2*length(rise)))  fliplr(rise)];
        wave.tact = (sin(2.*pi.*sound.freq(TrialParamsRand(i,1))* [0:1/sound.fs:sound.dur-1/sound.fs])).* Env;
        wave.tact = [wave.tact;wave.tact];
        
        PsychPortAudio('FillBuffer', pahandle, wave.tact);             % this takes less than 1 ms
        
        Screen('FillRect',window, Color.back);
        DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
        
        PsychPortAudio('Start', pahandle, 0,0,0); 
        Screen('Flip',window);
        WaitSecs(0.75);
        
        if TrialParamsRand(i,2) ~= 0
            createGabor(visual.dur, window, visual.pos(TrialParamsRand(i,2),:), visual.rSize, visual.cycles, ifi);
        else
            backflip(window, visual.dur, Color.gray, Color.text, ifi)
        end
        PsychPortAudio('Stop', pahandle);
        
        
        Screen('FillRect', window, Color.back);
        DrawFormattedText(window, 'Zielkombination?',...
                            'center', 'center', Color.text);
        Screen('Flip', window);
        tStart = GetSecs;
        
        rsp.keyCode = [];
        rsp.keyName = [];
        rsp.corr = [];
        
        timedout = false;
        keyIsDown = 0;  
        
        while ~timedout
            [keyIsDown, keyTime, keyCode] = KbCheck;
            %FlushEvents('keyDown');
            %if keyIsDown
            %nKeys = sum(keyCode);
            if keyIsDown == 1
                if keyCode(spaceKey)
                    keypressed=find(keyCode);
                    break;
                elseif keyCode(escKey)
                    %ShowCursor;
                    fclose(outfile);  Screen('CloseAll'); return
                end
                keyIsDown=0; keyCode=0;
            end
            if ((keyTime - tStart) > twait)
                timedout = true;
            end
         end
         for j = 1:length(TrialParamsRand)
             if (keypressed==corrkey(1)&&answer(j)==1) % pressed key correct or not
                 rsp.corr(i)=1;
                 DrawFormattedText(window, 'Korrekt!', 'center', 'center', Color.back);
             else
                 rsp.corr(i)=0;
                 DrawFormattedText(window, 'Falsch!', 'center', 'center', Color.back);
             end
         end
         
    Screen('Flip', window);
    exit=1;
    
    end
        
    trial=trial+1;
        
end
% if the wait for presses is in a loop, 
% then the following two commands should come after the loop finishes
% reset the keyboard input checking for all keys
RestrictKeysForKbCheck;
% re-enable echo to the command line for key presses
% if code crashes before reaching this point 
% CTRL-C will reenable keyboard input
ListenChar(1)

    KbWait;   
end
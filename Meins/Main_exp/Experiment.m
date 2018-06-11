%%%% Experiment Omission AV (Run_Exp.m) %%%%

instructionText = ['In diesem Block werden dir sowohl Töne als auch Kreise präsentiert.'...
    '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
    '\nDeine Aufgabe ist die selbe wie in der Übung. \nBitte sei so akkurat wie möglich.']; 

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text,30);
Screen('Flip', window);
KbStrokeWait;

% DrawFormattedText(window, 'Wait', 'center','center', Color.text);
% Screen('Flip', window);


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
                        DrawFormattedText(window, 'Ja',...
                            screenWidth/4,screenHeight/2 + 50,Color.text);
                        DrawFormattedText(window, 'Nein',...
                            screenWidth/4*3,screenHeight/2 + 50,Color.text);
        Screen('Flip', window);
        
        
        [~,keyCode]=KbStrokeWait;
        if strcmp(KbName(keyCode), 'ESCAPE')
           exit=1;
        end
        trial=trial+1;
    end
    
    KbWait;   
end


%% final screen
PsychPortAudio('Close',pahandle);
Screen('Flip',window);
DrawFormattedText(window,'The End. Vielen Dank für deine Teilnahme!','center','center');
Screen('Flip',window);

WaitSecs(0.5);



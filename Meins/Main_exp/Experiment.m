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



for j = 1:nBlocks
    for i = 1:length(TrialParamsRand)
        
        pahandle = PsychPortAudio('Open', [], [], 0, sound.fs, sound.nrchannels);

        wave = createSound(sound.fs,sound.dur, sound.freq(TrialParamsRand(i,1)), TrialParamsRand(i,4), sound.break);
        sound.tact = [wave; wave];
        
        PsychPortAudio('FillBuffer', pahandle, sound.tact);             % this takes less than 1 ms
        
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
      
       
    end
    DrawFormattedText(window, ['Ende Blocknr.' num2str(j)], 'center', ...
    'center', Color.text,30);
    Screen('Flip', window);
    KbWait; 
end
    
 
%% final screen
PsychPortAudio('Close',pahandle);
Screen('Flip',window);
DrawFormattedText(window,'The End. Vielen Dank für deine Teilnahme!','center','center');
Screen('Flip',window);

WaitSecs(0.5);



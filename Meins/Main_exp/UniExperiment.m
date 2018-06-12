%%% Script for the unisensory condition (Run_Experiment.m) %%%
KbName('UnifyKeyNames');
corrKey = [32];
spaceKey = KbName('space');
escKey = KbName('escape');
twait = ITI;
activeKeys = [KbName('space') KbName('escape')];

% restrict the keys for keyboard input to the keys we want
RestrictKeysForKbCheck(activeKeys);
% suppress echo to the command line for keypresses
ListenChar(2);

answer = [];
for k = 1: length(TrialParamsRand)
    if TrialParamsRand(k,4,:) == 1
        answer(k,1) = 1;
    else
        answer(k,1) = 2;
    end
end

if Modality == 1
    instructionText = ['In diesem Block werden dir Töne präsentiert.'...
        '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
        '\nDeine Aufgabe ist zu erkennen ob die Töne eine kurze Pause enthielten.',...
        '\nBitte sei so akkurat wie möglich.'];
else
    instructionText = ['In diesem Block werden dir Kreise präsentiert.'...
        '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
        '\nDeine Aufgabe ist zu erkennen ob die Streifen des Kreises vertikal verlaufen.',...
        '\nBitte sei so akkurat wie möglich.'];
end

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text,30);
Screen('Flip', window);
KbStrokeWait;



for i = 1:length(TrialParamsRand)
        
        switch Modality
            case 1
                pahandle = PsychPortAudio('Open', [], [], 0, sound.fs, sound.nrchannels); 
        
           
                wave = createSound(sound.fs,sound.dur, sound.freq(TrialParamsRand(i,1)), TrialParamsRand(i,4), sound.break);
                sound.tact = [wave; wave];
        
                PsychPortAudio('FillBuffer', pahandle, sound.tact);             % this takes less than 1 ms
        
                Screen('FillRect',window, Color.back);
                DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
                
                PsychPortAudio('Start', pahandle, 0,0,0); 
                Screen('Flip',window);
                WaitSecs(0.65);
                
                backflip(window, visual.dur, Color.gray, Color.text, ifi);
                
                PsychPortAudio('Stop', pahandle);
                
                         
            case 2
                Screen('FillRect',window, Color.back);
                DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross

                Screen('Flip',window);
                WaitSecs(0.75);

                createGabor(visual.dur, window, visual.pos(TrialParamsRand(i,2),:), visual.rSize, visual.cycles,...
                    ifi, TrialParamsRand(i,4));
                   
               
        end
        Screen('FillRect', window, Color.back);
        DrawFormattedText(window, 'Veränderung?','center', 'center', Color.text);
        Screen('Flip', window);
        tStart = GetSecs;
        
        rsp.keyCode = [];
        rsp.keyName = [];
        rsp.corr = [];
        
        timedout = false;
               
        while ~timedout
            [keyIsDown, keyTime, keyCode] = KbCheck;
            FlushEvents('keyDown');
            %if keyIsDown
            %nKeys = sum(keyCode);
            if keyIsDown
                nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(spaceKey)
                        keypressed=find(keyCode);
                        rsp.keyCode = keypressed;
                        rsp.keyName = KbName(keypressed);
                        break;
                        elseif keyCode(escKey)
                        %ShowCursor;
                        RestrictKeysForKbCheck; ListenChar(1); Screen('CloseAll'); return
                        end
                    end
                keyIsDown=0; keyCode=0;          
            end
            if ((keyTime - tStart) > twait)
                keypressed = 0;
                timedout = true;
                rsp.keyCode = keypressed; rsp.keyName = 'None';
                break;
            end
         end
         if keypressed == 0 && answer(i)==2 || keypressed == corrKey(1) && answer(i)==1 % pressed key correct or not
             rsp.corr=1;
             DrawFormattedText(window, 'Korrekt!', 'center', 'center', Color.text);
             Screen('Flip', window);
         else
             rsp.corr=0;
             DrawFormattedText(window, 'Falsch!', 'center', 'center', Color.text);
             Screen('Flip', window);
         end
          
        data.demo.trial(i) = i;
        data.demo.keyCode(i) = rsp.keyCode;
        data.demo.keyName{i} = rsp.keyName;
        data.demo.corr(i) = rsp.corr;
        keypressed = 0; 

        WaitSecs(ITI);
        
        if mod(i,50) == 0
           DrawFormattedText(window, ['Ende Blocknr.' num2str(i)], 'center', ...
                             'center', Color.text,30);
           Screen('Flip', window);
           KbWait;
        end
    
       
end


PsychPortAudio('Close',pahandle);

KbWait; 
%% Script for the demonstration/ exercise (Run_Experiment.m)%%
KbName('UnifyKeyNames');
corrKey = [32];
spaceKey = KbName('space');
escKey = KbName('escape');
twait = ITI;
activeKeys = [KbName('space') KbName('escape')];
m = 1;


% restrict the keys for keyboard input to the keys we want
RestrictKeysForKbCheck(activeKeys);
% suppress echo to the command line for keypresses
ListenChar(2);

answer = [];
for k = 1: length(TrialParamsRand)
    if TrialParamsRand(k,1,:) == TrialParamsRand(k,2,:) 
        answer(k,1) = 1;
    elseif TrialParamsRand(k,2,:) == 0
        answer(k,1) = 1;
    else
        answer(k,1) = 2;
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


    while m < 3
        
        Screen('FillRect', window, Color.back);
        DrawFormattedText(window, ['Standardposition ', num2str(m)],...
                            'center', 'center', Color.text);
        Screen('Flip',window);               
        KbWait;
        
        PsychPortAudio('FillBuffer', pahandle, sound.tact(:,:,m));             % this takes less than 1 ms
               
        Screen('FillRect',window, Color.back);
        Screen(window,'TextSize',50);
        DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
        
        PsychPortAudio('Start', pahandle, 1,0,0); 
        Screen('Flip',window);
        WaitSecs(0.75);
               
        Screen('FillRect', window, Color.gray);
        Screen('DrawTexture', window, visual.gabor(m),[] ,...
                    visual.gabor(m,2:5), visual.angle(1),...
                    [],[],[],[],[],propertiesMat);
        DrawFormattedText(window,'+','center','center',Color.fix);
        Screen('DrawingFinished', window);
        Screen('Flip', window);
                
        WaitSecs(0.49);
        
        PsychPortAudio('Stop', pahandle);
        
        m = m+1;
        
    end

    k = 1;
for i = 1:length(TrialParamsRand)
    if i ==1
        Screen('FillRect',window, Color.back);
        DrawFormattedText(window,'Bereit?','center','center', Color.fix);
        Screen('Flip',window);
        KbWait;
    end
    
        Screen('FillRect',window, Color.back);
        Screen(window,'TextSize',50);
        DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
        Screen('Flip',window);
        WaitSecs(ITI);
        
        
        
        PsychPortAudio('FillBuffer', pahandle, sound.tact(:,:,TrialParamsRand(i,1)));             % this takes less than 1 ms
        
        Screen('FillRect',window, Color.back);
        Screen(window,'TextSize',50);
        DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
        PsychPortAudio('Start', pahandle, 1,0,0);
        Screen('Flip',window);
        
        WaitSecs(0.73);
                
        Screen('FillRect', window, Color.gray);
        if TrialParamsRand(i,2)~=0
            Screen('DrawTexture', window, visual.gabor(TrialParamsRand(i,2)),[] ,...
                    visual.gabor(TrialParamsRand(i,2),2:5), visual.angle(TrialParamsRand(i,4)),...
                    [],[],[],[],[],propertiesMat);
        end
        DrawFormattedText(window,'+','center','center',Color.fix);
        Screen('DrawingFinished', window);
        Screen('Flip', window);
                
        WaitSecs(0.49);
                

        
        PsychPortAudio('Stop', pahandle);
        
        
        Screen('FillRect', window, Color.back);
        Screen(window,'TextSize',50);
        DrawFormattedText(window, '?',...
                            'center', 'center', Color.text);
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
         if keypressed == 0 && answer(i)==1 || keypressed == corrKey(1) && answer(i)==2 % pressed key correct or not
             rsp.corr=1;
             DrawFormattedText(window, 'Korrekt!', 'center', 'center', Color.back); %black letters
             Screen('Flip', window);
         else
             rsp.corr=0;
             DrawFormattedText(window, '!', 'center', 'center', Color.text);
             Screen('Flip', window);
         end
    
    WaitSecs(ITI/2);
         
    data.demo.trial(i) = i;
    data.demo.keyCode(i) = rsp.keyCode;
    data.demo.keyName{i} = rsp.keyName;
    data.demo.corr(i) = rsp.corr;
    data.demo.ans = answer;
    keypressed = 0; 
    
    
    if mod(i,25) == 0
        DrawFormattedText(window, ['Ende Trialnr. ' num2str(i)], 'center', ...
    'center', Color.text,30);
    Screen('Flip', window);
    disp(['MEAN CORRECT ' num2str(sum(data.demo.corr(1+(i-i*(1/k)):i))/i)]);
    k = k+1;
    KbWait;
    end
    
end
         


% if the wait for presses is in a loop, 
% then the following two commands should come after the loop finishes
% reset the keyboard input checking for all keys
RestrictKeysForKbCheck;
% re-enable echo to the command line for key presses
% if code crashes before reaching this point 
% CTRL-C will reenable keyboard input
ListenChar(1)
PsychPortAudio('Close',pahandle);


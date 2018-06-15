%%%% Experiment Omission AV (Run_Exp.m) %%%%

%% Define keys for responding
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
    '\nDeine Aufgabe ist die selbe wie in der Übung. \nBitte sei so akkurat wie möglich.']; 

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text,30);
Screen('Flip', window);
KbStrokeWait;

% DrawFormattedText(window, 'Wait', 'center','center', Color.text);
% Screen('Flip', window);



    for i = 1:length(TrialParamsRand)
        Screen('FillRect',window, Color.back);
        Screen(window,'TextSize',50);
        DrawFormattedText(window,'+','center','center', Color.fix);      % present fixation cross
        Screen('Flip', window);
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
                        RestrictKeysForKbCheck; ListenChar(1); return;
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
             DrawFormattedText(window, 'Korrekt!', 'center', 'center', Color.back); %Black letters
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
    
    
    if mod(i,100) == 0
    DrawFormattedText(window, ['Ende Blocknr. ' num2str(i/100)], 'center', ...
        'center', Color.text,30);
    Screen('Flip', window);
    KbWait;
    end
    
    end

    
 
%% final screen
PsychPortAudio('Close',pahandle);
Screen('Flip',window);
DrawFormattedText(window,'The End. Vielen Dank für deine Teilnahme!','center','center');
Screen('Flip',window);

% if the wait for presses is in a loop, 
% then the following two commands should come after the loop finishes
% reset the keyboard input checking for all keys
RestrictKeysForKbCheck;
% re-enable echo to the command line for key presses
% if code crashes before reaching this point 
% CTRL-C will reenable keyboard input
ListenChar(1)

KbWait;



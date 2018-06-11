%% Function to present just the backflip in case omission or auditory only 
function [y] = backflip(window, duration, color, crossColor, ifi)

nFrames = duration/ifi;

topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
vbl = Screen('Flip', window);

for t = 1:nFrames;
    
    % Create gabor and fixation cross
    Screen('FillRect', window, color);
    DrawFormattedText(window,'+','center','center',crossColor);
    
    Screen('DrawingFinished', window);
    vbl = Screen('Flip', window, vbl + ifi/2);
    t = t+1;
end


Priority(0);
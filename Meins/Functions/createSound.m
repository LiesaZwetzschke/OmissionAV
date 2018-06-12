function [wave] = createSound(fs,duration, freq, posbreak, breakl)

% Default arguments
if nargin<5 || isempty(breakl)
    breakl = 0;
end

rise = [0:fs/5]/(fs/5);
Env = [rise  ones(1,(duration*fs-2*length(rise)))  fliplr(rise)];
wave = (sin(2.*pi.*freq* [0:1/fs:duration-1/fs])).* Env;


if posbreak == 1
    BreakL = fs*breakl;
    Pos = randi([fs/5,length(wave)- fs/5],1,1);
    wave(Pos:Pos+BreakL)= 0;
end
end
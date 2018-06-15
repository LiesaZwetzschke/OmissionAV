function [wave] = createSound(fs,duration, freq, posbreak, breakl)
format bank
% Default arguments
if nargin<5 || isempty(breakl)
    breakl = 0;
end

rise = [0:fs/12]/(fs/12);
Env = [rise  ones(1,(duration*fs-2*length(rise)))  fliplr(rise)];
wave = (sin(2.*pi.*freq* [0:1/fs:duration-1/fs])).* Env;

risebreak = [0:fs/12]/(fs/12);
BreakEnv = [fliplr(risebreak)  zeros(1,(breakl*fs-2*length(risebreak)))  risebreak];
Imin = floor(length(wave)/3);
Imax = floor(Imin + length(BreakEnv));

if posbreak == 2
    Pos = randi([Imin,Imax],1,1); %break can not appear in the first and last third of the sound duration
    wave(Pos:Pos+length(BreakEnv)-1) = wave(Pos:Pos+length(BreakEnv)-1).* BreakEnv;
end
end
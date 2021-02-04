function y = loadFile(filename)
%  y = loadFile(filename)
% Reads complex samples from the rtlsdr file
fid = fopen(filename,'rb');
y = fread(fid,'uint8=>double');

y = y-127.5; % Convert to 8-bit unsigned 
y = y(1:2:end) + i*y(2:2:end); % Readable IQ Data to work with in Matlab 
% Odd samples are real data, and Even samples are Imag data 
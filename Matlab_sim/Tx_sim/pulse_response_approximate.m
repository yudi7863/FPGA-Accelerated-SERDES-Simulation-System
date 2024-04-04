clc
clear
h = [1, 0.2, 0.1];
approximation = zeros(length(h),2);

%%%
%for i=1:length(h)
%    for y=0:7
%        if mod(h(i),2.^((-1)*y))==0
%            approximation(i,2)=y;
%            approximation(i,1)=h(i)/2.^((-1)*y);
%            break;
%        else
%            x=floor(h(i)/2.^((-1)*y));
%            h_appro=x*2.^((-1)*y);
%            if h(i)-h_appro <=0.01
%                approximation(i,2)=y;
%                approximation(i,1)=x;
%                break;
%            end
%        end
%    end
%end

y = 8;
for i=1:length(h)
    x=round(h(i)/2.^((-1)*y));
    approximation(i,2)=y;
    approximation(i,1)=x;
end
approximation

filename = 'pulse_resp_appro.mem';
fileID = fopen(filename,'w');

for j= 1:length(h)
    binVal_x = dec2bin(approximation(j,1),16);
    binVal_y = dec2bin(approximation(j,2),16);
    fprintf(fileID, '%s%s\n',binVal_x,binVal_y);
end

fclose(fileID);
output_file = filename;